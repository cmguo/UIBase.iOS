//
//  Icons.swift
//  Demo
//
//  Created by 郭春茂 on 2021/3/12.
//

import Foundation
import UIBase

public class Icons {
    
    static let icons = ["<null>", "delete", "erase", "union", "info", "alert"]
    
    static let iconURLs = ["delete", "erase", "union", "info", "alert"].map() { icon in
        iconURL(icon)
    }
    
    static let svgIcons: [String : URL] = {
        let _ = URL.svgIcons
        return SvgIconURLs.icons()
    }()
    
    static let pngIcons: [String : URL] = [:]
    
    static let dynamicIcons: [String : URL] = [:]
    
    static let rootURL: URL = {
        if let url = Bundle(for: Icons.self).url(forResource: "Demo", withExtension: "bundle") {
            return url
        } else {
            return Bundle.main.url(forResource: "Frameworks/Demo", withExtension: "bundle")!
        }
    }()

    public static func iconURL(_ icon: String) -> URL? {
        return rootURL.appendingPathComponent("Icons/\(icon).svg")
        //return bundle.url(forResource: icon, withExtension: "svg")
    }

    public static func pngURL(_ icon: String) -> URL? {
        return rootURL.appendingPathComponent("Images/\(icon).png")
        //return bundle.url(forResource: icon, withExtension: "png")
    }

    public static func jpgURL(_ icon: String) -> URL? {
        return rootURL.appendingPathComponent("Images/\(icon).jpg")
        //return bundle.url(forResource: icon, withExtension: "jpg")
    }

}
