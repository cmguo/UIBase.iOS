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
    
    public enum ButtonType : Int, RawRepresentable, CaseIterable {
        case Primitive
        case Secondary
        case Tertiary
        case Danger
        case TextLink
        
        public var value : ZButtonAppearance {
            return ZButtonAppearance.TypeStyles[self]!
        }
    }
    
    public enum ButtonSize : Int, RawRepresentable, CaseIterable {
        case Large
        case Middle
        case Small
        case Thin
        
        public var value : ZButtonAppearance {
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
    public var minHeight: CGFloat? = nil
    public var cornerRadius: CGFloat? = nil
    public var paddingX: CGFloat? = nil // (left, rigth)
    public var paddingY: CGFloat? = nil // (top, bottom)
    public var textSize: CGFloat? = nil
    public var lineHeight: CGFloat? = nil
    public var iconSize: CGFloat? = nil
    public var iconColor: StateListColor? = nil
    public var iconPadding: CGFloat? = nil

    private var sealed = false;
    
    public init(buttonType: ButtonType? = nil,
                buttonSize: ButtonSize? = nil,
                textColor: StateListColor? = nil,
                backgroundColor: StateListColor? = nil,
                iconPosition: IconPosition? = nil,
                minHeight: CGFloat? = nil,
                cornerRadius: CGFloat? = nil,
                paddingX: CGFloat? = nil,
                paddingY: CGFloat? = nil,
                textSize: CGFloat? = nil,
                lineHeight: CGFloat? = nil,
                iconSize: CGFloat? = nil,
                iconColor: StateListColor? = nil,
                iconPadding: CGFloat? = nil) {
        self.buttonType = buttonType
        self.buttonSize = buttonSize
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.iconPosition = iconPosition
        self.minHeight = minHeight
        self.cornerRadius = cornerRadius
        self.paddingX = paddingX
        self.paddingY = paddingY
        self.textSize = textSize
        self.lineHeight = lineHeight
        self.iconSize = iconSize
        self.iconColor = iconColor
        self.iconPadding = iconPadding
    }
    
    public init(_ copy: ZButtonAppearance,
                textColor: StateListColor? = nil,
                backgroundColor: StateListColor? = nil,
                iconPosition: IconPosition? = nil,
                height: CGFloat? = nil,
                cornerRadius: CGFloat? = nil,
                paddingX: CGFloat? = nil,
                paddingY: CGFloat? = nil,
                textSize: CGFloat? = nil,
                lineHeight: CGFloat? = nil,
                iconSize: CGFloat? = nil,
                iconPadding: CGFloat? = nil) {
        self.buttonType = copy.buttonType
        self.buttonSize = copy.buttonSize
        self.textColor = textColor ?? copy.textColor
        self.backgroundColor = backgroundColor ?? copy.backgroundColor
        self.iconPosition = iconPosition ?? copy.iconPosition
        self.minHeight = height ?? copy.minHeight
        self.cornerRadius = cornerRadius ?? copy.cornerRadius
        self.paddingX = paddingX ?? copy.paddingX
        self.paddingY = paddingX ?? copy.paddingY
        self.textSize = textSize ?? copy.textSize
        self.lineHeight = lineHeight ?? copy.lineHeight
        self.iconSize = iconSize ?? copy.iconSize
        self.iconColor = iconColor ?? copy.iconColor
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
                iconColor = iconColor ?? type.iconColor
                backgroundColor = backgroundColor ?? type.backgroundColor
            }
            if let size = buttonSize?.value {
                minHeight = minHeight ?? size.minHeight
                cornerRadius = cornerRadius ?? size.cornerRadius
                textSize = textSize ?? size.textSize
                lineHeight = lineHeight ?? size.lineHeight
                paddingX = paddingX ?? size.paddingX
                paddingY = paddingY ?? size.paddingY
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

    internal struct Indexes : OptionSet {
        let rawValue: UInt
        static let none = Indexes([])
        static let all = Indexes(rawValue: 0xffffffff)
        static let textColor = Indexes(rawValue: 1)
        static let iconColor = Indexes(rawValue: 2)
        static let backgroundColor = Indexes(rawValue: 4)
        static let iconPosition = Indexes(rawValue: 8)
        static let minHeight = Indexes(rawValue: 16)
        static let cornerRadius = Indexes(rawValue: 32)
        static let paddingX = Indexes(rawValue: 64)
        static let paddingY = Indexes(rawValue: 128)
        static let textSize = Indexes(rawValue: 256)
        static let lineHeight = Indexes(rawValue: 512)
        static let iconSize = Indexes(rawValue: 1024)
        static let iconPadding = Indexes(rawValue: 2048)
    }
    
    func fill(_ appearance: ZButtonAppearance) -> Indexes {
        var change = Indexes.none
        if let buttonSize = buttonSize {
            change = change.union(buttonSize.value.fill(appearance))
        }
        if let buttonType = buttonType {
            change = change.union(buttonType.value.fill(appearance))
        }
        if let textColor = textColor, textColor !== appearance.textColor {
            appearance.textColor = textColor
            change = change.union(.textColor)
        }
        if let iconColor = iconColor, iconColor !== appearance.iconColor {
            appearance.iconColor = iconColor
            change = change.union(.iconColor)
        }
        if let backgroundColor = backgroundColor, backgroundColor !== appearance.backgroundColor {
            appearance.backgroundColor = backgroundColor
            change = change.union(.backgroundColor)
        }
        if let iconPosition = iconPosition, iconPosition != appearance.iconPosition {
            appearance.iconPosition = iconPosition
            change = change.union(.iconPosition)
        }
        if let minHeight = minHeight, minHeight != appearance.minHeight {
            appearance.minHeight = minHeight
            change = change.union(.minHeight)
        }
        if let cornerRadius = cornerRadius, cornerRadius != appearance.cornerRadius {
            appearance.cornerRadius = cornerRadius
            change = change.union(.cornerRadius)
        }
        if let paddingX = paddingX, paddingX != appearance.paddingX {
            appearance.paddingX = paddingX
            change = change.union(.paddingX)
        }
        if let paddingY = paddingY, paddingY != appearance.paddingY {
            appearance.paddingY = paddingY
            change = change.union(.paddingY)
        }
        if let textSize = textSize, textSize != appearance.textSize {
            appearance.textSize = textSize
            change = change.union(.textSize)
        }
        if let lineHeight = lineHeight, lineHeight != appearance.lineHeight {
            appearance.lineHeight = lineHeight
            change = change.union(.lineHeight)
        }
        if let iconSize = iconSize, iconSize != appearance.iconSize {
            appearance.iconSize = iconSize
            change = change.union(.iconSize )
        }
        if let iconPadding = iconPadding, iconPadding != appearance.iconPadding {
            appearance.iconPadding = iconPadding
            change = change.union(.iconPadding)
        }
        return change
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
        backgroundColor: .transparent_pressed_disabled,
        minHeight: 0,
        paddingX: 0
    ).seal()

    public static let large = ZButtonAppearance(
        minHeight: 44, cornerRadius: 24, paddingX: 32, paddingY: 6, textSize: 18, lineHeight: 28,  iconSize: 20, iconPadding: 5).seal()

    public static let middle = ZButtonAppearance(
        minHeight: 36, cornerRadius: 18, paddingX: 24, paddingY: 4, textSize: 16, lineHeight: 24, iconSize: 18, iconPadding: 4).seal()

    public static let small = ZButtonAppearance(
        minHeight: 24, cornerRadius: 12, paddingX: 12, paddingY: 2, textSize: 14, lineHeight: 20, iconSize: 16, iconPadding: 3).seal()

    public static let thin = ZButtonAppearance(
        minHeight: 20, cornerRadius: 10, paddingX: 12, paddingY: 2, textSize: 12, lineHeight: 18, iconSize: 14, iconPadding: 2).seal()
    
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
