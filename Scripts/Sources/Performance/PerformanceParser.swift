import Common

class PerformanceParser: ArgumentParser<Args> {

	init() {
		super.init(into: Args())
		self.addArgument("--output", \.output, help: "Path to output folder") { $0 }
		self.addArgument("--skip_screenshots", \.skip_screenshots, help: "Skip screenshots?") { $0 == "true" }
		self.addArgument("--download_preview", \.download_preview, help: "Download preview?") { $0 == "true" }
		self.addArgument(nil, \.labels)
//		self.addArgument("--links", \Args.links, help: "Tag1:URL1,Tag2:URL2") {
//			let linksStrings = $0.components(separatedBy: ",")
//			return linksStrings.compactMap({ Link.with($0) })
//		}
//		self.addArgument("--metrics", \.metricsPath, help: "Path to metrics.json file") { $0 }
//		self.addArgument("--label", \.label, help: "Report label ex. pr_0001") { $0 }
	}

}
