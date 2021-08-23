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
        "TipViewToast": ZTipViewAppearance.toast,
        "TipViewToast_Qpaque": ZTipViewAppearance.toastQpaque,
        "TipViewToolTip": ZTipViewAppearance.toolTip,
        "TipViewToolTip_Qpaque": ZTipViewAppearance.toolTipQpaque,
        "TipViewToolTip_Special": ZTipViewAppearance.toolTipSpecial,
        "TipViewToolTip_Success": ZTipViewAppearance.toolTipSuccess,
        "TipViewToolTip_Warning": ZTipViewAppearance.toolTipWarning,
        "TipViewToolTip_Error": ZTipViewAppearance.toolTipError,
        "TipViewSnack": ZTipViewAppearance.snack,
        "TipViewSnack_Info": ZTipViewAppearance.snackInfo,
        "TipViewSnack_Error": ZTipViewAppearance.snackError,
    ]
    
    init(_ cls: ViewStyles.Type, _ field: String, _ params: [String]) {
        super.init(cls, field, Self.Contents, params)
    }
    
}
