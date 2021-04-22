//
//  Icons.swift
//  Demo
//
//  Created by 郭春茂 on 2021/3/12.
//

import Foundation
import UIBase

class Icons {
    
    static let icons = ["<null>", "delete", "erase", "union", "info", "alert"]
    
    static let iconURLs = ["delete", "erase", "union", "info", "alert"].map() { icon in
        iconURL(icon)
    }

    static func iconURL(_ icon: String) -> URL? {
        return Bundle(for: Icons.self).url(forResource: icon, withExtension: "svg")
    }

    static func uibaseIconURL(_ icon: String) -> URL? {
        return Bundle(for: StateColor.self).url(forResource: icon, withExtension: "svg")
    }

}
