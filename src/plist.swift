import Foundation

class Plist {
  let rootTree: Any
  private(set) var subTreePath: [PlistKey]
  private(set) var subTree: Any

  init(rootTree: Any) {
    self.rootTree = rootTree
    subTreePath = []
    subTree = rootTree
  }

  private func restructSubTree() {
    var tree = rootTree
    for key in subTreePath {
      if getPlistValueType(tree) == .dictionary {
        tree = (tree as! NSDictionary)[key as! String]
        continue
      }
      if getPlistValueType(tree) == .array {
        tree = (tree as! NSArray)[key as! Int]
        continue
      }
      fputs("Plist.subTreePath is invalid", stderr)
      exit(1)
    }
    subTree = tree
  }

  func pushKey(_ key: PlistKey) {
    subTreePath.append(key)
    restructSubTree()
  }

  func popKey() {
    subTreePath.removeLast()
    restructSubTree()
  }

  func subTreeKeys()-> [PlistKey] {
    if subTreeType == .dictionary {
      return keys(subTree: subTree as! NSDictionary)
    }
    if subTreeType == .array {
      let lastIndex = (subTree as! NSArray).count - 1
      if lastIndex > 0 {
        return [Int](0...lastIndex)
      }
    }
    return []
  }

  private func keys(subTree: NSDictionary) -> [String] {
    let dictionaryOrder = { (a: Any, b: Any) -> Bool in
      a as! String > b as! String
    }
    let toString = { (any: Any) -> String in String(describing: any) }

    let keys: [String] = subTree.allKeys.map(toString).sorted(by: dictionaryOrder)
    return keys
  }

  var subTreeType: PlistValueType {
    get {
      return getPlistValueType(subTree)
    }
  }

  var domain: String {
    get {
      return subTreePath[0] as! String
    }
  }
}
