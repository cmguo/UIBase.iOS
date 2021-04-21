//
//  XHBButtonStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/14.
//

import Foundation

public struct XHBButtonTypeStyle {
    
    // colors
    var textColor: StateListColor
    var backgroundColor: StateListColor
    var iconPosition: XHBButton.IconPosition = .Left
    
    static let primitiveAppearance = XHBButtonTypeStyle(
        textColor: .bluegrey_900_disabled,
        backgroundColor: .brand_500_pressed_disabled
    )

    static let secondaryAppearance = XHBButtonTypeStyle(
        textColor: .blue_600_disabled,
        backgroundColor: .blue_100_pressed_disabled
    )

    static let tertiaryAppearance = XHBButtonTypeStyle(
        textColor: .bluegrey_800_disabled,
        backgroundColor: .bluegrey_100_pressed_disabled
    )

    static let dangerAppearance = XHBButtonTypeStyle(
        textColor: .red_600_disabled,
        backgroundColor: .red_100_pressed_disabled
    )

    static let textLinkAppearance = XHBButtonTypeStyle(
        textColor: .blue_600_disabled,
        backgroundColor: .transparent_pressed_disabled
    )
}

public struct XHBButtonSizeStyle {
    
    var height: CGFloat
    var radius: CGFloat = 0
    var padding: CGFloat = 0 // (left, rigth)
    var textSize: CGFloat
    var iconSize: CGFloat
    var iconPadding: CGFloat

    static let largeAppearance = XHBButtonSizeStyle(
        height: 44, radius: 24, padding: 24, textSize: 18, iconSize: 20, iconPadding: 5)

    static let middleAppearance = XHBButtonSizeStyle(
        height: 36, radius: 18, padding: 16, textSize: 16, iconSize: 18, iconPadding: 4)

    static let smallAppearance = XHBButtonSizeStyle(
        height: 24, radius: 12, padding: 12, textSize: 14, iconSize: 16, iconPadding: 3)

    static let thinAppearance = XHBButtonSizeStyle(
        height: 24, radius: 0, padding: 0, textSize: 14, iconSize: 16, iconPadding: 3)
}

public struct XHBButtonAppearance {
    let typeStyle: XHBButtonTypeStyle
    let sizeStyle: XHBButtonSizeStyle
}

public class XHBButtonStyle {
    
    public var text: String? = nil
    public var icon: URL? = nil
    public var loadingText: String? = nil
    public var loadingIcon: URL? = nil
    public var buttonType: XHBButton.ButtonType? = nil
    public var buttonSize: XHBButton.ButtonSize? = nil
    public var appearance: XHBButtonAppearance? = nil
    
    public init() {
    }
        
    public static let defaultStyle = XHBButtonStyle()

}
