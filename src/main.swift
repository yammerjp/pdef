import Foundation

createTmpDirectory()

if CommandLine.arguments.count < 4 {
  fputs("Missing Arguments", stderr)
  exit(1)
}

let format: PlistFormat = .xml
let domain = CommandLine.arguments[1]
let domainPlistTreeA = loadFile(path: CommandLine.arguments[2], format: format)
let domainPlistTreeB = loadFile(path: CommandLine.arguments[3], format: format)

let plistA = Plist(domainTree: domainPlistTreeA, domain: domain)
let plistB = Plist(domainTree: domainPlistTreeB, domain: domain)

let diff = Diff(A: plistA, B: plistB)
diff.comparePlist()

removeTmpDirectory()
