import Foundation

if CommandLine.arguments.count < 3 {
  fputs("Missing Arguments", stderr)
  exit(1)
}

func getFullPath(path: String)-> String {
  if path[path.startIndex] == "/" {
    return path
  }
  let currentDir = FileManager.default.currentDirectoryPath
  return currentDir + "/" + path
}

let plistBefore = Plist(path: getFullPath(path: CommandLine.arguments[2]))
let plistAfter = Plist(path: getFullPath(path: CommandLine.arguments[2]))

Diff.Dictionary(before: plistBefore.root, after: plistAfter.root)
