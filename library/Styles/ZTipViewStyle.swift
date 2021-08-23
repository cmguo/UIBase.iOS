//
//  ZTipViewStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation

public class ZTipViewStyle {
    
    public var arrowSize: CGFloat = 6
    public var arrowOffset: CGFloat = 16
    public var paddingX: CGFloat = 16
    public var paddingY: CGFloat = 12
    public var iconSize: CGFloat = 16
    public var iconPadding: CGFloat = 8
    public var dismissDelay: Double = 3
    public var tipAppearance: ZTipViewAppearance? = nil
    
    public init() {}
}

public class ZTipViewAppearance: NSObject {
    
    public var frameRadius: CGFloat = 8
    public var frameColor = UIColor.bluegrey_900
    public var frameAlpha: Float = 1
    public var textColor = UIColor.bluegrey_00
    public var textAppearance = TextAppearance(copy: .body_middle).textColor(.bluegrey_00)
    
    public override init() {}
    
    public init(copy: ZTipViewAppearance) {
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
    
    public static let toast = ZTipViewAppearance().textAppearance(.body_small)
    public static let toastQpaque = ZTipViewAppearance(copy: toast).frameAlpha(0.5)
    
    public static let toolTip = ZTipViewAppearance()
    public static let toolTipQpaque = ZTipViewAppearance(copy: toolTip).frameAlpha(0.5)
    public static let toolTipSpecial = ZTipViewAppearance(copy: toolTip).frameColor(.blue_600)
    public static let toolTipSuccess = ZTipViewAppearance(copy: toolTip).frameColor(.green_600)
    public static let toolTipWarning = ZTipViewAppearance(copy: toolTip).frameColor(.orange_600)
    public static let toolTipError = ZTipViewAppearance(copy: toolTip).frameColor(.red_600)

    public static let snack = ZTipViewAppearance().frameColor(.bluegrey_05).textColor(.bluegrey_800).frameRadius(0)
    public static let snackInfo = ZTipViewAppearance(copy: .snack).frameColor(.blue_100).textColor(.blue_600)
    public static let snackError = ZTipViewAppearance(copy: .snack).frameColor(.red_100).textColor(.red_600)
}
