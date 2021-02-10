import Common

struct FigmaPage: Codable {
	struct Node: Codable {
		struct Document: Codable {
			struct Child: Codable {
				let id: String
				let name: String
			}
			let name: String
			let children: [Child]
		}
		let document: Document
	}
	let name: String
	let nodes: [String: Node]
}

extension Api {

	func page(
		token: String,
		projectId: String,
		page: String
	) throws -> FigmaPage {
		try self.get(
			path: "files/\(projectId)/nodes",
			query: [
				"ids" : page,
				"depth": "1",
			],
			headers: [
				"X-FIGMA-TOKEN" : token
			],
			timeoutInterval: 300
		)
	}

	func images(
		token: String,
		projectId: String,
		ids: [String],
		scale: Int
	) throws -> Images {
		try self.get(
			path: "images/\(projectId)",
			query: [
				"ids" : ids.joined(separator: ","),
				"format": "jpg",
				"scale": "\(scale)",
			],
			headers: [
				"X-FIGMA-TOKEN" : token
			],
			timeoutInterval: 300
		)
	}

}
