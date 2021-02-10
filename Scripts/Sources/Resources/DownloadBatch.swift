import Foundation

class DownloadBatch {

	static let kMaximumDownloadsCount = 10

	private let images: [String: String]
	private var imagesLeft = [String: String]()
	private let downloadGroup = DispatchGroup()
	private let session = URLSession.shared
	private var imageData = [String: Data]()
	private var currentDownloadKeys = Set<String>()

	init(images: [String: String]) {
		self.images = images
		self.imagesLeft = images
	}

	func download() -> [String: Data] {
		self.downloadGroup.enter()
		self.downloadNext()
		self.downloadGroup.wait()
		return self.imageData
	}

	private func downloadNext() {
		if self.imagesLeft.isEmpty && self.currentDownloadKeys.isEmpty {
			self.downloadGroup.leave()
		} else if self.currentDownloadKeys.count < DownloadBatch.kMaximumDownloadsCount {

			if let first = self.imagesLeft.first {
				self.imagesLeft.removeValue(forKey: first.key)
				self.currentDownloadKeys.insert(first.key)
				self.downloadItem(key: first.key, value: first.value, retryCount: 3) {
					self.currentDownloadKeys.remove(first.key)
					self.downloadNext()
				}
				self.downloadNext()
			}
		}
	}

	private func downloadItem(key: String, value: String, retryCount: Int, completion: @escaping () -> Void) {
		if self.imageData[key] != nil {
			completion(); return
		}
		if retryCount < 0 {
			print("⛔️ Download image \(value) retry count limit")
			completion(); return
		}

		let imageURL = URL(string: value)!
		print("⬇️ Download image(\(retryCount)) with url: \(value)")
		let request = URLRequest(
			url: imageURL,
			cachePolicy: .reloadIgnoringLocalCacheData,
			timeoutInterval: 5 * 60
		)
		self.session.downloadTask(with: request) { (url, r, e) in
			if let url = url {
				do {
					let data = try Data(contentsOf: url)
					self.imageData[key] = data
					print("✅ Did finish \(value)")
					completion()
				} catch {
					print("⛔️ Did fail download, retry: \(value), \(error)")
					self.downloadItem(key: key, value: value, retryCount: retryCount - 1, completion: completion)
				}
			} else {
				if let error = e {
					print("⛔️ Did fail download, retry: \(value), \(error)")
				}
				self.downloadItem(key: key, value: value, retryCount: retryCount - 1, completion: completion)
			}
		}.resume()
	}

}
