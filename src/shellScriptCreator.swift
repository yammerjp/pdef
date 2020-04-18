import Foundation

class ShellScriptCreator {
  static func add(treePath: [PlistKey], tree: Any) {
    // print("add is called. path: \(treePath.string(separator: ".")) value: \(tree)")
    if treePath.count != 2 {
      print("# treePath.count != 2. skip")
      return
    }
    if plistValueIsParent(tree) && !InnerTree.allValueIsString(tree: tree) {
      print("# value is deep tree. skip")
      return
    }
    let domain = treePath[0] as! String
    let key = treePath[1] as! String
    let typeOption = "\(getPlistValueType(tree))"
    let value = string(value: tree)
    print("defaults write \(domain) \"\(key)\" -\(typeOption) \(value)")
  }

  static func delete(treePath: [PlistKey]) {
    if treePath.count != 2 {
      print("# treePath.count != 2. skip")
      return
    }
    let domain = treePath[0] as! String
    let key = treePath[1] as! String
    print("defaults delete \(domain) \"\(key)\"")
  }

  static func update(treePath: [PlistKey], tree: Any) {
    print("# update is called. path: \(treePath.string(separator: ".")) value: \(tree)")
  }

  static func string(value: Any) -> String {
    let type = getPlistValueType(value)
    switch type {
      case .string:
        return "\"\(value as! String)\""
      case .integer:
        return "\(value as! Int)"
      case .float:
        return "\(value as! Float)"
      case .bool:
        return value as! Bool ? "true" : "false"
      case .data:
        return (value as! Data).hexEncodedString()
      case .date:
        return ISO8601DateFormatter().string(from: value as! Date)
      case .array:
        return "\"" + (value as! [String]).joined(separator: "\" \"") + "\""
      case .dict:
        let keys = InnerTree.keys(tree: value)
        return keys.map { key -> String in
          let value = InnerTree.subTree(path:[key], rootTree: value) as! String
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
