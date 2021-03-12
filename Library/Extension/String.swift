//
//  String.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation

extension String {
    
    func boundingSize(with: CGSize, font: UIFont, singleLine: Bool = false) -> CGSize {
        return self.boundingRect(with: with, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle()], context: nil).size
    }
}
