import Foundation

protocol PlistKey {}
extension Int: PlistKey {}
extension String: PlistKey {}

extension Array where Element == PlistKey {
  func string() -> String {
    return string(separator: "->")
  }
  func string(separator: String) -> String {
    return map { key -> String in
      String(describing: key)
    }.joined(separator: separator)
  }
  func contains(_ item: PlistKey)-> Bool {
    for e in self  {
      if "\(e)" == "\(item)" {
        return true
      }
    }
    return false
  }
  func joinNotContains(_ items: [Element]) -> [Element] {
    var joined = self
    for item in items {
      if !joined.contains(item) {
        joined.append(item)
      }
    }
    return joined
  }
}

enum PlistValueType: Int {
  case string
  case float
  case integer
  case bool
  case data
  case date
  case array
  case dict
}

func getPlistValueType(_ tree: Any) -> PlistValueType {
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

