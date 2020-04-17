import Foundation

protocol PlistKeyType {}
extension Int: PlistKeyType {}
extension String: PlistKeyType {}

enum TreeType: Int {
  case string
  case float
  case integer
  case boolean
  case data
  case date
  case array
  case dictionary
}

class Plist {
  var keyStack : [PlistKeyType]
  let root: Any

  init(root: Any) {
    self.root = root
    keyStack = []
  }

  func tree()-> Any {
    var tree = root
    for key in keyStack {
      if isDictionary(tree: tree) {
        tree = (tree as! NSDictionary) [key]
        continue
      }
      if isArray(tree: tree) {
        tree = (tree as! NSArray) [key as! Int]
        continue
      }
      fputs("Plist.keyStack is invalid", stderr)
      exit(1)
    }
    return tree
  }

  func keys()-> [String] {
    let tree = self.tree()
    if isDictionary(tree: tree) {
      return keys(tree: tree as! NSDictionary)
    }
    return []
  }

  func push(key: PlistKeyType) {
    keyStack.append(key)
  }

  func pop(){
    keyStack.removeLast()
  }

  func traceRoot() {
    traceAny(tree: root)
  }

  private func traceInTree(branch: Any, key: PlistKeyType) {
    push(key: key)
    traceAny(tree: branch)
    pop()
  }

  private func traceAny(tree: Any) {
    let treeType = self.treeType(tree: tree)
    if treeType == .dictionary {
      traceDictionary(tree: tree as! NSDictionary)
    } else if treeType == .array {
      traceArray(tree: tree as! NSArray)
    } else {
      printValue(value: tree, type: treeType)
    }
  }

  func keys(tree: NSArray)-> [Int] {
    var keys: [Int] = []
    for (index, _) in tree.enumerated() {
      keys.append(index)
    }
    return keys
  }

  func keys(tree: NSDictionary)-> [String] {
    let dictionaryOrder = { (a: Any,b: Any) -> Bool in
      return a as! String > b as! String
    }
    let toString =  { (any:Any) -> String in return String(describing: any)}

    let keys: [String] = tree.allKeys.map(toString).sorted(by: dictionaryOrder)
    return keys
  }

  private func traceDictionary(tree: NSDictionary) {
    let keys = self.keys(tree: tree)
    for key in keys {
      guard let branch : Any = tree[key] else {
        fputs("Loading dictionary[\(key)] is failed", stderr)
        exit(1)
      }
      traceInTree(branch: branch, key: key)
    }
  }

  private func traceArray(tree: NSArray) {
    for (index, branch) in tree.enumerated() {
      traceInTree(branch: branch, key: index)
    }
  }

  func isTip(tree: Any)-> Bool {
    let type = treeType(tree: tree)
    return type != .dictionary && type != .array
  }

  func isArray(tree: Any)-> Bool {
    return treeType(tree: tree) == .array
  }

  func isArray()-> Bool {
    return treeType(tree: tree()) == .array
  }

  func isDictionary(tree: Any)-> Bool {
    return treeType(tree: tree) == .dictionary
  }
  func isDictionary()-> Bool {
    return treeType(tree: tree()) == .dictionary
  }

  func treeType(tree: Any)-> TreeType {
    let typeID = CFGetTypeID(tree as CFTypeRef?)
    switch  typeID {
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

  func printValue(value: Any, type: TreeType) {
    let properties = keyStack.map({ (key) -> String in return "\(key)"}).joined(separator: "->")
    print("\(properties) : \(value) (\(String(describing: type)))")
  }
}
