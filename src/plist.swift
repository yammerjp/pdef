import Foundation

enum PlistType: Int {
  case string
  case real
  case integer
  case bool
  case data
  case date
  case array
  case dict
}

struct HeadValue {
  var path: [PlistKey]
  var value: Plist
}

class Plist {
  var tree: Any
  init(tree: Any) {
    self.tree = tree
  }

  func keys() -> [PlistKey] {
    let treeType = type
    if treeType == .dict {
      return dictionaryKeys()
    }
    if treeType == .array {
      return arrayKeys()
    }
    return []
  }

  private func dictionaryKeys() -> [String] {
    let tree = self.tree as! NSDictionary
    let dictionaryOrder = { (a: Any, b: Any) -> Bool in
      !(a as! String > b as! String)
    }
    let toString = { (any: Any) -> String in String(describing: any) }
    let keys: [String] = tree.allKeys.map(toString).sorted(by: dictionaryOrder)
    return keys
  }

  private func arrayKeys() -> [Int] {
    let tree = self.tree as! NSArray
    let lastIndex = tree.count - 1
    if lastIndex <= 0 {
      return []
    }
    return [Int](0 ... lastIndex)
  }

  func allValueIsString() -> Bool {
    let keys = self.keys()
    if keys.count == 0 {
      return false
    }
    for key in keys {
      if subTree(path: [key]).type != .string {
        return false
      }
    }
    return true
  }

  func subTree(path: [PlistKey])-> Plist{
    var tree = self.tree
    for key in path {
      if getPlistTreeType(tree: tree) == .dict {
        tree = (tree as! NSDictionary)[key as! String]!
        continue
      }
      if getPlistTreeType(tree: tree) == .array {
        tree = (tree as! NSArray)[key as! Int]
        continue
      }
      fputs("TreePath '\(path.string())' is invalid", stderr)
      exit(1)
    }
    return Plist(tree: tree)
  }

  func headValues(path: [PlistKey])-> [HeadValue] {
    if !plistValueIsParent() {
      return [ HeadValue(path: path, value: self) ]
    }
    return keys().map({ key -> [HeadValue] in
      return subTree(path: [key]).headValues(path: path+[key])
    }).flatMap{$0}
  }

  func containsArray(path: [PlistKey]) -> [[PlistKey]]? {
    var keysArray: [[PlistKey]] = []
    if !plistValueIsParent() {
      return nil
    }
    if type == .array {
      keysArray += [path]
    }
    for key in keys() {
      if let newPathes = subTree(path: [key]).containsArray(path: path + [key]) {
        keysArray += newPathes
      }
    }
    return keysArray
  }

  var type: PlistType {
    get {
      return getPlistTreeType(tree: tree)
    }
  }
  private func getPlistTreeType(tree: Any) -> PlistType {
    let typeID = CFGetTypeID(tree as CFTypeRef?)
    switch typeID {
    case CFNumberGetTypeID():
      if tree is NSInteger {
        return .integer
      }
      return .real
    case CFArrayGetTypeID():
      return .array
    case CFDictionaryGetTypeID():
      return .dict
    case CFStringGetTypeID():
      return .string
    case CFDataGetTypeID():
      return .data
    case CFDateGetTypeID():
      return .date
    case CFBooleanGetTypeID():
      return .bool
    default:
      fputs("Detecting plist type is failed", stderr)
      exit(1)
    }
  }

  func plistValueIsParent() -> Bool {
    let valueType = type
    return valueType == .array || valueType == .dict
  }

}