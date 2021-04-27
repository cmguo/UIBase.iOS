//
//  ZSwitchButton.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/9.
//

import Foundation

public class ZSwitchButton : UISwitch
{
    private static let trackColor = StateListColor.bluegrey_300_checked
        
    private static let tumbColor = StateListColor(singleColor: .bluegrey_00)

    public init() {
        super.init(frame: CGRect.zero)
        
        self.tintColor = ZSwitchButton.trackColor.color(for: .STATES_NORMAL)
        self.onTintColor = ZSwitchButton.trackColor.color(for: .STATES_CHECKED)
        self.thumbTintColor = ZSwitchButton.tumbColor.color(for: .STATES_NORMAL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
