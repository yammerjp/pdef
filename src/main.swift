import Foundation

if CommandLine.arguments.count < 3 {
  fputs("Missing Arguments", stderr)
  exit(1)
}

let plistBefore = LoadPlist(path: CommandLine.arguments[2])
let plistAfter = LoadPlist(path: CommandLine.arguments[2])

let tracer = Tracer(root: plistBefore)
tracer.traceRoot()
