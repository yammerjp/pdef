import Foundation

class ShellScriptCreator {
  static func add(treePath: [PlistKey], tree: Any) {
    print("add is called. path: \(treePath.string(separator: ".")) value: \(tree)")
  }
  static func delete(treePath: [PlistKey]) {
    print("delete is called. path: \(treePath.string(separator: "."))")

  }
  static func update(treePath: [PlistKey], tree: Any) {
    print("update is called. path: \(treePath.string(separator: ".")) value: \(tree)")
  }
}

