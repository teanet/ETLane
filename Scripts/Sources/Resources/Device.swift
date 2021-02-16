enum Device: String {
	case iPhone8
	case iPhone11
	case iPhone8Messages = "iPhone8-message"
	case iPhone11Messages = "iPhone11-message"
	case iPadPro
	case iPadPro3Gen
	case iPadProMessages = "iPadPro-message"
	case iPadPro3GenMessages = "iPadPro3Gen-message"
}

extension Device {
	var scale: Int {
		switch self {
			case .iPhone8, .iPhone11, .iPhone8Messages, .iPhone11Messages: return 3
			case .iPadPro, .iPadPro3Gen, .iPadProMessages, .iPadPro3GenMessages: return 2
		}
	}
	var id: String {
		switch self {
			case .iPhone8: return "APP_IPHONE_55"
			case .iPhone11: return "APP_IPHONE_65"
			case .iPadPro: return "ipad-pro"
			case .iPadPro3Gen: return "ipadPro129"
			case .iPadProMessages: return "ipad-pro-messages"
			case .iPadPro3GenMessages: return "ipadPro129-messages"
			case .iPhone8Messages: return "iPhone 6 Plus (iMessage)"
			case .iPhone11Messages: return "iPhone XS Max (iMessage)"
		}
	}
}
