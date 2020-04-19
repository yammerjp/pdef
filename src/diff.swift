import Foundation

class Diff {
  let A: DomainPlsit
  let B: DomainPlsit

  init(A: DomainPlsit, B: DomainPlsit) {
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
    A.pushDescendantPlistPath(key: key)
    B.pushDescendantPlistPath(key: key)
    compareValue()
    A.popDescendantPlistPath()
    B.popDescendantPlistPath()
  }

  private func containsOnlyA(key: PlistKey) {
    A.pushDescendantPlistPath(key: key)
    ShellScriptCreator(A.descendant).delete()
    A.popDescendantPlistPath()
  }

  private func containsOnlyB(key: PlistKey) {
    B.pushDescendantPlistPath(key: key)
    ShellScriptCreator(B.descendant).add()
    B.popDescendantPlistPath()
  }

  private func compareValue() {
    guard let commonType = self.commonType else {
      ShellScriptCreator(B.descendant).update()
      return
    }
    if commonType == .dict || commonType == .array {
      compareKeys()
      return
    }
    if String(describing: A.descendant.plist) == String(describing: B.descendant.plist) {
      return
    }
    ShellScriptCreator(B.descendant).update()
  }

  private var commonType: PlistType? {
    if A.descendant.plist.type == B.descendant.plist.type {
      return A.descendant.plist.type
    }
    return nil
  }
}
