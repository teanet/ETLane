import Foundation

public class FileUtil {

	enum FileUtilError: Error {
		case noStatisticsAtPath
	}

	public static func reports(with path: String) throws -> [Statistic] {
		let files = try FileManager.default.contentsOfDirectory(atPath: path)

		var statistics = [Statistic]()
		var reports = [String]()
		for file in files {
			if (file as NSString).pathExtension == "json" {
				let statPath = (path as NSString).appendingPathComponent(file)
				let data = try Data(contentsOf: URL(fileURLWithPath: statPath))
				if let rawMetric = try? JSONDecoder().decode(RawMetric.self, from: data) {
					/// В папке могут быть файлы json но с другим форматом, и это ок
					statistics.append(rawMetric.statistic())
					reports.append(file)
				}
			}
		}
		if statistics.isEmpty {
			throw FileUtilError.noStatisticsAtPath
		} else {
			print("Found reports: \(reports.joined(separator: ", "))")
		}
		return statistics
	}

	public static func metric(with path: String) throws -> CheckResults {
		let data = try Data(contentsOf: URL(fileURLWithPath: path))
		return try JSONDecoder().decode(CheckResults.self, from: data)
	}

}
