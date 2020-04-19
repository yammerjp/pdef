import Foundation

class DomainPlsit {
  let rootTree: Plist
  private(set) var subTreePath: [PlistKey]
  private(set) var subTree: Plist

  init(rootTree: Any) {
    self.rootTree = Plist(tree: rootTree)
    subTreePath = []
    subTree = self.rootTree
  }

  convenience init(domainTree: Any, domain: String) {
    let rootTree: NSDictionary = [
      domain : domainTree
    ]
    self.init(rootTree: rootTree)
  }

  private func restructSubTree() {
    subTree = tree(path: subTreePath)
  }

  func tree(path: [PlistKey])-> Plist {
    return rootTree.subTree(path: path)
  }

  func pushSubTreePath(key: PlistKey) {
    subTreePath.append(key)
    restructSubTree()
  }

  func popSubTreePath() {
    subTreePath.removeLast()
    restructSubTree()
  }

  func subTreeKeys()-> [PlistKey] {
    subTree.keys()
  }

  var subTreeType: PlistType {
    get {
      return subTree.type
    }
  }

  var domain: String {
    get {
      return subTreePath[0] as! String
    }
  }
}
