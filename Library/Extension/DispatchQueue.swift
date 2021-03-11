//
//  DispatchQueue.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation

extension DispatchQueue {
    
    func delay(_ duration: Double, execute: @escaping () -> Void) {
        asyncAfter(deadline: DispatchTime.now() + duration, execute: execute)
    }
}
