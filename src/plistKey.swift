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

  func contains(_ item: PlistKey) -> Bool {
    for e in self {
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
