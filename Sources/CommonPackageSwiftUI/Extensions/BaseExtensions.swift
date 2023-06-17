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
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

extension SwiftUI.Color {
    var uiColor: UIColor {
        return UIColor(self)
    }
}

extension Image {
    var icAccount: Image {
        return .init("ic_account")
    }
}
