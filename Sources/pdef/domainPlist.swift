import Foundation

class DomainPlist {
  private let rootPlist: Plist
  private(set) var descendant: Descendant

  init(rootTree: NSDictionary) {
    rootPlist = Plist(tree: rootTree)
    descendant = Descendant(path: [], plist: rootPlist)
  }

  convenience init(domainTree: Any, domain: String) {
    let rootTree: NSDictionary = [
      domain: domainTree,
    ]
    self.init(rootTree: rootTree)
  }

  func pushDescendantPlistPath(key: PlistKey) {
    descendant.path.append(key)
    descendant.plist = descendant.plist.childPlist(key: key)
  }

  func popDescendantPlistPath() {
    descendant.path.removeLast()
    descendant.plist = rootPlist.descendantPlist(path: descendant.path)
  }
}
