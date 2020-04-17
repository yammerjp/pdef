import Foundation

protocol PlistKeyType {}
extension Int: PlistKeyType {}
extension String: PlistKeyType {}

extension Array where Element == PlistKeyType {
  func join() -> String {
    return map { key -> String in
      String(describing: key)
    }.joined(separator: "->")
  }
}

enum PlistType: Int {
  case string
  case float
  case integer
  case boolean
  case data
  case date
  case array
  case dictionary
}

class PlistOfADomain {
  private(set) var keyStack: [PlistKeyType]
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
      if isDictionary(tree: tree) {
        tree = (tree as! NSDictionary)[key]
        continue
      }
      if isArray(tree: tree) {
        tree = (tree as! NSArray)[key as! Int]
        continue
      }
      fputs("Plist.keyStack is invalid", stderr)
      exit(1)
    }
    self.tree = tree
  }

  func push(key: PlistKeyType) {
    keyStack.append(key)
    restructTree()
  }

  func pop() {
    keyStack.removeLast()
    restructTree()
  }

  func keys() -> [String] {
    let tree = self.tree
    if isDictionary() {
      return keys(tree: tree as! NSDictionary)
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

  private func isArray(tree: Any) -> Bool {
    return getPlistType(tree) == .array
  }

  func isArray() -> Bool {
    return PlistType() == .array
  }

  private func isDictionary(tree: Any) -> Bool {
    return getPlistType(tree) == .dictionary
  }

  func isDictionary() -> Bool {
    return PlistType() == .dictionary
  }

  func PlistType() -> PlistType {
    return getPlistType(tree)
  }

  func printValue(value: Any, type: PlistType) {
    let properties = keyStack.map { (key) -> String in "\(key)" }.joined(separator: "->")
    print("\(properties) : \(value) (\(String(describing: type)))")
  }
}

func getPlistType(_ tree: Any) -> PlistType {
  let typeID = CFGetTypeID(tree as CFTypeRef?)
  switch typeID {
  case CFNumberGetTypeID():
    if tree is NSInteger {
      return .integer
    }
    return .float
  case CFArrayGetTypeID():
    return .array
  case CFDictionaryGetTypeID():
    return .dictionary
  case CFStringGetTypeID():
    return .string
  case CFDataGetTypeID():
    return .data
  case CFDateGetTypeID():
    return .date
  case CFBooleanGetTypeID():
    return .boolean
  default:
    fputs("Detecting plist type is failed", stderr)
    exit(1)
  }
}


