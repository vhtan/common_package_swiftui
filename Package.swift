// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonPackageSwiftUI",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CommonPackageSwiftUI",
            targets: ["CommonPackageSwiftUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "7.0.0"),
        .package(url: "https://github.com/DaveWoodCom/XCGLogger.git", from: "7.0.1"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes.git", from: "5.3.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "6.2.4"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "9.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CommonPackageSwiftUI",
            dependencies: [
                .product(name: "SwiftDate", package: "SwiftDate"),
                .product(name: "XCGLogger", package: "XCGLogger"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk")
            ]),
    ]
)
