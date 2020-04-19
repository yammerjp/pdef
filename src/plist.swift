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

struct Descendant {
  var path: [PlistKey]
  var plist: Plist
}

class Plist {
  var tree: Any
  init(tree: Any) {
    self.tree = tree
  }

  func keys() -> [PlistKey] {
    if type == .dict {
      return dictionaryKeys()
    }
    if type == .array {
      return arrayKeys()
    }
    return []
  }

  private func dictionaryKeys() -> [String] {
    let dictionaryOrder = { (a: Any, b: Any) -> Bool in
      !(a as! String > b as! String)
    }
    let toString = { (any: Any) -> String in String(describing: any) }
    return (tree as! NSDictionary).allKeys.map(toString).sorted(by: dictionaryOrder)
  }

  private func arrayKeys() -> [Int] {
    let lastIndex = (tree as! NSArray).count - 1
    if lastIndex <= 0 {
      return []
    }
    return [Int](0 ... lastIndex)
  }

  func childsIsString() -> Bool {
    let keys = self.keys()
    if keys.count == 0 {
      return false
    }
    for key in keys {
      if childPlist(key: key).type != .string {
        return false
      }
    }
    return true
  }

  func childPlist(key: PlistKey) -> Plist {
    if type == .dict {
      return Plist(tree: (tree as! NSDictionary)[key as! String]!)
    }
    if type == .array {
      return Plist(tree: (tree as! NSArray)[key as! Int])
    }
    ErrorMessage("Failed to create chilid plist")
    exit(1)
  }

  func descendantPlist(path: [PlistKey]) -> Plist {
    var plist = self
    for key in path {
      plist = plist.childPlist(key: key)
    }
    return plist
  }

  func babys(path: [PlistKey]) -> [Descendant] {
    if !isParent() {
      return [Descendant(path: path, plist: self)]
    }
    return keys().map { key -> [Descendant] in
      childPlist(key: key).babys(path: path + [key])
    }.flatMap { $0 }
  }

  func containsArray(path: [PlistKey]) -> [[PlistKey]]? {
    var keysArray: [[PlistKey]] = []
    if !isParent() {
      return nil
    }
    if type == .array {
      keysArray += [path]
    }
    for key in keys() {
      if let newPathes = childPlist(key: key).containsArray(path: path + [key]) {
        keysArray += newPathes
      }
    }
    return keysArray
  }

  func isParent() -> Bool {
    return type == .array || type == .dict
  }

  var type: PlistType {
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
      exit(1)
    }
  }
}
