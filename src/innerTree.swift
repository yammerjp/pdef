import Foundation

class InnerTree {
  static func keys(tree: Any) -> [PlistKey] {
    let treeType = getPlistValueType(tree)
    if treeType == .dict {
      return dictionaryKeys(tree: tree as! NSDictionary)
    }
    if treeType == .array {
      return arrayKeys(tree: tree as! NSArray)
    }
    return []
  }

  static func dictionaryKeys(tree: NSDictionary) -> [String] {
    let dictionaryOrder = { (a: Any, b: Any) -> Bool in
      a as! String > b as! String
    }
    let toString = { (any: Any) -> String in String(describing: any) }
    let keys: [String] = tree.allKeys.map(toString).sorted(by: dictionaryOrder)
    return keys
  }

  private static func arrayKeys(tree: NSArray) -> [Int] {
    let lastIndex = tree.count - 1
    if lastIndex <= 0 {
      return []
    }
    return [Int](0 ... lastIndex)
  }

  static func allValueIsString(tree: Any) -> Bool {
    let keys = self.keys(tree: tree)

    for key in keys {
      if getPlistValueType(subTree(path: [key], rootTree: tree)) != .string {
        return false
      }
    }
    return true
  }

  static func subTree(path: [PlistKey], rootTree: Any)-> Any{
    var tree = rootTree
    for key in path {
      if getPlistValueType(tree) == .dict {
        tree = (tree as! NSDictionary)[key as! String]
        continue
      }
      if getPlistValueType(tree) == .array {
        tree = (tree as! NSArray)[key as! Int]
        continue
      }
      fputs("TreePath '\(path.string())' is invalid", stderr)
      exit(1)
    }
    return tree
  }
}
