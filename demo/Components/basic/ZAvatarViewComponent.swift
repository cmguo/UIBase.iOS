//
//  ZAvatarComponent.swift
//  demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation

class ZAvatarViewComponent : NSObject, Component
{
    var group: ComponentGroup = .Basic
        
    var id: Int = 0
        
    var icon: URL? = nil
    
    var title: String = "头像"
    
    var author: String = "cmguo"
    
    var desc: String = "展示用户的头像。"
    
    lazy var controller: ComponentController = {
        return ZAvatarViewController()
    }()
}
