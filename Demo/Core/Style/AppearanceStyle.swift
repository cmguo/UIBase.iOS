//
//  AppearanceStyle.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/28.
//

import Foundation
import UIBase

class AppearanceStyle: ResourceStyle {
    
    static let Contents: [String: Any] = [
        "TipViewToast": XHBTipViewAppearance.Toast,
        "TipViewToast_Qpaque": XHBTipViewAppearance.ToastQpaque,
        "TipViewToolTip": XHBTipViewAppearance.ToolTip,
        "TipViewToolTip_Qpaque": XHBTipViewAppearance.ToolTipQpaque,
        "TipViewToolTip_Special": XHBTipViewAppearance.ToolTipSpecial,
        "TipViewToolTip_Success": XHBTipViewAppearance.ToolTipSuccess,
        "TipViewToolTip_Warning": XHBTipViewAppearance.ToolTipWarning,
        "TipViewToolTip_Error": XHBTipViewAppearance.ToolTipError,
        "TipViewSnack": XHBTipViewAppearance.Snack,
        "TipViewSnack_Info": XHBTipViewAppearance.SnackInfo,
        "TipViewSnack_Error": XHBTipViewAppearance.SnackError,
    ]
    
    init(_ cls: ViewStyles.Type, _ field: String, _ params: [String]) {
        super.init(cls, field, Self.Contents, params)
    }
    
}
