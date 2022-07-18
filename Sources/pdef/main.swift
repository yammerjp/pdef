import Foundation

func main() {
  createTmpDirectory()
  let arg = interpretArgs(args: CommandLine.arguments)

  let plistA = getDomainPlist2Shell(path: arg.pathBefore, domain: arg.domain)
  let plistB = getDomainPlist2Shell(path: arg.pathAfter, domain: arg.domain)

  let diff = Diff(A: plistA, B: plistB)
  diff.comparePlist()

  removeTmpDirectory()
}

func getDomainPlist2Shell(path: String, domain: String?)-> DomainPlist2Shell {
  if domain == nil {
    let allDomainDictionary = loadFile(path: path, format: .ascii)
    return DomainPlist2Shell(rootTree: allDomainDictionary)
  }
  let domainPlistTree = loadFile(path: path, format: .xml)
  return DomainPlist2Shell(domainTree: domainPlistTree, domain: domain!)
}

main()
