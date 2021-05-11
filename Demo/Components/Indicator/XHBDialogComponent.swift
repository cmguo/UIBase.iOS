//
//  XHBDialogComponent.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/27.
//

import Foundation

class XHBDialogComponent : NSObject, Component
{
    var group: ComponentGroup = .Indicator

    var id: Int = 0
        
    var icon: Int = 0
    
    var title: String = "对话框"
    
    var author: String = "cmguo"
    
    var desc: String = "1.需要用户做出简单的选择且选项较少时（如进行一些重要操作时的简单确认弹窗）\n2.前置或后置的提示性内容，又不希望跳转页面时（如在开始录音时弹窗提示用户注意事项）\n3.当需要展示的信息不由用户主动触发，不在用户正常操作流程习惯中时，或者不符合用户的使用预期时一般使用弹窗（如提示用户开启通知权限）\n4.非主动触发的引导性信息（如常规的运营弹窗等）。"
    
    lazy var controller: ComponentController = {
        return XHBDialogController()
    }()
}
