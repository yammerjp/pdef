import Foundation

class InnerTree {
  static func keys(tree: Any)-> [PlistKey] {
    let treeType = getPlistValueType(tree)
    if treeType == .dictionary {
      return dictionaryKeys(tree: tree as! NSDictionary)
    }
    if treeType == .array {
      return arrayKeys(tree: tree as! NSArray)
    }
    return []
  }

  static private func dictionaryKeys(tree: NSDictionary) -> [String] {
    let dictionaryOrder = { (a: Any, b: Any) -> Bool in
      a as! String > b as! String
    }
    let toString = { (any: Any) -> String in String(describing: any) }
    let keys: [String] = tree.allKeys.map(toString).sorted(by: dictionaryOrder)
    return keys
  }

  static private func arrayKeys(tree: NSArray) -> [Int] {
    let lastIndex = tree.count - 1
    if lastIndex <= 0 {
      return []
    }
    return [Int](0...lastIndex)
  }
}