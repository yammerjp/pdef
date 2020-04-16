import Foundation

if CommandLine.arguments.count < 3 {
  fputs("Missing Arguments", stderr)
  exit(1)
}

let plistRootBefore = LoadPlist(path: CommandLine.arguments[2])
let plistRootAfter = LoadPlist(path: CommandLine.arguments[2])

let plist = Plist(root: plistRootBefore)
plist.traceRoot()
