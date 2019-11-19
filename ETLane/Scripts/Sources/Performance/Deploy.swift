import Foundation

struct Deploy {
	private let items: [String]
}

extension Deploy.Key {

	var fileName: String? {
		switch self {
			case .title: return "name.txt"
			case .subtitle: return "subtitle.txt"
			case .keywords: return "keywords.txt"
			case .releaseNotes: return "release_notes.txt"
			default: return nil
		}
	}

}

extension Deploy {

	enum Key: Int, CaseIterable {
		case language
		case locale
		case title
		case subtitle
		case keywords
		case iPhone8
		case iPhoneX
		case releaseNotes
	}

	init?(string: String) {
		let cmp = string.components(separatedBy: "\t")
		guard cmp.count == Key.allCases.count else { return nil }
		self.items = cmp
	}

	subscript(key: Key) -> String {
		return self.items[key.rawValue]
	}

	var iPhone8IDs: [String] {
		return self[.iPhone8].ids()
	}

	var iPhoneXIDs: [String] {
		return self[.iPhoneX].ids()
	}

	func createFiles(at url: URL) {
		Key.allCases.forEach {
			if let fileName = $0.fileName {
				url.write(self[$0], to: fileName)
			}
		}
	}

}


extension URL {

	func write(_ text: String, to path: String) {
		let url = self.appendingPathComponent(path)
		do {
			print("Write \(url.path)")
			try text.write(to: url, atomically: true, encoding: .utf8)
			print("Done")
		} catch {
			print(">>>>>\(text) write error: \(error) to path \(url)")
		}

	}

}

fileprivate extension String {

	func ids() -> [String] {
		return self.components(separatedBy: ",").map {
			($0 as NSString).trimmingCharacters(in: CharacterSet(charactersIn: "0123456789:").inverted)
		}.filter {
			!$0.isEmpty
		}
	}

}
