import ArgumentParser
import Foundation

@main
struct Hypotext: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "hypo",
    abstract: "A simple static site generator",
    subcommands: [Build.self, Serve.self],
    defaultSubcommand: Serve.self
  )
}

struct Build: ParsableCommand {
  func run() throws {
    let config = try Configuration(contentsOf: URL(filePath: "./hypotext.json"))

    dump(config)
  }
}

struct Serve: ParsableCommand {
  func run() throws {
    let config = try Configuration(contentsOf: URL(filePath: "./hypotext.json"))

    dump(config)
  }
}
