// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacToDo",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "MacToDo", targets: ["MacToDo"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "MacToDo",
            dependencies: [],
            path: "Sources",
            exclude: [
                "Config/Info.plist"
            ]
        ),
        .testTarget(
            name: "MacToDoTests",
            dependencies: ["MacToDo"],
            path: "Tests/MacToDoTests"
        ),
    ]
)
