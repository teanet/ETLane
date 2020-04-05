import Common
import Foundation

final class ScreenshotDownloader {

	private let outputURL: URL
	init(outputURL: URL) {
		self.outputURL = outputURL
	}

	func download(deploys: [Deploy]) throws {
		var imageIDs = Set<String>()

		for deploy in deploys {
			imageIDs.formUnion(deploy.iPhone8IDs)
			imageIDs.formUnion(deploy.iPhoneXIDs)
		}

		let api = Api(baseURL: "https://api.figma.com/v1")
		var allImages = [Images]()

		var downloadIDs = Array(imageIDs)
		let batch = 5
		let figmaGroup = DispatchGroup()

		for idx in stride(from: downloadIDs.indices.lowerBound, to: downloadIDs.indices.upperBound, by: batch) {
			print("Fetching image batch: \(idx)")
			let subsequence = downloadIDs[idx..<min(idx.advanced(by: batch), downloadIDs.count)]

			figmaGroup.enter()
			DispatchQueue.global().async {
				do {
					let images = try api.images(
						token: "25848-7b355d9f-7f96-448c-9c02-595ca702bf28",
						projectId: "Z5blVY6lQWnQQ05mYrkCyK",
						ids: Array(subsequence)
					)
					allImages.append(images)
				} catch {
					print("Download batch error: \(error.locd)")
				}
				figmaGroup.leave()
			}
		}
		figmaGroup.wait()

		let session = URLSession.shared
		var imageData = [String: Data]()
		let downloadGroup = DispatchGroup()
		allImages
			.compactMap { $0.images }
			.filter { !$0.isEmpty }
			.forEach { (images) in

				for kv in images {
					guard let imageURL = URL(string: kv.value) else { continue }
					print("Download image with url: \(kv.value)")
					downloadGroup.enter()
					let request = URLRequest(
						url: imageURL,
						cachePolicy: .
						reloadIgnoringLocalCacheData,
						timeoutInterval: 5 * 60
					)
					session.downloadTask(with: request) { (url, r, e) in
						if let url = url {
							do {
								let data = try Data(contentsOf: url)
								imageData[kv.key] = data
								print("Did finish \(kv.value)")
							} catch {
								print("Did fail download: \(kv.value), \(error)")
							}
						} else if let error = e {
							print("Did fail download: \(kv.value), \(error)")
						}
						downloadGroup.leave()
					}.resume()
				}
		}
		downloadGroup.wait()

		let screenshotsURL = self.outputURL.appendingPathComponent("screenshots")
		let fm = FileManager.default
		try fm.createDirectory(at: screenshotsURL, withIntermediateDirectories: true, attributes: [:])
		print("Process screenshots at \(screenshotsURL)")
		for deploy in deploys {
			let localeURL = screenshotsURL.appendingPathComponent(deploy[.locale])
			do {
				try fm.createDirectory(at: localeURL, withIntermediateDirectories: true, attributes: [:])

				func saveScreenshots(with ids: [String], prefix: String) {
					ids.enumerated().forEach {
						let name = "\(prefix)_\($0.offset).jpg"
						if let data = imageData[$0.element] {
							print("Save screenshot \(name)")
							do {
								try data.write(to: localeURL.appendingPathComponent(name))
							} catch {
								print("Save screenshot error: \(error.locd)")
							}
						}
					}
				}

				saveScreenshots(with: deploy.iPhone8IDs, prefix: "iphone8")
				saveScreenshots(with: deploy.iPhoneXIDs, prefix: "iPhoneX")
			} catch {
				print("Create locale folder error: \(error.locd)")
			}
		}
	}

}
