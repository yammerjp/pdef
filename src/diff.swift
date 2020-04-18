import Foundation

class Diff {
  let A: Plist
  let B: Plist

  init(A: Plist, B: Plist) {
    self.A = A
    self.B = B
  }

  func comparePlistOfADomain() {
    compareKeys()
  }

  private func compareKeys() {
    // print("called diffKey()")
    let keysA: [PlistKey] = A.treeKeys()
    let keysB: [PlistKey] = B.treeKeys()
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
    A.pushKey(key)
    B.pushKey(key)
    compareValue()
    A.popKey()
    B.popKey()
  }

  private func containsOnlyA(key: PlistKey) {
    A.pushKey(key)
    printDelete()
    A.popKey()
  }

  private func containsOnlyB(key: PlistKey) {
    B.pushKey(key)
    printWrite()
    B.popKey()
  }

  private func printDelete() {
    print("delete \(A.domain) \(A.keyStack.string())")
  }

  private func printWrite() {
    print("write \(B.domain) \(B.keyStack.string()) \(String(describing: B.tree))")
  }

  private func compareValue() {
    guard let commonType = self.commonType() else {
      print("Not same type")
      return
    }

    if commonType == .dictionary {
      compareKeys()
      return
    }

    if commonType == .array {
      compareKeys()
      return
    }

    if String(describing: A.tree) == String(describing: B.tree) {
      return
    }

    printDelete()
    printWrite()
  }

  private func commonType() -> PlistValueType? {
    if A.treeType == B.treeType {
      return A.treeType
    }
    return nil
  }
}
