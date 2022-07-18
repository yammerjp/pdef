import Foundation

func ErrorMessage(_ message: String) {
  fputs(message, stderr)
  exit(1)
}
