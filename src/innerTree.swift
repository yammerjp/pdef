import Foundation
/*
class InnerTree {
  static func keys(tree: Any) -> [PlistKey] {
    let treeType = getPlistType(tree)
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
      !(a as! String > b as! String)
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
      if getPlistType(subTree(path: [key], rootTree: tree)) != .string {
        return false
      }
    }
    return true
  }

  static func subTree(path: [PlistKey], rootTree: Any)-> Any{
    var tree = rootTree
    for key in path {
      if getPlistType(tree) == .dict {
        tree = (tree as! NSDictionary)[key as! String]!
        continue
      }
      if getPlistType(tree) == .array {
        tree = (tree as! NSArray)[key as! Int]
        continue
      }
      fputs("TreePath '\(path.string())' is invalid", stderr)
      exit(1)
    }
    return tree
  }

  static func headValues(path: [PlistKey], tree: Any)-> [HeadValue] {
    if !plistValueIsParent(tree) {
      return [ HeadValue(path: path, value: tree) ]
    }
    return keys(tree: tree).map({ key -> [HeadValue] in
      return headValues(path: path+[key], tree: subTree(path: [key], rootTree: tree))
    }).flatMap{$0}
  }

  static func containsArray(path: [PlistKey], tree: Any) -> [[PlistKey]]? {
    var keysArray: [[PlistKey]] = []
    if !plistValueIsParent(tree) {
      return nil
    }
    if getPlistType(tree) == .array {
      keysArray += [path]
    }
    let keys = self.keys(tree: tree)
    for key in keys {
      if let newPathes = containsArray(path: path + [key], tree: subTree(path: [key],rootTree: tree)) {
        keysArray += newPathes
      }
    }
    return keysArray
  }
}
*/