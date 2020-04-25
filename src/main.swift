import Foundation

let baseDir = "/tmp/pdef"

let optionDictionary: [String:String?] = checkArgs(args: CommandLine.arguments)


if let dump = optionDictionary["dump"]! {

  let pathDumpDir = "\(baseDir)/\( dump )"
  if let domain: String = optionDictionary["domain"]! {
    Dump(dirPath: pathDumpDir, domain: domain)
    exit(0)
  }
  print ("unimpliment")
}

let before = (optionDictionary["before"] ?? "no-name")!
let after = (optionDictionary["after"] ?? "no-name-after")!
let pathBeforeDir = "\(baseDir)/\(before)"
let pathAfterDir = "\(baseDir)/\(after)"


if let out = optionDictionary["out"]! {
  if let domain = optionDictionary["dump"]! {
    let pathBefore = pathBeforeDir + "/" + domain
    let pathAfter = pathAfterDir + "/" + domain
    guard optionDictionary["after"] != nil else {
      Dump(dirPath: pathAfterDir, domain: domain)
    }
    pdefCore(domain: domain,
      beforeFilePath: pathBefore,
      afterFilePath: pathAfter
    )
  } else {
    print ("unimpliment")
  }
}

// createTmpDirectory()
// removeTmpDirectory()

func Dump(dirPath: String, domain: String) {
  mkdir(path: dirPath)
  _ = Process("defaults", [ "export", domain, dirPath+"/"+domain ] ).outputString()
}

func pdefCore(domain: String, beforeFilePath: String, afterFilePath: String){
  let format: DomainPlsitFormat = .xml
  let domainPlistTreeA = loadFile(path: beforeFilePath, format: format)
  let domainPlistTreeB = loadFile(path: afterFilePath, format: format)
  let plistA = DomainPlist2Shell(domainTree: domainPlistTreeA, domain: domain)
  let plistB = DomainPlist2Shell(domainTree: domainPlistTreeB, domain: domain)
  let diff = Diff(A: plistA, B: plistB)
  diff.comparePlist()
}
