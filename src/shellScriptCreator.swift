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
  let descendant: Descendant
  init(_ descendant: Descendant) {
    self.descendant = descendant
    if descendant.path.count < 2 {
      ErrorMessage("# treePath.count < 2. skip")
    }
  }

  var domain: String {
    return descendant.path[0] as! String
  }

  var key: String {
    return descendant.path[1] as! String
  }

  func add() {
    if descendant.path.count == 2, !descendant.plist.isParent || descendant.plist.childsAreString() {
      defaultsWrite(typeOption: descendant.plist.type == .real ? "float" : "\(descendant.plist.type)")
      return
    }
    if descendant.path.count == 3, descendant.plist.type == .string {
      defaultsWrite(typeOption: descendant.path[2] is Int ? "array-add" : "dict-add \"\(descendant.path[2] as! String)\"")
      return
    }

    exportAndImport { tmpFile in
      if let arrayKeyPathes = descendant.plist.containsArray(path: descendant.path) {
        for arrayKeyPath in arrayKeyPathes {
          plistBuddy(command: .Add, path: arrayKeyPath, typeAndValue: "array", tmpFile: tmpFile)
        }
      }
      for baby in descendant.plist.babys(path: descendant.path) {
        /*
        if baby.plist.type == .data {
          ErrorMessage("# Not support that deep value type is data")
        }
        */
        let value = baby.plist.string(format: .plistBuddy)
        plistBuddy(command: .Add, path: baby.path, typeAndValue: "\(baby.plist.type) \(value)", tmpFile: tmpFile)
      }
    }
  }

  func delete() {
    if descendant.path.count == 2 {
      print("defaults delete \(domain) \"\(key)\"")
      return
    }
    exportAndImport { tmpFile in
      plistBuddy(command: .Delete, path: descendant.path, typeAndValue: "", tmpFile: tmpFile)
    }
  }

  func update() {
    print("# update is called. path: \(descendant.path.string(separator: ".")) value: \(descendant.plist)")
  }

  private func defaultsWrite(typeOption: String) {
    let valueString = descendant.plist.string(format: .defaults)
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
