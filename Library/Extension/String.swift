//
//  String.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation

extension String {
    
    func boundingSize(font: UIFont, singleLine: Bool = false) -> CGSize {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return boundingSize(with: size, font: font, singleLine: singleLine)
    }
    
    func boundingSize(with size: CGSize, font: UIFont, singleLine: Bool = false) -> CGSize {
        return self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle()], context: nil).size
    }
}
