import Common
import Foundation

final class ScreenshotDownloader {

	private let outputURL: URL
	private let token: String
	private let projectId: String
	init(outputURL: URL, token: String, projectId: String) {
		self.outputURL = outputURL
		self.token = token
		self.projectId = projectId
	}

	let api = Api(baseURL: "https://api.figma.com/v1")

	private func downloadIds(_ ids: [String], repeatCount: Int = 5) -> Images? {
		if repeatCount < 0 {
			return nil
		}
		do {
			let images = try api.images(
				token: self.token,
				projectId: self.projectId,
				ids: ids
			)
			return images
		} catch {
			print("⛔️ Download batch error \(repeatCount - 1), try one more time: \(error.locd)")
			return self.downloadIds(ids, repeatCount: repeatCount - 1)
		}
	}

	func download(deploys: [Deploy]) throws {
		var imageIDs = Set<String>()

		for deploy in deploys {
			imageIDs.formUnion(deploy.iPhone8IDs)
			imageIDs.formUnion(deploy.iPhoneXIDs)
		}

		var allImages = [Images]()

		let downloadIDs = Array(imageIDs)
		let batch = 4
		let figmaGroup = DispatchGroup()

		for idx in stride(from: downloadIDs.indices.lowerBound, to: downloadIDs.indices.upperBound, by: batch) {
			print("⬇️ Fetching image batch: \(idx)")
			let subsequence = downloadIDs[idx..<min(idx.advanced(by: batch), downloadIDs.count)]

			figmaGroup.enter()
			DispatchQueue.global().async {
				if let images = self.downloadIds(Array(subsequence), repeatCount: 6) {
					allImages.append(images)
				} else {
					print("💥 Download batch error, maybe we should limit requests other way")
					exit(1)
				}
				figmaGroup.leave()
			}
		}
		figmaGroup.wait()

		var allImagesKeys = [String: String]()
		allImages
			.compactMap { $0.images }
			.filter { !$0.isEmpty }
			.forEach { (images) in
				for image in images {
					allImagesKeys[image.key] = image.value
				}
			}
		let imageData = DownloadBatch(images: allImagesKeys).download()

		let screenshotsURL = self.outputURL.appendingPathComponent("screenshots")
		let fm = FileManager.default
		try fm.createDirectory(at: screenshotsURL, withIntermediateDirectories: true, attributes: [:])
		print("ℹ️ Process screenshots at \(screenshotsURL)")
		for deploy in deploys {
			let localeURL = screenshotsURL.appendingPathComponent(deploy[.locale])
			do {
				try fm.createDirectory(at: localeURL, withIntermediateDirectories: true, attributes: [:])

				func saveScreenshots(with ids: [String], prefix: String) {
					ids.enumerated().forEach {
						let name = "\(prefix)_\($0.offset).jpg"
						if let data = imageData[$0.element] {
							print("ℹ️ Save screenshot \(localeURL.lastPathComponent)/\(name)")
							do {
								try data.write(to: localeURL.appendingPathComponent(name))
							} catch {
								print("⛔️ Save screenshot error: \(error.locd)")
							}
						}
					}
				}

				saveScreenshots(with: deploy.iPhone8IDs, prefix: "iphone8")
				saveScreenshots(with: deploy.iPhoneXIDs, prefix: "iPhoneX")
			} catch {
				print("⛔️ Create locale folder error: \(error.locd)")
			}
		}
	}

}
