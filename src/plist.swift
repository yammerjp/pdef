import Foundation

class Plist {
  let rootTree: Any
  private(set) var subTreePath: [PlistKey]
  private(set) var subTree: Any

  init(rootTree: Any) {
    self.rootTree = rootTree
    subTreePath = []
    subTree = rootTree
  }

  init(domainTree: Any, domain: String) {
    let rootTree: NSDictionary = [
      domain : domainTree
    ]
    self.rootTree = rootTree
    subTreePath = []
    subTree = rootTree
  }

  private func restructSubTree() {
    subTree = tree(path: subTreePath)
  }

  func tree(path: [PlistKey])-> Any {
    return InnerTree.subTree(path: path, rootTree: rootTree)
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
    InnerTree.keys(tree: subTree)
  }

  var subTreeType: PlistValueType {
    get {
      return getPlistValueType(subTree)
    }
  }

  var domain: String {
    get {
      return subTreePath[0] as! String
    }
  }
}
