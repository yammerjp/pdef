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
    return contains{"\($0)" == "\(item)"}
  }

  func joinNotContains(_ items: [Element]) -> [Element] {
    return self + items.filter { !self.contains($0)}
  }
}
