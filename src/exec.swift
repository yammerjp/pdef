import Foundation
import Foundation

extension Process {
    
    convenience init(_ launchPath: String, _ arguments: [String]? = []) {
        self.init()
        self.launchPath = launchPath
        self.arguments = arguments
    }
    
    static func | (lhs: Process, rhs: Process) -> Process {
        let pipe = Pipe()
        lhs.standardOutput = pipe
        rhs.standardInput = pipe
        
        lhs.launch()
        return rhs
    }
    
    func output() -> Data {
        let pipe = Pipe()
        standardOutput = pipe
        
        launch()
        waitUntilExit()
         
        return pipe.fileHandleForReading.readDataToEndOfFile()
    }

    func outputString() -> String {
        let data = output()
        return String(data: data, encoding: .utf8) ?? ""
    }
}
