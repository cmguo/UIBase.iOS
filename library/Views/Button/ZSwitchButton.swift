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
        StateColor(.brand_500, .STATES_CHECKED),
        StateColor(.bluegrey_300, .STATES_NORMAL)
    ])
        
    private static let tumbColor = StateListColor([
        StateColor(.bluegrey_00, .STATES_NORMAL)
    ])

    public init() {
        super.init(frame: CGRect.zero)
        
        self.tintColor = XHBSwitchButton.trackColor.color(for: .STATES_NORMAL)
        self.onTintColor = XHBSwitchButton.trackColor.color(for: .STATES_CHECKED)
        self.thumbTintColor = XHBSwitchButton.tumbColor.color(for: .STATES_NORMAL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
