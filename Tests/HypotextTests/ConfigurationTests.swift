import Foundation
import Testing

@testable import Hypotext

private func writeConfiguration(_ contents: String) throws -> (directory: URL, file: URL) {
  let directory = FileManager.default.temporaryDirectory
    .appending(path: UUID().uuidString, directoryHint: .isDirectory)
  try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

  let url = directory.appending(path: "hypotext.json")
  try Data(contents.utf8).write(to: url)

  return (directory, url)
}

struct ConfigurationTests {
  @Test func loadsValidConfiguration() throws {
    let (directory, url) = try writeConfiguration(#"{ "title": "Notes", "domain": "example.com" }"#)
    defer {
      try? FileManager.default.removeItem(at: directory)
    }

    let configuration = try Configuration(contentsOf: url)

    #expect(configuration.title == "Notes")
    #expect(configuration.domain == "example.com")
  }

  @Test func reportsMissingFile() {
    let url = FileManager.default.temporaryDirectory
      .appending(path: UUID().uuidString, directoryHint: .isDirectory)
      .appending(path: "hypotext.json")

    let error = #expect(throws: ConfigurationError.self) {
      try Configuration(contentsOf: url)
    }

    #expect(error?.errorDescription == "hypotext.json: not found")
  }

  @Test(arguments: [
    (#"{ "title": "Notes" }"#, "hypotext.json: missing 'domain'"),
    (#"{ "title": 42, "domain": "example.com" }"#, "hypotext.json: wrong type for 'title'"),
    ("not json", "hypotext.json: not valid JSON"),
  ])
  func reportsInvalidConfiguration(contents: String, expected: String) throws {
    let (directory, url) = try writeConfiguration(contents)
    defer {
      try? FileManager.default.removeItem(at: directory)
    }

    let error = #expect(throws: ConfigurationError.self) {
      try Configuration(contentsOf: url)
    }

    #expect(error?.errorDescription == expected)
  }
}
