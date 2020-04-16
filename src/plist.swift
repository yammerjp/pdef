import Foundation

class Plist {
  init(path: String ) {
    guard let root = NSDictionary(contentsOfFile: path) else {
      fputs("Loading property list '\(path)' is failed", stderr)
      exit(1)
    }
    self.root = root
  }  
  let root: NSDictionary

  func printAll(){
    let keys = root.allKeys
    for key in keys {
      print( "\(key): " + String(describing: root[key]))
    }
  }
}