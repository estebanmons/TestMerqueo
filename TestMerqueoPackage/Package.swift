// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestMerqueoPackage",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TestMerqueoPackage",
            targets: ["TestMerqueoPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.0.0")),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TestMerqueoPackage",
            dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift"), .product(name: "RxTest", package: "RxSwift"), "SDWebImage"]),
        .testTarget(
            name: "TestMerqueoPackageTests",
            dependencies: ["TestMerqueoPackage"]),
    ]
)
