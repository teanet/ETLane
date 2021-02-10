import Foundation
import Common

struct Args {
	var output: String = ""
	var skip_screenshots: Bool = false
	var download_preview: Bool = false
	var labels = [String]()
	var figmaToken: String = ""
	var figmaProjectId: String = ""

	public enum ArgsError: Error {
		case noTSVPath
		case noOutputPath
		case noLabel
		case noFigmaToken
		case noFigmaProjectId
	}

	func check() throws {
		if self.labels.isEmpty { throw ArgsError.noTSVPath }
		if self.output.isEmpty { throw ArgsError.noOutputPath }
		if self.figmaToken.isEmpty { throw ArgsError.noFigmaToken }
		if self.figmaProjectId.isEmpty { throw ArgsError.noFigmaProjectId }
	}
}

public extension Error {

	var locd: String {
		return "\(self.localizedDescription) - \(self)"
	}

}

