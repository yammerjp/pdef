import Foundation

enum StringifyFormat: Int {
  case plistBuddy
  case defaults
}

enum PlistBuddyCommand: String {
  case Add
  case Delete
}

class ShellScriptCreator {
  let domainPlist: DomainPlist

  init(_ domainPlist: DomainPlist) {
    self.domainPlist = domainPlist
    if path.count < 2 {
      ErrorMessage("# treePath.count < 2. skip")
    }
  }

  var plist: Plist {
    return domainPlist.descendant.plist
  }

  var path: [PlistKey] {
    return domainPlist.descendant.path
  }

  var domain: String {
    return path[0] as! String
  }

  var key: String {
    return path[1] as! String
  }

  func add() {
    if path.count == 2, !plist.isParent || plist.childsAreString() {
      defaultsWrite(typeOption: plist.type == .real ? "float" : "\(plist.type)")
      return
    }
    if path.count == 3, plist.type == .string {
      defaultsWrite(typeOption: path[2] is Int ? "array-add" : "dict-add \"\(path[2] as! String)\"")
      return
    }

    exportAndImport { tmpFile in
      if let arrayKeyPathes = plist.containsArray(path: path) {
        for arrayKeyPath in arrayKeyPathes {
          plistBuddy(command: .Add, path: arrayKeyPath, typeAndValue: "array", tmpFile: tmpFile)
        }
      }
      for baby in plist.babys(path: path) {
        if baby.plist.type == .data {
          plistBuddyAddData(path: baby.path, value: baby.plist.tree as! Data, tmpFile: tmpFile)
          continue
        }
        let value = baby.plist.string(format: .plistBuddy)
        plistBuddy(command: .Add, path: baby.path, typeAndValue: "\(baby.plist.type) \(value)", tmpFile: tmpFile)
      }
    }
  }

  func delete() {
    if path.count == 2 {
      print("defaults delete \(domain) \"\(key)\"")
      return
    }
    exportAndImport { tmpFile in
      plistBuddy(command: .Delete, path: path, typeAndValue: "", tmpFile: tmpFile)
    }
  }

  func update() {
    print("# update is called. path: \(path.string(separator: ".")) value: \(plist)")
  }

  private func defaultsWrite(typeOption: String) {
    let valueString = plist.string(format: .defaults)
    print("defaults write \(domain) \"\(key)\" -\(typeOption) \(valueString)")
  }

  private func exportAndImport(_ plistBuddys: (_ tmpFile: String) -> Void) {
    let tmpFile = "tmp"
    print("defaults export \(domain) \(tmpFile)")
    plistBuddys(tmpFile)
    print("defaults import \(domain) \(tmpFile)")
    print("rm \(tmpFile)")
  }

  private func plistBuddy(command: PlistBuddyCommand, path: [PlistKey], typeAndValue: String, tmpFile: String) {
    let pathString = path.dropFirst().map { $0 }.plistBuddyPath()
    print("/usr/libexec/PlistBuddy -c '\(command) \(pathString) \(typeAndValue)' \(tmpFile)")
  }

  private func plistBuddyAddData(path: [PlistKey], value: Data, tmpFile: String){
    let valueBase64 = value.base64EncodedString().escapeSlash()
    let dummy = "PatchDefaultsReplace"
    let dummyBase64 = dummy.data(using: .utf8)?.base64EncodedString()
    plistBuddy(command: .Add, path: path, typeAndValue: "data \"\(dummy)\"", tmpFile: tmpFile)
    print("sed -e 's/\(dummyBase64!)/\(valueBase64)/' -i  \"\" \(tmpFile)")
  }
}

fileprivate extension Array where Element == PlistKey {
  func plistBuddyPath() -> String {
    let escapedKeys = map { key -> PlistKey in
      if key is Int {
        return key
      }
      let keyString = key as! String
      if keyString.contains("\"") || keyString.contains("'") {
        ErrorMessage("# Plist key include quote or double quote. Not support to Escape quote or double quote")
      }
      return "\"\(keyString)\""
    }
    return escapedKeys.string(separator: ":")
  }
}

fileprivate extension Plist {
  func string(format: StringifyFormat) -> String {
    switch type {
    case .string:
      return "\"\(tree as! String)\""
    case .integer:
      return "\(tree as! Int)"
    case .real:
      return "\(tree as! Float)"
    case .bool:
      return tree as! Bool ? "true" : "false"
    case .data:
      return "\"\( (tree as! Data).hexEncodedString() )\""
    case .date:
      return (tree as! Date).string(format: format)
    case .array:
      return "\"" + (tree as! [String]).joined(separator: "\" \"") + "\""
    case .dict:
      return keys().map { key -> String in
        let value = childPlist(key: key).tree as! String
        return "\"\(key as! String)\" \"\(value)\""
      }.joined(separator: " ")
    }
  }
}

fileprivate extension Data {
  func hexEncodedString() -> String {
    return map { String(format: "%02hhx", $0) }.joined()
  }
}

fileprivate extension Date {
  func string(format: StringifyFormat) -> String {
    if format == .defaults {
      return ISO8601DateFormatter().string(from: self)
    }
    let posixFormatter = DateFormatter()
    posixFormatter.locale = Locale(identifier: "en_US_POSIX")
    posixFormatter.dateFormat = "E MMM dd HH:mm:ss yyyy z"
    return posixFormatter.string(from: self)
  }
}

fileprivate extension String {
  func escapeSlash() -> String {
    let slash = "/"
    let escapedSlash = "\\/"
    return replacingOccurrences(
      of: slash,
      with: escapedSlash
    )
  }
}
