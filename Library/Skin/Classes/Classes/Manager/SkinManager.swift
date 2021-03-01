//
//  SkinManager.swift
//  blackboard
//
//  Created by kingxt on 11/8/17.
//  Copyright © 2017 xkb. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public typealias ChangeSkinBlock = (_ name: SkinType, _ event: SkinChangeEvent) -> Void
public func classBuildInLogo(_ named: String) -> UIImage? {
    return UIImage(named: named, in: SkinManager.instance.config.classBuildInLogoBundle, compatibleWith: nil)
}

public enum SkinType: String {
    case light = "Default"
    case dark  = "DarkMode"
}

public enum SkinChangeEvent {
    case change
    case reset
    case apply
    case xp
}

public class SkinConfig {
    let defaultBundle: URL
    let classBuildInLogoBundle: Bundle?
    var currentSkin: SkinType?
    var currentBundle: Bundle?
    var currentBundleName = SkinType.light

    init() {
        let bundle = Bundle(for: SkinConfig.self)
        defaultBundle = bundle.url(forResource: "Default", withExtension: "bundle")!
        classBuildInLogoBundle = Bundle(url: bundle.url(forResource: "ClassBuildInLogo", withExtension: "bundle")!)
        currentBundle = Bundle(url: defaultBundle)
    }
}

public class SkinManager: NSObject {
    @objc static public let instance = SkinManager()
    public var changeSkinBlock: ChangeSkinBlock? = nil
    public var config = SkinConfig()
    public var json: JSON = JSON([:])
    
    @objc public func getSkinType() -> NSString {
        return config.currentBundleName.rawValue as NSString
    }

    public func configNormalSkin() {
        if let styleFile = config.currentBundle?.url(forResource: "style", withExtension: "json") {
            if let styleKit = StyleKit(fileUrl: styleFile) {
                styleKit.apply()
            }
            json = (try? JSON(data: Data(contentsOf: styleFile))) ?? JSON([:])
        }
    }

    public func initSkin() {
        if let value = UserDefaults.standard.string(forKey: "SkinName") {
            let skinType = SkinType(rawValue: value) ?? SkinType.light
            config.currentBundleName = skinType
            config.currentBundle = Bundle(url: Bundle.main.url(forResource: value, withExtension: "bundle") ?? config.defaultBundle)
        }
    }

    @objc public func isDark() -> Bool {
        return UserDefaults.standard.string(forKey: "SkinName") == SkinType.dark.rawValue
    }

    @objc public func applySkin() {
        initSkin()
        configNormalSkin()
        changeSkinBlock?(config.currentBundleName, SkinChangeEvent.apply)
    }

    public func changeSkin(name: String) {
        UserDefaults.standard.set(name, forKey: "SkinName")
        UserDefaults.standard.synchronize()
        initSkin()
        configNormalSkin()
        NotificationCenter.default.post(customNotification: .changeSkinKey, object: self, userInfo: nil)
        changeSkinBlock?(config.currentBundleName, SkinChangeEvent.change)
    }

    public func setXPSkin() {
        func changeSkin() {
            if config.currentBundleName != SkinType.light {
                self.config.currentSkin = self.config.currentBundleName == SkinType.light ? SkinType.dark : self.config.currentBundleName
                self.config.currentBundleName = SkinType.light
                if let bundleUrl = Bundle.main.url(forResource: self.config.currentBundleName.rawValue, withExtension: "bundle") {
                    self.config.currentBundle = Bundle(url: bundleUrl)
                }
                self.configNormalSkin()
                self.changeSkinBlock?(self.config.currentBundleName, SkinChangeEvent.xp)
            }
        }

        if Thread.current.isMainThread {
            changeSkin()
        } else {
            DispatchQueue.main.async {
                changeSkin()
            }
        }
    }

    public func resetSkin() {
        func changeSkin() {
            if let value = config.currentSkin {
                self.config.currentSkin = nil
                self.config.currentBundleName = value
                if let bundleUrl = Bundle.main.url(forResource: value.rawValue, withExtension: "bundle") {
                    self.config.currentBundle = Bundle(url: bundleUrl)
                }
                self.configNormalSkin()
                self.changeSkinBlock?(self.config.currentBundleName, SkinChangeEvent.reset)
            }
            NotificationCenter.default.post(customNotification: .changeSkinKey, object: self, userInfo: nil)
        }
        if Thread.current.isMainThread {
            changeSkin()
        } else {
            DispatchQueue.main.async {
                changeSkin()
            }
        }
    }
}
