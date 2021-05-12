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
        "TipViewToast": ZTipViewAppearance.Toast,
        "TipViewToast_Qpaque": ZTipViewAppearance.ToastQpaque,
        "TipViewToolTip": ZTipViewAppearance.ToolTip,
        "TipViewToolTip_Qpaque": ZTipViewAppearance.ToolTipQpaque,
        "TipViewToolTip_Special": ZTipViewAppearance.ToolTipSpecial,
        "TipViewToolTip_Success": ZTipViewAppearance.ToolTipSuccess,
        "TipViewToolTip_Warning": ZTipViewAppearance.ToolTipWarning,
        "TipViewToolTip_Error": ZTipViewAppearance.ToolTipError,
        "TipViewSnack": ZTipViewAppearance.Snack,
        "TipViewSnack_Info": ZTipViewAppearance.SnackInfo,
        "TipViewSnack_Error": ZTipViewAppearance.SnackError,
    ]
    
    init(_ cls: ViewStyles.Type, _ field: String, _ params: [String]) {
        super.init(cls, field, Self.Contents, params)
    }
    
}
