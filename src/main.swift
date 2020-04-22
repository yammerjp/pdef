import Foundation

createTmpDirectory()

if CommandLine.arguments.count < 4 {
  ErrorMessage("Missing Arguments")
}

let format: DomainPlsitFormat = .xml
let domain = CommandLine.arguments[1]
let domainPlistTreeA = loadFile(path: CommandLine.arguments[2], format: format)
let domainPlistTreeB = loadFile(path: CommandLine.arguments[3], format: format)

let plistA = DomainPlist2Shell(domainTree: domainPlistTreeA, domain: domain)
let plistB = DomainPlist2Shell(domainTree: domainPlistTreeB, domain: domain)

let diff = Diff(A: plistA, B: plistB)
diff.comparePlist()

removeTmpDirectory()
