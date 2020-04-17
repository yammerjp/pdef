import Foundation

if CommandLine.arguments.count < 2 {
  fputs("Missing Arguments", stderr)
  exit(1)
}
let subCommand = CommandLine.arguments[1]


switch subCommand {
  case "before":
    writeFilesAllPlist(dirPath: "/tmp/patch-defaults/before")
  case "after":
    writeFilesAllPlist(dirPath: "/tmp/patch-defaults/after")
  case "diff":
    parseBeforePlists()
  default:
    exit(0)
}

func parseBeforePlists() {
  let plists = readFilesAllPlist(dirPath: "/tmp/patch-defaults/before")
  for (domain, plist) in plists {
    print("########## \(domain) ##########")
    let plist = Plist(root: plist)
    plist.traceRoot()
  }
}
