import Foundation
import Common

do {
	let args = PerformanceParser().parse()
	try args.check()
	let path = args.labels[0]
	print(">>>>>\(args)")
	let data = try Data(contentsOf: URL(string: path)!)
	let tsv = String(data: data, encoding: .utf8)!.components(separatedBy: "\n").dropFirst()
	let deploys = tsv.map { Deploy(string: $0) }

	let output = (args.output as NSString).expandingTildeInPath
	let outputURL = URL(fileURLWithPath: output)
	let metadataURL = outputURL.appendingPathComponent("metadata")
	let fm = FileManager.default
	try fm.createDirectory(at: metadataURL, withIntermediateDirectories: true, attributes: [:])

	print("Process screenshots at \(metadataURL)")
	for deploy in deploys {
		let locale = metadataURL.appendingPathComponent(deploy[.locale])

		do {
			try fm.createDirectory(at: locale, withIntermediateDirectories: true, attributes: [:])
			deploy.createFiles(at: locale)
		} catch {
			print(">>>>>create locale error: \(error)")
		}
	}

	if !args.skip_screenshots {
		let downloader = ScreenshotDownloader(outputURL: outputURL)
		try downloader.download(deploys: deploys)
	}

	if !args.skip_preview {
		let downloader = PreviewDownloader(outputURL: outputURL)
		try downloader.download(deploys: deploys)
	}


} catch {
	print("\(error.locd)")
	exit(1)
}
exit(0)

