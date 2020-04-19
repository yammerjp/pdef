import Foundation

enum DateFormat: Int {
  case long
  case iso8601
}

class ShellScriptCreator {
  static func add(treePath: [PlistKey], tree: Plist) {
    // print("add is called. path: \(treePath.string(separator: ".")) value: \(tree)")
    if treePath.count < 2 {
      fputs("# treePath.count < 2. skip", stderr)
      exit(1)
    }
    if treePath.count == 2 && ( !tree.plistValueIsParent() || tree.allValueIsString() ) {
      let domain = treePath[0] as! String
      let key = treePath[1] as! String
      let typeOption = tree.type == .real ? "float" : "\(tree.type)"
      let value = tree.string(date: .iso8601)
      print("defaults write \(domain) \"\(key)\" -\(typeOption) \(value)")
      return
    }
    if treePath.count == 3 && tree.type == .string {
      let domain = treePath[0] as! String
      let key = treePath[1] as! String
      let typeOption = treePath[2] is Int ? "array-add" : "dict-add \"\(treePath[2] as! String)\""
      let value = tree.string(date: .iso8601)
      print("defaults write \(domain) \"\(key)\" -\(typeOption) \(value)")
      return
    }
    let domain = treePath[0] as! String
    let keyPath = treePath.dropFirst().map{$0}
    let headValues = tree.headValues(path: keyPath)

    let tmpFile = "tmp"
    print("defaults export \(domain) \(tmpFile)")

    // add array
    if let arrayKeyPathes = tree.containsArray(path: keyPath) {
      for arrayKeyPath in arrayKeyPathes {
        let arrayKeyPathString = plistBuddyPath(keys: arrayKeyPath).string(separator: ":")
        print("/usr/libexec/PlistBuddy -c 'Add \(arrayKeyPathString) array ' \(tmpFile)")
      }
    }

    for headValue in headValues {
      let keyPath = plistBuddyPath(keys: headValue.path).string(separator: ":")
      let valueType = headValue.value.type
      let typeString = "\(valueType)"
      if valueType == .date || valueType == .data {
        fputs("# Not support that deep value type is data or date", stderr)
        exit(1)
      }
      let value = headValue.value.string(date: .iso8601)
      print("/usr/libexec/PlistBuddy -c 'Add \(keyPath) \(typeString) \(value)' \(tmpFile)")
    }

    print("defaults import \(domain) \(tmpFile)")
    print("rm \(tmpFile)")
  }

  static func delete(treePath: [PlistKey]) {
    if treePath.count < 2 {
      fputs("# treePath.count < 2. skip", stderr)
      exit(1)
    }
    if treePath.count == 2 {
      let domain = treePath[0] as! String
      let key = treePath[1] as! String
      print("defaults delete \(domain) \"\(key)\"")
      return
    }
    let domain = treePath[0] as! String
    let tmpFile = "tmp"
    let keyPath = plistBuddyPath(keys: treePath.dropFirst().map{$0}).string(separator: ":")

    print("defaults export \(domain) \(tmpFile)")
    print("/usr/libexec/PlistBuddy -c \"Delete \(keyPath)\" \(tmpFile)")
    print("defaults import \(domain) \(tmpFile)")
    print("rm \(tmpFile)")
  }

  private static func plistBuddyPath(keys: [PlistKey]) -> [PlistKey] {
    let escapedKeys = keys.map{key -> PlistKey in
      if key is Int {
        return key
      }
      let keyString = key as! String
      if keyString.contains("\"") || keyString.contains("'") {
        fputs("# Plist key include quote or double quote. Not support to Escape quote or double quote", stderr)
        exit(1)
      }
      return "\"\(keyString)\""
    }
    return escapedKeys
  }

  static func update(treePath: [PlistKey], tree: Plist) {
    print("# update is called. path: \(treePath.string(separator: ".")) value: \(tree)")
  }
}


fileprivate extension Plist {
  func string(date: DateFormat) -> String {
    let value = tree
    switch type {
      case .string:
        return "\"\(value as! String)\""
      case .integer:
        return "\(value as! Int)"
      case .real:
        return "\(value as! Float)"
      case .bool:
        return value as! Bool ? "true" : "false"
      case .data:
        return (value as! Data).hexEncodedString()
      case .date:
        if date == .iso8601 {
          return ISO8601DateFormatter().string(from: tree as! Date)
        }
        return DateFormatter().string(from: tree as! Date)
      case .array:
        return "\"" + (tree as! [String]).joined(separator: "\" \"") + "\""
      case .dict:
        return keys().map { key -> String in
          let value = subTree(path:[key]).tree as! String
          return "\"\(key as! String)\" \"\(value)\""
        }.joined(separator: " ")
    }
  }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
