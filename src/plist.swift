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
  let tree: Any
  init(tree: Any) {
    self.tree = tree
  }

  func keys() -> [PlistKey] {
    if type == .dict {
      return (tree as! NSDictionary).allKeys.map{String(describing: $0)}.sorted()
    }
    if type == .array {
      let lastIndex = (tree as! NSArray).count - 1
      return lastIndex <= 0 ? [] : [Int](0 ... lastIndex)
    }
    return []
  }

  func childsAreString() -> Bool {
    let keys = self.keys()
    if keys.count == 0 {
      return false
    }
    return !keys.contains{ childPlist(key: $0).type != .string }
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
    if !isParent {
      return [Descendant(path: path, plist: self)]
    }
    return keys().map { key -> [Descendant] in
      childPlist(key: key).babys(path: path + [key])
    }.flatMap { $0 }
  }

  func containsArray(path: [PlistKey]) -> [[PlistKey]]? {
    var keysArray: [[PlistKey]] = []
    if !isParent {
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

  var isParent: Bool {
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
