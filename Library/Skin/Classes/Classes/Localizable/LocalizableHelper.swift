//
//  LocalizableHelper.swift
//  blackboard
//
//  Created by roni on 2018/11/29.
//  Copyright © 2018 xkb. All rights reserved.
//

import Foundation

public var languageBundle: Bundle? = getLanguageBundle()

// MARK: - 国际化直接调用此方法
public func localizedString(_ key: String) -> String {
    return languageBundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
}
// MARK: - 国际化含参调用
public func localizedString(_ key: String, _ arguments: CVarArg...) -> String {
    return String(format: localizedString(key), arguments: arguments)
}

public class LocalizableHelper: NSObject {
    @objc class public func localizedString(_ key: String) -> String {
        return languageBundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}

public func getLanguageBundle(language: String? = "zh-Hans") -> Bundle? {
    var currentLanuage = "zh-Hans"
    if let la = language {
        currentLanuage = la
    } else if let firstLanguage = getFirstLanuage() {
        currentLanuage = firstLanguage
    }
    let bundle = Bundle.main
    guard let path = bundle.path(forResource: currentLanuage, ofType: "lproj") else {
        return nil
    }
    return Bundle(path: path)
}

public func setLanguageBundle() {
    if let language = getFirstLanuage() {
        languageBundle = getLanguageBundle(language: language)
    }
}

public func getFirstLanuage() -> String? {
    let key = "AppleLanguages"
    let languages = UserDefaults.standard.object(forKey: key) as? [String]
    return languages?.first
}

public func setFirstLanguage(language: String = "zh-Hans") {
    let key = "AppleLanguages"
    UserDefaults.standard.set(language, forKey: key)
    UserDefaults.standard.synchronize()

    setLanguageBundle()
}
