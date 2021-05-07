//
//  XHBTabBarStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation

public class XHBTabBarStyle : UIViewStyle {
    
    public var titleStyle = XHBTabBarTitleStyle()

    public override init() {
        super.init()
    }
    
}


/* Title style */

public class XHBTabBarTitleStyle: UIViewStyle {
    
    public var gravity = UIControl.ContentHorizontalAlignment.fill
    public var textAppearence = TextAppearance(copy: .Body_Middle).textColors(.bluegrey_800_selected)
    public var textSizeSelected: CGFloat = 18

    public override init() {
        super.init()
    }
    
    public static let Frame: XHBTabBarTitleStyle = {
        let t = XHBTabBarTitleStyle()
        t.backgroundColor = .bluegrey_05
        return t
    }()
    
    public static let Flat: XHBTabBarTitleStyle = {
        let t = XHBTabBarTitleStyle()
        t.gravity = .center
        return t
    }()
    
    public static let Round: XHBTabBarTitleStyle = {
        let t = XHBTabBarTitleStyle()
        t.backgroundColor = .bluegrey_05
        t.cornerRadius = 8
        return t
    }()
}


/* Indicator style */

public class XHBTabBarIndicatorStyle : UIViewStyle {
    
    public enum WidthMode {
        case MatchCell
        case MatchContent
        case Exactly
    }
    
    public var widthMode: WidthMode = .Exactly
    // width when WidthMode == Exactly
    // padding when WidthMode == MatchCell or MatchContent
    public var width: CGFloat = 24
    public var height: CGFloat = 3
    public var radius: CGFloat = 1.5
    public var color: UIColor = .brand_500
    
    public override init() {
        super.init()
    }
    
}

public class XHBTabBarLineIndicatorStyle : XHBTabBarIndicatorStyle {
        
    public var offsetY: CGFloat = 0
    public var longLineHeight: CGFloat = 0
    public var longLineColor: UIColor = .bluegrey_100

    public override init() {
        super.init()
    }
    
}


public class XHBTabBarRoundIndicatorStyle : XHBTabBarIndicatorStyle {
    
    public var padding: CGFloat = 1
    public var shadowRadius: CGFloat = 1
    public var shadowColor: UIColor = .gray
    public var splitterWidth: CGFloat = 1
    public var splitterColor: UIColor = .bluegrey_300

    public override init() {
        super.init()
        widthMode = .MatchCell
        width = -8  // sync width Navigator's padding
        height = 0
        radius = 8
        color = .bluegrey_00
    }
    
}
