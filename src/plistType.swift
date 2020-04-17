import Foundation

protocol PlistKey {}
extension Int: PlistKey {}
extension String: PlistKey {}

extension Array where Element == PlistKey {
  func join() -> String {
    return map { key -> String in
      String(describing: key)
    }.joined(separator: "->")
  }
}

enum PlistValueType: Int {
  case string
  case float
  case integer
  case boolean
  case data
  case date
  case array
  case dictionary
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

