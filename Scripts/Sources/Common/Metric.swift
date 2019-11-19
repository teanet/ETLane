//{
//	"query": "http://example.org/sample",
//	"payload": "foo=bar",
//	"status": "OK",
//	"code": 201,
//	"datetime": "2018-02-02T05:32:00.358",
//	"metrics": {
//		"rt": 150
//	}
//}

public struct Metric: Codable {
	let status: String = "OK"
	let datetime: String
	let metrics: [String: Double]
	let query: String = ""
	let group: String
}

/// Метрики, которые собрали из тестов
public struct RawMetric: Codable {

	struct Value: Codable {
		/// https://perfberry.web-staging.2gis.ru/info
		/// Memory	"mu"	Used memory in MB, less is better
		/// RT		"rt"	Response time in ms, less is better
		let type: String
		let value: Double
		let datetime: String
	}

	let env: String
	let rawMetrics: [String : [Value]]
	enum CodingKeys: String, CodingKey {
		case env
		case rawMetrics = "raw_metrics"
	}

	func statistic() -> Statistic {
		var metrics = [Metric]()
		for (group, values) in self.rawMetrics {
			for value in values {
				metrics.append(Metric(datetime: value.datetime, metrics: [value.type : value.value], group: group))
			}
		}
		return Statistic(env: self.env, metrics: metrics)
	}
}

public struct Statistic: Codable {
	let env: String
	let metrics: [Metric]
}
