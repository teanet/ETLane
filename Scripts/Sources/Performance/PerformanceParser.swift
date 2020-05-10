import Common

class PerformanceParser: ArgumentParser<Args> {

	init() {
		super.init(into: Args())
		self.addArgument("--output", \.output, help: "Path to output folder") { $0 }
		self.addArgument("--skip_screenshots", \.skip_screenshots, help: "Skip screenshots?") { $0 == "true" }
		self.addArgument("--download_preview", \.download_preview, help: "Download preview?") { $0 == "true" }
		self.addArgument("--figmaToken", \.figmaToken, help: "Figma token") { $0 }
		self.addArgument("--figmaProjectId", \.figmaProjectId, help: "Figma project id") { $0 }
		self.addArgument(nil, \.labels)
	}

}
