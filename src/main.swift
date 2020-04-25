import Foundation

main()

func main() {
  createTmpDirectory()
  let arg = interpretArgs(args: CommandLine.arguments)

  let plistA = getDomainPlist2Shell(path: arg.pathBefore, domain: arg.domain)
  let plistB = getDomainPlist2Shell(path: arg.pathAfter, domain: arg.domain)

  let diff = Diff(A: plistA, B: plistB)
  diff.comparePlist()

  removeTmpDirectory()
}

func interpretArgs(args: [String])-> (domain: String?, pathBefore: String, pathAfter: String) {
  if args.count < 1 {
    ErrorMessage("Missing Arguments")
  }

  if args[1] == "-h" || args[1] == "--help" {
    let helpMessage = "Help messages"
    fputs(helpMessage, stderr)

  if args[1] == "-v" || args[1] == "--version" {
    fputs(VersionMessage, stderr)
    exit(0)
  }

  let withDomainOption = args[1] == "-d" || args[1] == "--domain"

  if args.count < 2 || withDomainOption && args.count < 4 {
    ErrorMessage("Missing Arguments")
  }

  let domain = withDomainOption ? args[2] : nil
  let pathBefore = withDomainOption ? args[3] : args[1]
  let pathAfter = withDomainOption ? args[4] : args[2]

  return (domain: domain, pathBefore: pathBefore, pathAfter: pathAfter)
}

func getDomainPlist2Shell(path: String, domain: String?)-> DomainPlist2Shell {
  if domain == nil {
    let allDomainDictionary = loadFile(path: path, format: .ascii)
    return DomainPlist2Shell(rootTree: allDomainDictionary)
  }
  let domainPlistTree = loadFile(path: path, format: .xml)
  return DomainPlist2Shell(domainTree: domainPlistTree, domain: domain!)
}
