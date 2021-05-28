// swift-tools-version:5.3

import PackageDescription

let package = Package(
	name: "ETLane",
	platforms: [
		.iOS(.v10),
	],
	products: [
		.library(name: "ETLane", targets: ["ETLane"]),
	],
	targets: [
		.target(
			name: "ETLane",
			path: "Dummy",
			exclude: [],
			resources: [
				.copy("Lanes"),
				.copy("Scripts"),
			]
		),
	],
	swiftLanguageVersions: [
		.v5
	]
)
