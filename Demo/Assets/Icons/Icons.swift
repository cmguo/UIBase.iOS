//
//  Icons.swift
//  Demo
//
//  Created by 郭春茂 on 2021/3/12.
//

import Foundation

class Icons {
    
    static let icons = ["<null>", "delete", "erase", "union", "info", "alert"].map { (i) in
        ViewStyles.makeValue(i, i)
    }
    
    static func iconURL(_ icon: String) -> URL? {
        return Bundle(for: Icons.self).url(forResource: icon, withExtension: "svg")
    }

}
