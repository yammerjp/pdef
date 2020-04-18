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
    var tree = rootTree
    for key in path {
      if getPlistValueType(tree) == .dictionary {
        tree = (tree as! NSDictionary)[key as! String]
        continue
      }
      if getPlistValueType(tree) == .array {
        tree = (tree as! NSArray)[key as! Int]
        continue
      }
      fputs("TreePath '\(path.string())' is invalid", stderr)
      exit(1)
    }
    return tree
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
