import Foundation

struct Configuration: Decodable {
  let title: String
  let domain: String
}

extension Configuration {
  init(contentsOf url: URL) throws {
    do {
      self = try JSONDecoder().decode(Self.self, from: Data(contentsOf: url))
    } catch {
      throw ConfigurationError(url: url, error: error)
    }
  }
}

struct ConfigurationError: LocalizedError {
  let url: URL
  let error: any Error

  var errorDescription: String? {
    "\(url.lastPathComponent): \(reason)"
  }

  private var reason: String {
    switch error {
    case CocoaError.fileReadNoSuchFile:
      "not found"
    case DecodingError.keyNotFound(let key, _):
      "missing '\(key.stringValue)'"
    case DecodingError.typeMismatch(_, let context):
      "wrong type for '\(context.path)'"
    case DecodingError.dataCorrupted:
      "not valid JSON"
    default:
      error.localizedDescription
    }
  }
}

extension DecodingError.Context {
  fileprivate var path: String { codingPath.map(\.stringValue).joined(separator: ".") }
}
