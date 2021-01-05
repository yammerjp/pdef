import Foundation

class Diff {
  let A: DomainPlist2Shell
  let B: DomainPlist2Shell

  init(A: DomainPlist2Shell, B: DomainPlist2Shell) {
    self.A = A
    self.B = B
  }

  func comparePlist() {
    compareKeys()
  }

  private func compareKeys() {
    let keysA = A.descendant.plist.keys()
    let keysB = B.descendant.plist.keys()
    let keysAll = keysA.joinNotContains(keysB)

    keysAll.forEach { key in
      if !keysA.contains(key) {
        containsOnlyB(key: key)
        return
      }
      if !keysB.contains(key) {
        containsOnlyA(key: key)
        return
      }
      compareValueOfSameKey(key: key)
      return
    }
  }

  private func compareValueOfSameKey(key: PlistKey) {
    A.pushDescendantPlistPath(key: key)
    B.pushDescendantPlistPath(key: key)
    compareValue()
    A.popDescendantPlistPath()
    B.popDescendantPlistPath()
  }

  private func containsOnlyA(key: PlistKey) {
    A.pushDescendantPlistPath(key: key)
    A.delete()
    A.popDescendantPlistPath()
  }

  private func containsOnlyB(key: PlistKey) {
    B.pushDescendantPlistPath(key: key)
    B.add()
    B.popDescendantPlistPath()
  }

  private func compareValue() {
    guard let commonType = self.commonType else {
    B.update(before: A)
      return
    }
    if commonType == .dict || commonType == .array {
      compareKeys()
      return
    }
    if String(describing: A.descendant.plist) == String(describing: B.descendant.plist) {
      return
    }
    B.update(before: A)
  }

  private var commonType: PlistType? {
    if A.descendant.plist.type == B.descendant.plist.type {
      return A.descendant.plist.type
    }
    return nil
  }
}
