//
//  XHBSwitchButton.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/9.
//

import Foundation

public class XHBSwitchButton : UISwitch
{
    private static let trackColor = StateListColor([
        StateColor(ThemeColor.shared.brand_500, StateColor.STATES_CHECKED),
        StateColor(ThemeColor.shared.bluegrey_300, StateColor.STATES_NORMAL)
    ])
        
    private static let tumbColor = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_00, StateColor.STATES_NORMAL)
    ])
        
    public init() {
        super.init(frame: CGRect.zero)
        
        self.tintColor = XHBSwitchButton.trackColor.color(for: StateColor.STATES_NORMAL)
        self.onTintColor = XHBSwitchButton.trackColor.color(for: StateColor.STATES_CHECKED)
        self.thumbTintColor = XHBSwitchButton.tumbColor.color(for: StateColor.STATES_NORMAL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
