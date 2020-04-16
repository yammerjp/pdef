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
  var nestStack : [PlistKeyType]
  let root: Any

  init(root: Any) {
    self.root = root
    nestStack = []
  }

  func traceRoot() {
    traceAny(tree: root)
  }

  func traceInTree(branch: Any, key: PlistKeyType) {
    nestStack.append(key)
    traceAny(tree: branch)
    nestStack.removeLast()
  }

  func traceAny(tree: Any) {
    let treeType = self.treeType(tree: tree)
    if treeType == .dictionary {
      traceDictionary(tree: tree as! NSDictionary)
    } else if treeType == .array {
      traceArray(tree: tree as! NSArray)
    } else {
      printValue(value: tree, type: treeType)
    }
  }

  func traceDictionary(tree: NSDictionary) {
    let dictionaryOrder = { (a: Any,b: Any) -> Bool in
      return a as! String > b as! String
    }
    let toString =  { (any:Any) -> String in return String(describing: any)}

    let keys: [String] = tree.allKeys.map(toString).sorted(by: dictionaryOrder)

    for key in keys {
      guard let branch : Any = tree[key] else {
        fputs("Loading dictionary[\(key)] is failed", stderr)
        exit(1)
      }
      traceInTree(branch: branch, key: key)
    }
  }

  func traceArray(tree: NSArray) {
    for (index, branch) in tree.enumerated() {
      traceInTree(branch: branch, key: index)
    }
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
    let properties = nestStack.map({ (key) -> String in return "\(key)"}).joined(separator: "->")
    print("\(properties) : \(value) (\(String(describing: type)))")
  }
}
