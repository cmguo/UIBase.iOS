//
//  UIImage.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation

public extension UIImage {
    
    static let transparent = UIImage.from(color: .clear)
    
    class func from(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return colorImage
        }
        return nil
    }
    
    convenience init?(withUrl url: URL) {
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
}
