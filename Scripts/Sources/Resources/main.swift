import Foundation
import Common

do {
	let options = ResourcesParser.parseOrExit()
	let figmaApi = Api(baseURL: "https://api.figma.com/v1")

	let deploys = try Deploy.fromTSV(options.tsv)

	let output = (options.output as NSString).expandingTildeInPath
	let outputURL = URL(fileURLWithPath: output)
	let metadataURL = outputURL.appendingPathComponent("metadata")
	let fm = FileManager.default
	try fm.createDirectory(at: metadataURL, withIntermediateDirectories: true, attributes: [:])

	print("Process metadate at \(metadataURL)")
	for deploy in deploys {
		let locale = metadataURL.appendingPathComponent(deploy[.locale])

		do {
			try fm.createDirectory(at: locale, withIntermediateDirectories: true, attributes: [:])
			deploy.createFiles(at: locale)
		} catch {
			print("Create locale error: \(error)")
		}
	}

	if options.downloadScreenshots {
		print("Load figma screenshots data")
		//	if let page = options.figmaPage {
		//		let page = try api.page(token: options.figmaToken, projectId: options.figmaProjectId, page: page)
		//	}

		print("Download figma screenshots data")
		let downloader = ScreenshotDownloader(
			figmaApi: figmaApi,
			outputURL: outputURL,
			token: options.figmaToken,
			projectId: options.figmaProjectId
		)
		try downloader.download(deploys: deploys)
	}

	if options.downloadPreview {
		let downloader = PreviewDownloader(outputURL: outputURL)
		try downloader.download(deploys: deploys)
	}

} catch {
	print("\(error.locd)")
	exit(1)
}
exit(0)

