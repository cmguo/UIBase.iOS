//
//  XHBTipViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation

public class XHBTipViewStyle {
    
    public var arrowSize: CGFloat = 6
    public var arrowOffset: CGFloat = 16
    public var paddingX: CGFloat = 16
    public var paddingY: CGFloat = 12
    public var iconSize: CGFloat = 16
    public var iconPadding: CGFloat = 8
    public var dismissDelay: Double = 3
    public var tipAppearance: XHBTipViewAppearance? = nil
    
    public init() {}
}

public class XHBTipViewAppearance: NSObject {
    
    public var frameRadius: CGFloat = 8
    public var frameColor = UIColor(rgb: 0x1D2126)
    public var frameAlpha: Float = 1
    public var textColor = UIColor.bluegrey_00
    public var textAppearance = TextAppearance(copy: .Body_Middle).textColor(.bluegrey_00)
    
    public override init() {}
    
    public init(copy: XHBTipViewAppearance) {
        frameRadius = copy.frameRadius
        frameAlpha = copy.frameAlpha
        frameColor = copy.frameColor
        textColor = copy.textColor
        textAppearance = copy.textAppearance
    }
    
    public func textAppearance(_ appearance: TextAppearance) -> Self {
        self.textAppearance = appearance
        return self
    }
    
    public func frameAlpha(_ alpha: Float) -> Self {
        self.frameAlpha = alpha
        return self
    }
    
    public func frameRadius(_ radius: CGFloat) -> Self {
        self.frameRadius = radius
        return self
    }
    
    public func frameColor(_ color: UIColor) -> Self {
        self.frameColor = color
        return self
    }
    
    public func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    public static let Toast = XHBTipViewAppearance().textAppearance(.Body_Small)
    public static let ToastQpaque = XHBTipViewAppearance(copy: Toast).frameAlpha(0.5)
    
    public static let ToolTip = XHBTipViewAppearance()
    public static let ToolTipQpaque = XHBTipViewAppearance(copy: ToolTip).frameAlpha(0.5)
    public static let ToolTipSpecial = XHBTipViewAppearance(copy: ToolTip).frameColor(.blue_600)
    public static let ToolTipSuccess = XHBTipViewAppearance(copy: ToolTip).frameColor(.green_600)
    public static let ToolTipWarning = XHBTipViewAppearance(copy: ToolTip).frameColor(.orange_600)
    public static let ToolTipError = XHBTipViewAppearance(copy: ToolTip).frameColor(.red_600)

    public static let Snack = XHBTipViewAppearance().frameColor(.bluegrey_05).textColor(.bluegrey_800).frameRadius(0)
    public static let SnackInfo = XHBTipViewAppearance(copy: .Snack).frameColor(.blue_100).textColor(.blue_600)
    public static let SnackError = XHBTipViewAppearance(copy: .Snack).frameColor(.red_100).textColor(.red_600)
}
