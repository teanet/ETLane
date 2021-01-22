import Common

extension Api {

	func images(token: String, projectId: String, ids: [String]) throws -> Images {
		try self.get(
			path: "images/\(projectId)",
			query: [
				"ids" : ids.joined(separator: ","),
				"format": "jpg",
				"scale": "3",
			],
			headers: [
				"X-FIGMA-TOKEN" : token
			],
			timeoutInterval: 300
		)
	}

}
