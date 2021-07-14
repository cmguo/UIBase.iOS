//
//  ZButtonStyle.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/14.
//

import Foundation

public class ZButtonStyle : ZButtonAppearance {
    
    public var text: String? = nil
    public var icon: URL? = nil
    public var loadingText: String? = nil
    public var loadingIcon: URL? = nil
    public var appearance: ZButtonAppearance? = nil
    
    public init() {
        super.init()
    }
    
    public static let `default` = ZButtonStyle()

}

public class ZButtonAppearance {
    
    public enum ButtonType : CaseIterable {
        case Primitive
        case Secondary
        case Tertiary
        case Danger
        case TextLink
        
        var value : ZButtonAppearance {
            return ZButtonAppearance.TypeStyles[self]!
        }
    }
    
    public enum ButtonSize : Int, RawRepresentable, CaseIterable {
        case Large
        case Middle
        case Small
        case Thin
        
        var value : ZButtonAppearance {
            return ZButtonAppearance.SizeStyles[self]!
        }
    }
    
    public enum ButtonWidth : Int, RawRepresentable, CaseIterable {
        case WrapContent
        case MatchParent
    }
    
    public enum IconPosition : Int, RawRepresentable, CaseIterable {
        case Left
        case Top
        case Right
        case Bottom
    }

    public var buttonType: ButtonType? = nil
    public var buttonSize: ButtonSize? = nil
    // type
    public var textColor: StateListColor? = nil
    public var backgroundColor: StateListColor? = nil
    // other
    public var iconPosition: IconPosition? = nil
    // size
    public var height: CGFloat? = nil
    public var radius: CGFloat? = nil
    public var padding: CGFloat? = nil // (left, rigth)
    public var textSize: CGFloat? = nil
    public var iconSize: CGFloat? = nil
    public var iconPadding: CGFloat? = nil
    
    private var sealed = false;
    
    public init(buttonType: ButtonType? = nil,
                buttonSize: ButtonSize? = nil,
                textColor: StateListColor? = nil,
                backgroundColor: StateListColor? = nil,
                iconPosition: IconPosition? = nil,
                height: CGFloat? = nil,
                radius: CGFloat? = nil,
                padding: CGFloat? = nil,
                textSize: CGFloat? = nil,
                iconSize: CGFloat? = nil,
                iconPadding: CGFloat? = nil) {
        self.buttonType = buttonType
        self.buttonSize = buttonSize
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.iconPosition = iconPosition
        self.height = height
        self.radius = radius
        self.padding = padding
        self.textSize = textSize
        self.iconSize = iconSize
        self.iconPadding = iconPadding
    }
    
    public init(_ copy: ZButtonAppearance,
                textColor: StateListColor? = nil,
                backgroundColor: StateListColor? = nil,
                iconPosition: IconPosition? = nil,
                height: CGFloat? = nil,
                radius: CGFloat? = nil,
                padding: CGFloat? = nil,
                textSize: CGFloat? = nil,
                iconSize: CGFloat? = nil,
                iconPadding: CGFloat? = nil) {
        self.buttonType = copy.buttonType
        self.buttonSize = copy.buttonSize
        self.textColor = textColor ?? copy.textColor
        self.backgroundColor = backgroundColor ?? copy.backgroundColor
        self.iconPosition = iconPosition ?? copy.iconPosition
        self.height = height ?? copy.height
        self.radius = radius ?? copy.radius
        self.padding = padding ?? copy.padding
        self.textSize = textSize ?? copy.textSize
        self.iconSize = iconSize ?? copy.iconSize
        self.iconPadding = iconPadding ?? copy.iconPadding
    }
    
    public func normalized() -> ZButtonAppearance {
        if (sealed) {
            let appearance = ZButtonAppearance()
            _ = fill(appearance)
            return appearance
        } else {
            if let type = buttonType?.value {
                textColor = textColor ?? type.textColor
                backgroundColor = backgroundColor ?? type.backgroundColor
            }
            if let size = buttonSize?.value {
                height = height ?? size.height
                radius = radius ?? size.radius
                textSize = textSize ?? size.textSize
                padding = padding ?? size.padding
                iconSize = iconSize ?? size.iconSize
                iconPadding = iconPadding ?? size.iconPadding
            }
            return self
        }
    }
    
    func seal() -> ZButtonAppearance {
        self.sealed = true
        return self
    }

    func fill(_ appearance: ZButtonAppearance) -> Int {
        var change = 0
        if let buttonType = buttonType {
            change |= buttonType.value.fill(appearance)
        }
        if let buttonSize = buttonSize {
            change |= buttonSize.value.fill(appearance)
        }
        if let textColor = textColor, textColor !== appearance.textColor {
            appearance.textColor = textColor
            change |= 1
        }
        if let backgroundColor = backgroundColor, backgroundColor !== appearance.backgroundColor {
            appearance.backgroundColor = backgroundColor
            change |= 2
        }
        if let iconPosition = iconPosition, iconPosition != appearance.iconPosition {
            appearance.iconPosition = iconPosition
            change |= 4
        }
        if let height = height, height != appearance.height {
            appearance.height = height
            change |= 8
        }
        if let radius = radius, radius != appearance.radius {
            appearance.radius = radius
            change |= 16
        }
        if let padding = padding, padding != appearance.padding {
            appearance.padding = padding
            change |= 32
        }
        if let textSize = textSize, textSize != appearance.textSize {
            appearance.textSize = textSize
            change |= 64
        }
        if let iconSize = iconSize, iconSize != appearance.iconSize {
            appearance.iconSize = iconSize
            change |= 128
        }
        if let iconPadding = iconPadding, iconPadding != appearance.iconPadding {
            appearance.iconPadding = iconPadding
            change |= 256
        }
        return change
    }
    
    class func textColorChanged(_ c: Int) -> Bool {
        return (c & 1) != 0
    }
    
    class func backgroundColorChanged(_ c: Int) -> Bool {
        return (c & 2) != 0
    }
    
    class func radiusChanged(_ c: Int) -> Bool {
        return (c & 16) != 0
    }
    
    class func paddingChanged(_ c: Int) -> Bool {
        return (c & 32) != 0
    }
    
    class func textSizeChanged(_ c: Int) -> Bool {
        return (c & 64) != 0
    }
    
    class func iconSizeChanged(_ c: Int) -> Bool {
        return (c & 128) != 0
    }
    
    class func iconPaddingChanged(_ c: Int) -> Bool {
        return (c & 256) != 0
    }
    
    class func sizeChanged(_ c: Int) -> Bool {
        return (c & 480) != 0
    }
}


extension ZButtonAppearance {
    
    private static let TypeStyles: [ButtonType: ZButtonAppearance] = [
        .Primitive: .primitive,
        .Secondary: .secondary,
        .Tertiary: .tertiary,
        .Danger: .danger,
        .TextLink: .textLink
    ]
    
    private static let SizeStyles: [ButtonSize: ZButtonAppearance] = [
        .Large: .large,
        .Middle: .middle,
        .Small: .small,
        .Thin: .thin
    ]

    public static let primitive = ZButtonAppearance(
        textColor: .static_bluegrey_900_disabled,
        backgroundColor: .brand_500_pressed_disabled
    ).seal()

    public static let secondary = ZButtonAppearance(
        textColor: .blue_600_disabled,
        backgroundColor: .blue_100_pressed_disabled
    ).seal()

    public static let tertiary = ZButtonAppearance(
        textColor: .bluegrey_800_disabled,
        backgroundColor: .bluegrey_100_pressed_disabled
    ).seal()

    public static let danger = ZButtonAppearance(
        textColor: .red_600_disabled,
        backgroundColor: .red_100_pressed_disabled
    ).seal()

    public static let textLink = ZButtonAppearance(
        textColor: .blue_600_disabled,
        backgroundColor: .transparent_pressed_disabled
    ).seal()

    public static let large = ZButtonAppearance(
        height: 44, radius: 24, padding: 24, textSize: 18, iconSize: 20, iconPadding: 5).seal()

    public static let middle = ZButtonAppearance(
        height: 36, radius: 18, padding: 16, textSize: 16, iconSize: 18, iconPadding: 4).seal()

    public static let small = ZButtonAppearance(
        height: 24, radius: 12, padding: 12, textSize: 14, iconSize: 16, iconPadding: 3).seal()

    public static let thin = ZButtonAppearance(
        height: 24, radius: 0, padding: 0, textSize: 14, iconSize: 16, iconPadding: 3).seal()
    
    public static let primitiveLarge = ZButtonAppearance(buttonType: .Primitive, buttonSize: .Large).seal()
    
    public static let primitiveMiddle = ZButtonAppearance(buttonType: .Primitive, buttonSize: .Middle).seal()
    
    public static let primitiveSmall = ZButtonAppearance(buttonType: .Primitive, buttonSize: .Small).seal()
    
    public static let primitiveThin = ZButtonAppearance(buttonType: .Primitive, buttonSize: .Thin).seal()
    
    public static let secondaryLarge = ZButtonAppearance(buttonType: .Secondary, buttonSize: .Large).seal()
    
    public static let secondaryMiddle = ZButtonAppearance(buttonType: .Secondary, buttonSize: .Middle).seal()
    
    public static let secondarySmall = ZButtonAppearance(buttonType: .Secondary, buttonSize: .Small).seal()
    
    public static let secondaryThin = ZButtonAppearance(buttonType: .Secondary, buttonSize: .Thin).seal()
    
    public static let tertiaryLarge = ZButtonAppearance(buttonType: .Tertiary, buttonSize: .Large).seal()
    
    public static let tertiaryMiddle = ZButtonAppearance(buttonType: .Tertiary, buttonSize: .Middle).seal()
    
    public static let tertiarySmall = ZButtonAppearance(buttonType: .Tertiary, buttonSize: .Small).seal()
    
    public static let tertiaryThin = ZButtonAppearance(buttonType: .Tertiary, buttonSize: .Thin).seal()
    
    public static let textLinkLarge = ZButtonAppearance(buttonType: .TextLink, buttonSize: .Large).seal()
    
    public static let textLinkMiddle = ZButtonAppearance(buttonType: .TextLink, buttonSize: .Middle).seal()
    
    public static let textLinkSmall = ZButtonAppearance(buttonType: .TextLink, buttonSize: .Small).seal()
    
    public static let textLinkThin = ZButtonAppearance(buttonType: .TextLink, buttonSize: .Thin).seal()

}
