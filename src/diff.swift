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
    let keysA: [String] = A.treeKeys()
    let keysB: [String] = B.treeKeys()
    let keysAll = Array(Set([keysA, keysB].joined()))

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

  private func compareValueOfSameKey(key: String) {
    A.pushKey(key)
    B.pushKey(key)
    compareValue()
    A.popKey()
    B.popKey()
  }

  private func containsOnlyA(key: String) {
    A.pushKey(key)
    printDelete()
    A.popKey()
  }

  private func containsOnlyB(key: String) {
    B.pushKey(key)
    printWrite()
    B.popKey()
  }

  private func printDelete() {
    print("delete domain \(A.keyStack.join())")
  }

  private func printWrite() {
    print("write domain \(B.keyStack.join()) \(String(describing: B.tree))")
  }

  private func compareValue() {
    // print("called compareValue")
    guard let commonType = self.commonType() else {
      print("Not same type")
      return
    }

    if commonType == .dictionary {
      compareKeys()
      return
    }

    if commonType == .array {
      print("Skip array")
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
