import Foundation

func interpretArgs(args: [String])-> (domain: String?, pathBefore: String, pathAfter: String) {
  if args.count < 2 {
    fputs("Missing arguments.\n", stderr)
    fputs(UsageMessage, stderr)
    exit(1)
  }

  if args[1] == "-h" || args[1] == "--help" {
    fputs(HelpMessage, stderr)
    exit(0)
  }

  if args[1] == "-v" || args[1] == "--version" {
    fputs(VersionMessage, stderr)
    exit(0)
  }

  let withDomainOption = args[1] == "-d" || args[1] == "--domain"

  if args.count < 3 ||  ( withDomainOption && args.count < 5 ) {
    fputs("Missing arguments.\n", stderr)
    fputs(UsageMessage, stderr)
    exit(1)
  }

  let domain = withDomainOption ? args[2] : nil
  let pathBefore = withDomainOption ? args[3] : args[1]
  let pathAfter = withDomainOption ? args[4] : args[2]

  return (domain: domain, pathBefore: pathBefore, pathAfter: pathAfter)
}
