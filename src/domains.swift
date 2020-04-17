import Foundation

fileprivate func exec(path: String, arguments: [String])-> String{
    let process = Process()

    process.executableURL = URL(fileURLWithPath: path)
    process.arguments = arguments

    let pipe = Pipe()

    process.standardOutput = pipe

    process.launch()

    let readHandle = pipe.fileHandleForReading
    let data = readHandle.readDataToEndOfFile()

    guard let output = String(data: data, encoding: .utf8) else {
        fputs("Execute command '\(path + arguments.joined(separator: " "))' is failed", stderr)
        exit(1)
    }
    return output
}

fileprivate func defaultsDomains()-> [String] {
    let domainsString = exec(path: "/usr/bin/defaults", arguments: ["domains"])
    var domains = domainsString
                    .split(separator: ",")
                    .map({(domainSubstring) -> String in
                        return String(domainSubstring).trimmingCharacters(in: .whitespacesAndNewlines)})
    domains.append("-globalDomain")
    return domains
}

func writeFilesAllPlist(dirPath: String) {

    _ = exec(path: "/bin/rm", arguments: ["-rf", dirPath])
    _ = exec(path: "/bin/mkdir", arguments: ["-p", dirPath])

    let domains = defaultsDomains()

    for domain in domains {
        _ = exec(path: "/usr/bin/defaults", arguments: ["export", domain, "\(dirPath)/\(domain)"])
    }
}

func readFilesAllPlist(dirPath: String)-> [String: NSDictionary] {
    var dictionary : [String: NSDictionary] = Dictionary()

    let files = exec(path: "/bin/ls", arguments: ["-1", dirPath]).lines

    for file in files {
        dictionary[file] = LoadPlist(path: "\(dirPath)/\(file)")
    }
    return dictionary
}

extension String {
    var lines: [String] {
        var lines = [String]()
        self.enumerateLines { (line, stop) -> () in
            lines.append(line)
        }
        return lines
    }
}
