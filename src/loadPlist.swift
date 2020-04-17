import Foundation

fileprivate func getFullPath(path: String) -> String {
  if path[path.startIndex] == "/" {
    return path
  }
  let currentDir = FileManager.default.currentDirectoryPath
  return currentDir + "/" + path
}

func LoadPlist(path: String) -> NSDictionary {
  let fullPath = getFullPath(path: path)
  guard let root = NSDictionary(contentsOfFile: fullPath) else {
    fputs("Loading property list '\(path)' is failed", stderr)
    exit(1)
  }
  return root
}