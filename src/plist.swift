import Foundation

class Plist {
  private(set) var keyStack: [PlistKey]
  private(set) var tree: Any
  let root: Any

  init(root: Any) {
    self.root = root
    keyStack = []
    tree = root
  }

  private func restructTree() {
    var tree = root
    for key in keyStack {
      if getPlistValueType(tree) == .dictionary {
        tree = (tree as! NSDictionary)[key as! String]
        continue
      }
      if getPlistValueType(tree) == .array {
        tree = (tree as! NSArray)[key as! Int]
        continue
      }
      fputs("Plist.keyStack is invalid", stderr)
      exit(1)
    }
    self.tree = tree
  }

  func pushKey(_ key: PlistKey) {
    keyStack.append(key)
    restructTree()
  }

  func popKey() {
    keyStack.removeLast()
    restructTree()
  }

  func treeKeys()-> [PlistKey] {
    if treeType == .dictionary {
      return keys(tree: tree as! NSDictionary)
    }
    if treeType == .array {
      let lastIndex = (tree as! NSArray).count - 1
      if lastIndex > 0 {
        return [Int](0...lastIndex)
      }
    }
    return []
  }

  private func keys(tree: NSDictionary) -> [String] {
    let dictionaryOrder = { (a: Any, b: Any) -> Bool in
      a as! String > b as! String
    }
    let toString = { (any: Any) -> String in String(describing: any) }

    let keys: [String] = tree.allKeys.map(toString).sorted(by: dictionaryOrder)
    return keys
  }

  var treeType: PlistValueType {
    get {
      return getPlistValueType(tree)
    }
  }

  var domain: String {
    get {
      return keyStack[0] as! String
    }
  }
}
