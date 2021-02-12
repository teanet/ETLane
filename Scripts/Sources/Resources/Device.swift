enum Device: String {
	case iPhone8
	case iPhone11
	case iPadPro
	case iPadPro3Gen
}

extension Device {
	var scale: Int {
		switch self {
			case .iPhone8, .iPhone11: return 3
			case .iPadPro, .iPadPro3Gen: return 2
		}
	}
	var id: String {
		switch self {
			case .iPhone8: return "APP_IPHONE_55"
			case .iPhone11: return "APP_IPHONE_65"
			case .iPadPro: return "APP_IPAD_PRO_129"
			case .iPadPro3Gen: return "APP_IPAD_PRO_3GEN_129"
		}
	}
}
