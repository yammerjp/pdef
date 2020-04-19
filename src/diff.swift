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
    ShellScriptCreator.delete(treePath:A.subTreePath)
    A.popSubTreePath()
  }

  private func containsOnlyB(key: PlistKey) {
    B.pushSubTreePath(key: key)
    ShellScriptCreator.add(treePath:B.subTreePath, tree: B.subTree)
    B.popSubTreePath()
  }

  private func compareValue() {
    guard let commonType = self.commonType() else {
      ShellScriptCreator.update(treePath:B.subTreePath, tree: B.subTree)
      return
    }
    if commonType == .dict || commonType == .array {
      compareKeys()
      return
    }
    if String(describing: A.subTree) == String(describing: B.subTree) {
      return
    }
    ShellScriptCreator.update(treePath:B.subTreePath, tree: B.subTree)
  }

  private func commonType() -> PlistValueType? {
    if A.subTreeType == B.subTreeType {
      return A.subTreeType
    }
    return nil
  }
}
