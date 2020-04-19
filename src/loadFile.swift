import Foundation

enum PlistFormat: Int {
  case xml
  case ascii
}

fileprivate let tmpDir = "/tmp/patch-defaults"

func loadFile(path: String, format: PlistFormat) -> NSDictionary {
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

func createTmpDirectory() {
  mkdir(path: tmpDir)
}

func removeTmpDirectory() {
  rmdir(path: tmpDir)
}

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
    fputs("Failed to load file '\(path)'", stderr)
    exit(1)
  }
  return text
}

fileprivate extension String {
  func unEscapeBackSlash() -> String {
    let twoSlash = "([^\\\\])\\\\\\\\([^\\\\])"
    let oneSlash = "$1\\\\$2"
    return self.replacingOccurrences(
      of: twoSlash,
      with: oneSlash,
      options: .regularExpression,
      range: self.range(of: self))
  }

  func replaceBinary2Dummy() -> String {
    let regexOfInvalidSyntax = "\\{length = [0-9]+, bytes = ([0-9]| |\\.|x|[a-f])+\\}"
    let replacingString = "\"This String is replaced by patch-defaults. Original plist file (old-style-ascii) contains a binary data with invalid syntax\""
    return self.replacingOccurrences(
      of: regexOfInvalidSyntax,
      with: replacingString,
      options: .regularExpression,
      range: self.range(of: self))
  }
}

fileprivate func mkdir(path: String) {
  do {
    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
  } catch {
    fputs("Failed to make directory '\(path)'", stderr)
    exit(1)
  }
}

fileprivate func rmdir(path: String) {
  do {
    try FileManager.default.removeItem(atPath: path)
  } catch {
    fputs("Failed to remove directory '\(path)'", stderr)
    exit(1)
  }
}

fileprivate func writeValidSyntaxText2File(path: String, text: String) {
  do {
    try text.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
  } catch {
    fputs("Failed to write file '\(path)'", stderr)
    exit(1)
  }
}

fileprivate func loadValidSyntaxPlist(path: String) -> NSDictionary {
  guard let plist = NSDictionary(contentsOfFile: path) else {
    fputs("Failed to load property list '\(path)'", stderr)
    exit(1)
  }
  return plist
}
