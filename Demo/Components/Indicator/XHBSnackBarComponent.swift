//
//  XHBNoticeBarComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/3/19.
//

import Foundation
import UIKit

class XHBSnackBarComponent : NSObject, Component
{
    var id: Int = 0
    
    var group: ComponentGroup = .Indicator

    var icon: Int = 0
    
    var title: String = "横幅提示"
    
    var author: String = "cmguo"
    
    var desc: String = "横幅提示：\n1.用于提示用户，告知相关信息(常用于告知用户网络异常) \n2.引导用户执行相关操作。"
    
    lazy var controller: ComponentController = {
        return XHBTipViewController(self)
    }()
}
