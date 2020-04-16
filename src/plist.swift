import Foundation

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
  var nestDepth : Int
  let root: Any

  init(root: Any) {
    self.root = root
    nestDepth = 0
  }
  func traceRoot() {
    traceAny(tree: root)
  }

  func traceAny(tree: Any) {
    nestDepth += 1
    let treeType = self.treeType(tree: tree)
    if treeType == .dictionary {
      traceDictionary(tree: tree as! NSDictionary)
    } else if treeType == .array {
      traceArray(tree: tree as! NSArray)
    } else {
      printValue(value: tree, type: treeType)
    }
    nestDepth -= 1
  }

  func traceDictionary(tree: NSDictionary) {
    let dictionaryOrder = { (a: Any,b: Any) -> Bool in
      return a as! String > b as! String
    }
    let toString =  { (any:Any) -> String in return String(describing: any)}

    let keys: [String] = tree.allKeys.map(toString).sorted(by: dictionaryOrder)

    for key in keys {
      printKey(key: key)
      guard let branch : Any = tree[key] else {
        fputs("Loading dictionary[\(key)] is failed", stderr)
        exit(1)
      }
      traceAny(tree: branch)
    }
  }

  func traceArray(tree: NSArray) {
    for branch in tree {
      traceAny(tree: branch)
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
    print( String(repeating: "  ", count: nestDepth+1)
          + String(describing: value)
          + " (\(String(describing: type)))")
  }

  func printKey(key: String) {
    print( String(repeating: "  ", count: nestDepth) + key + ":" )
  }
}
