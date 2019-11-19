public struct Link: Codable {
	public let label: String
	public let url: String
}

extension Link {

	public static func with(_ string: String) -> Link? {
		var cmp = string.components(separatedBy: ":")
		if cmp.count > 1 {
			let label = cmp.removeFirst()
			return Link(label: label, url: cmp.joined(separator: ":"))
		}
		return nil
	}

}
