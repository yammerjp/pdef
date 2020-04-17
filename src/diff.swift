import Foundation

class Diff {
  let A: PlistOfADomain
  let B: PlistOfADomain

  init(A: PlistOfADomain, B: PlistOfADomain) {
    self.A = A
    self.B = B
  }

  func comparePlistOfADomain() {
    compareKeys()
  }

  private func compareKeys() {
    // print("called diffKey()")
    let keysA: [String] = A.keys()
    let keysB: [String] = B.keys()
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
    A.push(key: key)
    B.push(key: key)
    compareValue()
    A.pop()
    B.pop()
  }

  private func containsOnlyA(key: String) {
    A.push(key: key)
    printDelete()
    A.pop()
  }

  private func containsOnlyB(key: String) {
    B.push(key: key)
    printWrite()
    B.pop()
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

  private func commonType() -> PlistType? {
    let typeA = getPlistType(A.tree)
    let typeB = getPlistType(B.tree)
    if typeA == typeB {
      return typeA
    }
    return nil
  }
}
