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

	private func downloadIds(_ ids: [String], repeatCount: Int = 5, scale: Int) -> Images? {
		if repeatCount < 0 {
			return nil
		}
		do {
			let images = try api.images(
				token: self.token,
				projectId: self.projectId,
				ids: ids,
				scale: scale
			)
			if let err = images.err {
				print("⛔️ Download error \(repeatCount - 1), try one more time: \(err)")
				return self.downloadIds(ids, repeatCount: repeatCount - 1, scale: scale)
			} else {
				return images
			}
		} catch {
			print("⛔️ Download batch error \(repeatCount - 1), try one more time: \(error.locd)")
			return self.downloadIds(ids, repeatCount: repeatCount - 1, scale: scale)
		}
	}

	func download(ids: Set<String>, scale: Int) -> [Images] {
		let downloadIDs = Array(ids)
		let batch = 10
//		let figmaGroup = DispatchGroup()
		var allImages = [Images]()
		for idx in stride(from: downloadIDs.indices.lowerBound, to: downloadIDs.indices.upperBound, by: batch) {
			print("⬇️ Fetching image batch: \(idx)")
			let subsequence = downloadIDs[idx..<min(idx.advanced(by: batch), downloadIDs.count)]

//			figmaGroup.enter()
//			DispatchQueue.global().async {
			if let images = self.downloadIds(Array(subsequence), repeatCount: 6, scale: scale) {
					allImages.append(images)
				} else {
					print("💥 Download batch error, maybe we should limit requests other way")
					exit(1)
				}
//				figmaGroup.leave()
//			}
		}
//		figmaGroup.wait()
		return allImages
	}

	func download(deploys: [Deploy]) throws {
		var imageIDs2x = Set<String>()
		var imageIDs3x = Set<String>()

		for deploy in deploys {
			let allprefixes = deploy.screenshotPrefixToIds()
			print(">>>>>\(allprefixes)")

			for prefixes in allprefixes {
				for ids in prefixes.value {
					if ids.scale == 2 {
						imageIDs2x.insert(ids.id)
					} else if ids.scale == 3 {
						imageIDs3x.insert(ids.id)
					}
				}
			}
		}

		var allImages = [Images]()
		allImages += self.download(ids: imageIDs2x, scale: 2)
		allImages += self.download(ids: imageIDs3x, scale: 3)

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

				func saveScreenshots(with ids: [Deploy.IdWithScale], prefix: String) {
					ids.enumerated().forEach { offset, element in
						let name = "\(offset)_\(prefix)_\(offset).jpg"
						if let data = imageData[element.id] {
							print("ℹ️ Save screenshot \(localeURL.lastPathComponent)/\(name)")
							do {
								try data.write(to: localeURL.appendingPathComponent(name))
							} catch {
								print("⛔️ Save screenshot error: \(error.locd)")
							}
						}
					}
				}
				let prefixToIds = deploy.screenshotPrefixToIds()
				prefixToIds.forEach { (prefix, ids) in
					saveScreenshots(with: ids, prefix: prefix)
				}
			} catch {
				print("⛔️ Create locale folder error: \(error.locd)")
			}
		}
	}

}
