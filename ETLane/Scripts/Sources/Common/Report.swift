//{
//	"id": 0,
//	"created_at": "2019-09-02T04:29:24.311Z",
//	"label": "string",
//	"description": "string",
//	"scm": {
//		"vcs": {
//			"reference": "string",
//			"revision": "string",
//			"title": "string"
//		},
//		"parameters": {}
//	},
//	"links": [
//	{
//	"url": "string",
//	"label": "string"
//	}
//	],
//	"passed": true
//}

public struct Report: Codable {
	let id: ReportId
	let label: String
	let links: [Link]
}

public struct CreateReport: Codable {
	var label: String
	var links: [Link]
}
