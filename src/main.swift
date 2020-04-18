import Foundation

if CommandLine.arguments.count < 3 {
  fputs("Missing Arguments", stderr)
  exit(1)
}

let plistRootA = loadFile(path: CommandLine.arguments[1])
let plistRootB = loadFile(path: CommandLine.arguments[2])

let plistA = Plist(rootTree: plistRootA)
let plistB = Plist(rootTree: plistRootB)

let diff = Diff(A: plistA, B: plistB)
diff.comparePlist()

removeTmpDirectory()
