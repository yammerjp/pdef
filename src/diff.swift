import Foundation

class Diff {
  let A: Plist
  let B: Plist

  init(A: Plist, B: Plist) {
    self.A = A
    self.B = B
  }

  func comparePlist() {
    compareKeys()
  }

  private func compareKeys() {
    // print("called diffKey()")
    let keysA: [PlistKey] = A.subTreeKeys()
    let keysB: [PlistKey] = B.subTreeKeys()
    let keysAll = keysA.joinNotContains(keysB)

    for key in keysAll {
      if keysA.contains(key) {
        if keysB.contains(key) {
          compareValueOfSameKey(key: key)
          continue
        }
        containsOnlyA(key: key)
        continue
      }
      containsOnlyB(key: key)
      continue
    }
  }

  private func compareValueOfSameKey(key: PlistKey) {
    A.pushSubTreePath(key: key)
    B.pushSubTreePath(key: key)
    compareValue()
    A.popSubTreePath()
    B.popSubTreePath()
  }

  private func containsOnlyA(key: PlistKey) {
    A.pushSubTreePath(key: key)
    printDelete()
    A.popSubTreePath()
  }

  private func containsOnlyB(key: PlistKey) {
    B.pushSubTreePath(key: key)
    printWrite()
    B.popSubTreePath()
  }

  private func printDelete() {
    print("delete \(A.domain) \(A.subTreePath.string())")
  }

  private func printWrite() {
    print("write \(B.domain) \(B.subTreePath.string()) \(String(describing: B.subTree))")
  }
  private func printReWrite() {
    printDelete()
    printWrite()
  }

  private func compareValue() {
    guard let commonType = self.commonType() else {
      printReWrite()
      return
    }
    if commonType == .dictionary || commonType == .array {
      compareKeys()
      return
    }
    if String(describing: A.subTree) == String(describing: B.subTree) {
      return
    }
    printReWrite()
  }

  private func commonType() -> PlistValueType? {
    if A.subTreeType == B.subTreeType {
      return A.subTreeType
    }
    return nil
  }
}
