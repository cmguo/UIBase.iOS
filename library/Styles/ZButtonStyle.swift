//
//  ZButtonStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/14.
//

import Foundation

public struct ZButtonTypeStyle {
    
    // colors
    public var textColor: StateListColor
    public var backgroundColor: StateListColor
    public var iconPosition: ZButton.IconPosition = .Left
    
    public static let primitive = ZButtonTypeStyle(
        textColor: .bluegrey_900_disabled,
        backgroundColor: .brand_500_pressed_disabled
    )

    public static let secondary = ZButtonTypeStyle(
        textColor: .blue_600_disabled,
        backgroundColor: .blue_100_pressed_disabled
    )

    public static let tertiary = ZButtonTypeStyle(
        textColor: .bluegrey_800_disabled,
        backgroundColor: .bluegrey_100_pressed_disabled
    )

    public static let danger = ZButtonTypeStyle(
        textColor: .red_600_disabled,
        backgroundColor: .red_100_pressed_disabled
    )

    public static let textLink = ZButtonTypeStyle(
        textColor: .blue_600_disabled,
        backgroundColor: .transparent_pressed_disabled
    )
}

public struct ZButtonSizeStyle {
    
    public var height: CGFloat
    public var radius: CGFloat = 0
    public var padding: CGFloat = 0 // (left, rigth)
    public var textSize: CGFloat
    public var iconSize: CGFloat
    public var iconPadding: CGFloat

    public static let large = ZButtonSizeStyle(
        height: 44, radius: 24, padding: 24, textSize: 18, iconSize: 20, iconPadding: 5)

    public static let middle = ZButtonSizeStyle(
        height: 36, radius: 18, padding: 16, textSize: 16, iconSize: 18, iconPadding: 4)

    public static let small = ZButtonSizeStyle(
        height: 24, radius: 12, padding: 12, textSize: 14, iconSize: 16, iconPadding: 3)

    public static let thin = ZButtonSizeStyle(
        height: 24, radius: 0, padding: 0, textSize: 14, iconSize: 16, iconPadding: 3)
}

public class ZButtonAppearance {
    
    public var typeStyle: ZButtonTypeStyle
    public var sizeStyle: ZButtonSizeStyle
    
    public init() {
        typeStyle = .primitive
        sizeStyle = .large
    }
    
    public init(type: ZButtonTypeStyle, size: ZButtonSizeStyle) {
        typeStyle = type
        sizeStyle = size
    }
}

public class ZButtonStyle {
    
    public var text: String? = nil
    public var icon: URL? = nil
    public var loadingText: String? = nil
    public var loadingIcon: URL? = nil
    public var buttonType: ZButton.ButtonType? = nil
    public var buttonSize: ZButton.ButtonSize? = nil
    public var appearance: ZButtonAppearance? = nil
    
    public init() {
    }
        
    public static let defaultStyle = ZButtonStyle()

}

