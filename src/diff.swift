import Foundation

/*
protocol PlistKeyType {}
extension Int: PlistKeyType {}
extension String: PlistKeyType {}
*/

class Diff {
  let A: Plist
  let B: Plist

  init(A: Plist, B: Plist) {
    self.A = A
    self.B = B
  }

  func diffKey() {
    let keysA: [String] = A.keys()
    let keysB: [String] = B.keys()
    let keysAll = Array(Set([ keysA, keysB ].joined()))
    
    for key in keysAll {
      if keysA.contains(key) {
        if keysB.contains(key) {
          // 中身を探索
            diffValue(key: key)
            continue
       }
        // only a
        print("delete \(key): (\(String(describing: (A.tree()as! NSDictionary)[key])))")
        continue
      }
      // only b
      print("write \(key): \(String(describing: (B.tree() as! NSDictionary)[key]))")
      continue
    }
  }

  func diffValue(key: String) {
    if A.isDictionary() && B.isDictionary() {
      A.push(key: key)
      B.push(key: key)
      diffKey()
      A.pop()
      B.pop()
	  return
    }
    if A.isArray() || B.isArray() {
        print("Skip array")
        return
    }

    let treeA =  A.tree() as! NSDictionary
    let treeB =  B.tree() as! NSDictionary

	if String(describing: treeA[key]) == String(describing: treeB[key]) {
		return
	}

    print("rewrite-from \(key): (\(String(describing: treeA[key])))")
    print("rewrite-to   \(key): (\(String(describing: treeB[key])))")
  }
}
