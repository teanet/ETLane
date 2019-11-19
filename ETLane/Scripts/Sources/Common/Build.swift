//{
//	"id": 76889,
//	"env": "Memocon report",
//	"description": "",
//	"scm": {
//		"parameters": {}
//	},
//	"links": [],
//	"created_at": "2019-08-06T18:10:09.272327"
//},

public typealias BuildId = UInt
public typealias ReportId = UInt

public struct Build: Codable {
	let id: BuildId
	let env: String
}

public struct PostStats {
	public let reportId: ReportId
	public let builds: [Build]
}
