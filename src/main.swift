import Foundation

if CommandLine.arguments.count < 2 {
  fputs("Missing Arguments", stderr)
  exit(1)
}

let plistRoot = LoadPlist(path: CommandLine.arguments[1])

let plist = Plist(root: plistRoot)

plist.traceRoot()
