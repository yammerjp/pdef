import Foundation

enum DomainPlsitFormat: Int {
  case xml
  case ascii
}

fileprivate let tmpDir = "/tmp/patch-defaults"

func loadFile(path: String, format: DomainPlsitFormat) -> NSDictionary {
  var loadindPlistPath: String = ""

  if format == .ascii {
    let validSyntaxPlistPath = "\(tmpDir)/\(nowTime()).txt"

    let text = loadInvalidSyntaxPlist(path: full(path: path))
    let textFixed = text.unEscapeBackSlash().replaceBinary2Dummy()

    mkdir(path: tmpDir)
    writeValidSyntaxText2File(path: validSyntaxPlistPath, text: textFixed)
    loadindPlistPath = validSyntaxPlistPath
  } else {
    loadindPlistPath = path
  }

  return loadValidSyntaxPlist(path: loadindPlistPath)
}
/*
func createTmpDirectory() {
  mkdir(path: tmpDir)
}

func removeTmpDirectory() {
  rmdir(path: tmpDir)
}
*/

fileprivate func full(path: String) -> String {
  if path[path.startIndex] == "/" {
    return path
  }
  let currentDir = FileManager.default.currentDirectoryPath
  return currentDir + "/" + path
}

fileprivate func nowTime() -> String {
  let format = DateFormatter()
  format.dateFormat = "yyyy-MM-dd-HH-mm-ss-SSS"
  return format.string(from: Date())
}

fileprivate func loadInvalidSyntaxPlist(path: String) -> String {
  let importURL = URL(fileURLWithPath: path)
  var text = ""
  do {
    text = try String(contentsOf: importURL, encoding: String.Encoding.utf8)
  } catch {
    ErrorMessage("Failed to load file '\(path)'")
  }
  return text
}

fileprivate extension String {
  func unEscapeBackSlash() -> String {
    let twoSlash = "([^\\\\])\\\\\\\\([^\\\\])"
    let oneSlash = "$1\\\\$2"
    return replacingOccurrences(
      of: twoSlash,
      with: oneSlash,
      options: .regularExpression,
      range: range(of: self)
    )
  }

  func replaceBinary2Dummy() -> String {
    let regexOfInvalidSyntax = "\\{length = [0-9]+, bytes = ([0-9]| |\\.|x|[a-f])+\\}"
    let replacingString = "\"This String is replaced by patch-defaults. Original plist file (old-style-ascii) contains a binary data with invalid syntax\""
    return replacingOccurrences(
      of: regexOfInvalidSyntax,
      with: replacingString,
      options: .regularExpression,
      range: range(of: self)
    )
  }
}

func mkdir(path: String) {
  do {
    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
  } catch {
    ErrorMessage("Failed to make directory '\(path)'")
  }
}

func rmdir(path: String) {
  do {
    try FileManager.default.removeItem(atPath: path)
  } catch {
    ErrorMessage("Failed to remove directory '\(path)'")
  }
}

fileprivate func writeValidSyntaxText2File(path: String, text: String) {
  do {
    try text.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
  } catch {
    ErrorMessage("Failed to write file '\(path)'")
  }
}

fileprivate func loadValidSyntaxPlist(path: String) -> NSDictionary {
  guard let plist = NSDictionary(contentsOfFile: path) else {
    ErrorMessage("Failed to load property list '\(path)'")
    exit(1)
  }
  return plist
}
