import Foundation
import Common

do {
	let options = ResourcesParser.parseOrExit()
	let tsv = options.tsv
	print(">>>>>\(tsv)")
	let data = try Data(contentsOf: URL(string: tsv)!)
	var map = [Int: Deploy.NamedKey]()
	let deploys: [Deploy]

	do {
		let tsv = String(data: data, encoding: .utf8)!.components(separatedBy: "\n")
		guard tsv.count > 1 else { print("TSV should have more than 1 line"); exit(-1) }
		let keys = tsv[0].components(separatedBy: "\t")
		print("Raw keys: \(keys)")
		keys.enumerated().forEach { (idx, key) in
			map[idx] = Deploy.NamedKey(rawValue: key.fixedValue())
		}
		print("Found keys: \(map.map({ "\($0.key):\($0.value.rawValue)" }))")
		deploys = tsv.dropFirst().map { Deploy(string: $0, map: map) }
	}

	let output = (options.output as NSString).expandingTildeInPath
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

	if options.downloadScreenshots {
		let downloader = ScreenshotDownloader(
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

