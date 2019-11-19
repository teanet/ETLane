import Foundation
import Common

struct Args {
	var output: String = ""
	var skip_screenshots: Bool = false
//	var metricsPath: String = ""
//	var links: [Link] = []
	var labels = [String]()

	public enum ArgsError: Error {
		case noTSVPath
		case noOutputPath
		case noLabel
	}

	func check() throws {
		if self.labels.isEmpty { throw ArgsError.noTSVPath }
		if self.output.isEmpty { throw ArgsError.noOutputPath }
//		if self.label.isEmpty { throw ArgsError.noLabel }
	}
}

public extension Error {

	var locd: String {
		return "\(self.localizedDescription) - \(self)"
	}

}

