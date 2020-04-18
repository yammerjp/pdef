import Foundation

class ShellScriptCreator {
  static func add(treePath: [PlistKey], tree: Any) {
    print("add is called. path: \(treePath.string(separator: ".")) value: \(tree)")
    switch treePath.count {
      case 0:
        fputs("treePath is empty", stderr)
        exit(1)
      case 1:
        //if getPlistValueType(tree) != .dictionary {
        if !(tree is NSDictionary) {
          fputs("Type of value '\(String(describing: tree))' of domain '\(treePath[0])' is not NSDictionary", stderr)
          exit(1)
        }
        let keys = InnerTree.keys(tree: tree)
        for key in keys {
          let value = String(describing:(tree as! NSDictionary)[key])
          print("defaults write \(treePath[0]) \(key) \(value)")
        }
      case 2:
        print("defaults write \(treePath[0]) \(treePath[1]) \(tree)")
      default :
        let tmpFile = "\"/tmp/patch-defaults/\(treePath.string())\""
        let pathPlutil = treePath.dropFirst(2).map{$0}
        let pathPlutilString = pathPlutil.string(separator: ".")
        let type = getPlistValueType(tree)

        print("defaults export \(treePath[0]) \(treePath[1]) - > \(tmpFile)")
        print("plutil -insert  \(pathPlutilString)) -\(type) \(tree) \(tmpFile)")
        print("defaults import \(treePath[0]) \(treePath[1])  \(tmpFile)")
    }
  }
  static func delete(treePath: [PlistKey]) {
    print("delete is called. path: \(treePath.string(separator: "."))")

  }
  static func update(treePath: [PlistKey], tree: Any) {
    print("update is called. path: \(treePath.string(separator: ".")) value: \(tree)")
  }
}

