//
//  UIImage.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation

public extension UIImage {
    
    static let transparent = UIImage.from(color: .clear)
    
    class func from(color: UIColor, ofSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return colorImage
        }
        return nil
    }
        
    convenience init?(withUrl url: URL?) {
        guard let url = url else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
}
