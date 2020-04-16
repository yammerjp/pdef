import Foundation

class Diff {
  static func Value(){}
  static func Array(){}
  static func Dictionary(before: NSDictionary, after: NSDictionary) {
    let dictionarySorting = { (a: Any,b: Any) -> Bool in
      return a as! String > b as! String
    }
    let toString =  { (any:Any) -> String in return String(describing: any)}

    let keysBefore: [String] = before.allKeys.map(toString).sorted(by: dictionarySorting)
    let keysAfter : [String] = after.allKeys.map(toString).sorted(by: dictionarySorting)

    var idxBefore = 0
    var idxAfter = 0

    while idxBefore < keysBefore.count || idxAfter < keysAfter.count {

      if keysBefore[idxBefore] == keysAfter[idxAfter] {
        // 一致したら深さ探索
        idxBefore += 1
        idxAfter += 1
        continue
      }
      if keysBefore[idxBefore] < keysAfter[idxAfter] {
        // delete
        idxBefore += 1
        print("delete \(keysBefore[idxBefore])")
        continue
      }
      if keysBefore[idxBefore] > keysAfter[idxAfter] {
        // add
        idxBefore += 1
        print("add \(keysAfter[idxAfter])")
      }
    }
  }
}
