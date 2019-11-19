import Foundation

public typealias CheckResult = [String: TimeInterval]

public struct CheckResults: Codable {
	let performance: CheckResult
	let performanceThreshold: TimeInterval
	enum CodingKeys: String, CodingKey {
		case performance
		case performanceThreshold = "performance_threshold"
	}
}

public struct StatisticsResponse: Codable {
	struct Group: Codable {
		struct Items: Codable {
			struct Stats: Codable {
				let p75: TimeInterval
				let p95: TimeInterval
			}
			let rt: Stats
		}
		let name: String
		let items: Items
	}
	let groups: [Group]

	func check(_ cmp: CheckResult, threshold: TimeInterval) -> [String] {
		var errors = [String]()

		cmp.forEach { (k, v) in
			if let group = self.groups.first(where: { $0.name == k }) {
				let diff = group.items.rt.p95 - v
				if Darwin.fabs(diff) > threshold {
					let diff = String(format: "%.2f", diff)
					errors.append("\(k), expected \(v)ms got \(group.items.rt.p95)ms, diff=\(diff)ms")
				}
			} else {
				errors.append("Missing metric named: \(k)")
			}
		}
		return errors
	}
}
