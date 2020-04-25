import Foundation

func checkArgs(args: [String]) -> [String: String?] {
  if args.count == 0 || args.contains(where: { $0 == "--help" || $0 == "-h" }) {
    help()
    exit(0)
  }
  if args.contains(where: { $0 == "--version" || $0 == "-v" }) {
    version()
    exit(0)
  }
  if !checkArgsWithRegex(args: args) {
    ErrorMessage("Missing Arguments")
    exit(1)
  }

  let domain = args.optionValue(option: "--domain") ?? args.optionValue(option: "-d")
  if let dump = args.optionValue(option: "dump") {
    return ["domain": domain, "dump": dump]
  }
  guard let out = args.optionValue(option: "out") else {
    ErrorMessage("Missing Arguments")
    exit(1)
  }
  let before = args.optionValue(option: "--before") ?? args.optionValue(option: "-b")
  let after = args.optionValue(option: "--after") ?? args.optionValue(option: "-a")
  return ["domain": domain, "out": out, "before": before, "after": after]
}

fileprivate extension Array where Element == String {
  func optionValue(option: String) -> String? {
    guard let index = self.firstIndex(of: option) else {
      return nil
    }
    guard index+1 < self.count else {
      exit(1)
    }
    return self[index+1]
  }
}

fileprivate func checkArgsWithRegex(args: [String])-> Bool {
  let regex = try! NSRegularExpression(
    pattern: #"^((-d|--domain) .* )?(dump( .+)?)|(out( -(b|-before) .*)?( -(a|-after) .*)?)$"#,
    options: []
  )
  let text = args.joined(separator: " ")
  let matches = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
  return matches.count > 0
}

