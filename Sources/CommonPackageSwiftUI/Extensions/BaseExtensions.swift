//
//  BaseExtensions.swift
//  wisnet
//
//  Created by Tan Vo on 26/09/2022.
//

import SwiftUI

public extension Data {
    var toDictionary: [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: [])).flatMap { $0 as? [String: Any] }
    }
}

public extension String {
    func replace(string string1: String, by string2: String) -> String {
        return self.replacingOccurrences(of: string1, with: string2)
    }
}

public extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
    
    var appId: String {
        get {
            return "\(bundleIdentifier ?? "none")".replace(string: "-", by: ".")
        }
    }
}

public extension UserDefaults {
    func object<E: RawRepresentable>(for key: E) -> Any? where E.RawValue == String {
        return self.object(forKey: key.rawValue)
    }
    
    func setObject<E: RawRepresentable>(_ obj: Any?, for key: E) where E.RawValue == String {
        self.set(obj, forKey: key.rawValue)
        self.synchronize()
    }
    
    func removeObject<E: RawRepresentable>(for key: E) where E.RawValue == String {
        self.removeObject(forKey: key.rawValue)
        self.synchronize()
    }
}

public extension NotificationCenter {
    func post<E: RawRepresentable>(notificationKey: E, object: Any? = nil) where E.RawValue == String {
        var notification = Notification(name: Notification.Name(rawValue: notificationKey.rawValue))
        notification.object = object
        post(notification)
    }
    
    func addObserver<E: RawRepresentable>(forNotificationKey notificationKey: E,
                                          callback: @escaping (Any?) -> Void) where E.RawValue == String {
        let name = Notification.Name(rawValue: notificationKey.rawValue)
        addObserver(forName: name, object: nil, queue: nil) { (notification) in
            callback(notification.object)
        }
    }
}

public extension Int {
    var toBool: Bool {
        if self == 0 {
            return false
        } else {
            return true
        }
    }
}

public extension Double {
    func toPrice(currency: String = "đ") -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}

public enum ScreenSize {
    public static let width = UIScreen.main.bounds.width
    public static let height = UIScreen.main.bounds.height
}

public extension SwiftUI.Color {
    var uiColor: UIColor {
        return UIColor(self)
    }
}

public extension Image {
    var icAccount: Image {
        return .init("ic_account")
    }
}

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue:  Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

public extension Encodable {
    func asDictionary(encoder: JSONEncoder = JSONEncoder()) -> [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

public extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}

public extension Dictionary {
    func toData() -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        } catch {
            return nil
        }
    }
}

public extension Data {
    var mimeType: String {
        var values = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &values, count: 1)
        
        switch values[0] {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tiff"
        default:
            return "undefine"
        }
    }
}
