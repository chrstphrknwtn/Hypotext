// swift-tools-version: 6.4

import PackageDescription

let package = Package(
  name: "Hypotext",
  platforms: [.macOS(.v13)],
  products: [
    .executable(name: "hypo", targets: ["Hypotext"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.8.2")
  ],
  targets: [
    .executableTarget(
      name: "Hypotext",
      dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")],
    ),
    .testTarget(
      name: "HypotextTests",
      dependencies: ["Hypotext"],
    ),
  ]
)
