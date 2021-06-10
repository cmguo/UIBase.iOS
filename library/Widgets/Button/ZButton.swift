//
//  ZButton.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/1.
//

import Foundation

@IBDesignable
public class ZButton : UIButton
{
    public enum ButtonType : CaseIterable {
        case Primitive
        case Secondary
        case Tertiary
        case Danger
        case TextLink
    }
    
    public enum ButtonSize : Int, RawRepresentable, CaseIterable {
        case Large
        case Middle
        case Small
        case Thin
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
    
    // MARK: - Public variables
    
    public var buttonType2: ButtonType {
        didSet {
            if oldValue == buttonType2 {
                return
            }
            self.syncAppearance(true, false)
        }
    }
    public var buttonSize: ButtonSize {
        didSet {
            if oldValue == buttonSize {
                return
            }
            self.syncAppearance(false, true)
        }
    }
    
    public var iconPosition = IconPosition.Left {
        didSet {
            if oldValue == iconPosition {
                return
            }
            self.syncSize()
            self.setNeedsLayout()
        }
    }
    
    public var buttonAppearance: ZButtonAppearance? = nil {
        didSet {
            self.syncAppearance()
        }
    }
    
    public var text: String? = nil {
        didSet {
            //self.titleLabel?.text = text
            self.setTitle(text)
            syncSize()
        }
    }
    
    public var icon: URL? = nil {
        didSet {
            if icon?.pathExtension == "svg" {
                self.imageView?.bounds.size = imageSize
                self.setImage(UIImage.transparent)
                self.imageView?.setImage(svgURL: icon) {
                    self.syncStates()
                    self.postHandleIcon()
                }
            } else {
                self.imageView?.setImage(svgURL: nil)
                self.setImage(UIImage(withUrl: icon))
            }
            self.syncSize()
        }
    }
    
    public var content: Any? = nil {
        didSet {
            self.syncContent()
        }
    }
    
    @objc public class ButtonId: NSObject {
        private let desc: String
        public init(desc: String) {
            self.desc = desc
        }
        public override var description: String {
            return desc
        }
        public static let Unknown = ButtonId(desc: "Unknown")
        public static let Left = ButtonId(desc: "Left")
        public static let Left2 = ButtonId(desc: "Left2")
        public static let Top = ButtonId(desc: "Top")
        public static let Right = ButtonId(desc: "Right")
        public static let Right2 = ButtonId(desc: "Right2")
        public static let Bottom = ButtonId(desc: "Bottom")
    }
    
    public var id: ButtonId? = nil
    
    /**
     Current loading state.
     */
    public var isLoading: Bool = false {
        didSet {
            if oldValue == isLoading {
                return
            }
            if isLoading {
                showLoader()
            } else {
                hideLoader()
            }
        }
    }

    public override var isEnabled: Bool {
        didSet {
            if oldValue == isEnabled {
                return
            }
            self.syncStates()
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            if oldValue == isSelected {
                return
            }
             self.syncStates()
        }
    }
    
    /**
     The loading indicator used with the button.
     */
    open var indicator: UIView & IndicatorProtocol = MaterialLoadingIndicator()

    // Private properties
    var typeStyles: ZButtonTypeStyle
    var sizeStyles: ZButtonSizeStyle
    
    open func postHandleIcon() {
    }
    
    // Private properties
    private var minSize = CGSize.zero // not include paddding
    
    private var loaderWorkItem: DispatchWorkItem?

    /**
     Convenience init of theme button with required information
     
     - Parameter type:      the icon of the button, it is be nil by default.
     - Parameter sizeMode:  the size mode of the button.
     - Parameter widthMode: the width mode of the button.
     - Parameter icon:      the icon of the button, it is be nil by default.
     - Parameter text:      the title of the button.
     */
    public init(style: ZButtonStyle = .init()) {
        buttonAppearance = style.appearance
        buttonType2 = style.buttonType ?? .Primitive
        buttonSize = style.buttonSize ?? .Large
        typeStyles = style.appearance?.typeStyle ?? ZButton.TypeStyles[style.buttonType ?? .Primitive]!
        sizeStyles = style.appearance?.sizeStyle ?? ZButton.SizeStyles[style.buttonSize ?? .Large]!
        iconPosition = typeStyles.iconPosition
        
        super.init(frame: CGRect.zero)
        //translatesAutoresizingMaskIntoConstraints = false
        
        self.contentMode = .redraw
        self.syncAppearance()

        // Set the title of the button
        if let text = style.text {
            self.text = text
            self.setTitle(text)
        }
        // Set button contents
        // Set the icon of the button
        if let icon = style.icon {
            self.icon = icon
            self.setImage(UIImage.transparent)
            self.imageView?.setImage(withURL: icon) {
                self.syncStates()
                self.imageView?.frame = self.imageRect(forContentRect: self.bounds)
            }
        }
        self.syncSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let contentRect = bounds.centerPart(ofSize: minSize);
        switch iconPosition {
        case .Left:
            return contentRect.leftCenterPart(ofSize: imageSize)
        case .Top:
            return contentRect.topCenterPart(ofSize: imageSize)
        case .Right:
            return contentRect.rightCenterPart(ofSize: imageSize)
        case .Bottom:
            return contentRect.bottomCenterPart(ofSize: imageSize)
        }
    }
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let contentRect = bounds.centerPart(ofSize: minSize);
        switch iconPosition {
        case .Left:
            return contentRect.rightCenterPart(ofSize: titleSize)
        case .Top:
            return contentRect.bottomCenterPart(ofSize: titleSize)
        case .Right:
            return contentRect.leftCenterPart(ofSize: titleSize)
        case .Bottom:
            return contentRect.topCenterPart(ofSize: titleSize)
        }
    }
    
    // layoutSubviews
    open override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        syncStates()
        backgroundColors = typeStyles.backgroundColor
    }
    
    /* private */
    
    fileprivate func applyStyle(_ style: ZButtonStyle) {
        buttonType2 = style.buttonType ?? .Primitive
        buttonSize = style.buttonSize ?? .Large
        buttonAppearance = style.appearance
        self.text = style.text
        self.icon = style.icon
    }
    
    private static let TypeStyles: [ButtonType: ZButtonTypeStyle] = [
        .Primitive: .primitive,
        .Secondary: .secondary,
        .Tertiary: .tertiary,
        .Danger: .danger,
        .TextLink: .textLink
    ]
    
    private static let SizeStyles: [ButtonSize: ZButtonSizeStyle] = [
        .Large: .large,
        .Middle: .middle,
        .Small: .small,
        .Thin: .thin
    ]
    
    private var imageSize = CGSize.zero
    private var titleSize = CGSize.zero
    
    fileprivate func syncAppearance(_ type: Bool = true, _ size: Bool = true) {
        typeStyles = buttonAppearance?.typeStyle ?? ZButton.TypeStyles[buttonType2]!
        sizeStyles = buttonAppearance?.sizeStyle ?? ZButton.SizeStyles[buttonSize]!
        if type {
            iconPosition = typeStyles.iconPosition
            self.titleColors = typeStyles.textColor
            self.backgroundColors = typeStyles.backgroundColor
            indicator.color = typeStyles.textColor.normalColor()
        }
        if size {
            self.layer.cornerRadius = sizeStyles.radius
            self.titleLabel?.font = UIFont.systemFont(ofSize: sizeStyles.textSize, weight: .semibold)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: sizeStyles.padding, bottom: 0, right: sizeStyles.padding)
            let oldSize = imageSize
            imageSize = CGSize(width: sizeStyles.iconSize, height: sizeStyles.iconSize)
            if icon != nil {
                syncStates()
                imageView?.updateSvgScale(oldSize, imageSize)
            }
            self.syncSize()
        }
    }
    
    fileprivate func syncContent() {
        icon = nil
        text = nil
        if let string = content as? String {
            text = string
        } else if let url = content as? URL {
            icon = url
        } else if let style = content as? ZButtonStyle {
            applyStyle(style)
        } else if let (string, url) = content as? (String, URL) {
            text = string
            icon = url
        } else if let array = content as? NSArray {
            for item in array {
                if let string = item as? String {
                    text = string
                } else if let url = item as? URL {
                    icon = url
                }
            }
        } else if let map = content as? NSDictionary {
            if let string = map["text"] as? String {
                text = string
            }
            if let url = map["icon"] as? URL {
                icon = url
            }
            if let pos = map["iconPosition"] as? IconPosition {
                iconPosition = pos
            }
        }
    }
    
    private var sizeConstraint: (NSLayoutConstraint, NSLayoutConstraint)? = nil
    
    fileprivate func syncSize() {
        minSize = CGSize.zero
        if self.text != nil {
            self.titleLabel?.sizeToFit()
            titleSize = self.titleLabel!.bounds.size
            minSize.width = titleSize.width
            minSize.height = titleSize.height
        }
        if self.icon != nil {
            if (iconPosition == .Left || iconPosition == .Right) {
                minSize.width += imageSize.width
                if text != nil {
                    minSize.width += sizeStyles.iconPadding
                }
                if imageSize.height > minSize.height {
                    minSize.height = imageSize.height
                }
            } else {
                minSize.height += imageSize.height
                if text != nil {
                    minSize.height += sizeStyles.iconPadding
                }
                if imageSize.width > minSize.width {
                    minSize.width = imageSize.width
                }
            }
        }
        let size = CGSize(width: minSize.width + sizeStyles.padding * 2, height: sizeStyles.height)
        self.bounds.size = size
        sizeConstraint = updateSizeConstraint(sizeConstraint, size, widthRange: 1, heightRange: 1)
    }
    
    fileprivate func syncStates() {
        if self.icon != nil && sizeStyles.textSize > 0 {
            // TODO: split with title color, ZTextInput icon
            //self.imageView?.setIconColor(color: currentTitleColor)
            self.imageView?.setIconColor(color: typeStyles.textColor.color(for: state))
        }
    }
    
    /**
     Show a loader inside the button with image.
     
     - Parameter userInteraction: Enable user interaction while showing the loader.
     */
    open func showLoader(userInteraction: Bool = false) {
        showLoader([self.imageView, self.titleLabel], userInteraction: userInteraction)
    }
    
    
    open func showLoaderWithImage(userInteraction: Bool = false) {
        showLoader([self.titleLabel], userInteraction: userInteraction)
    }
    /**
     Display the loader inside the button.
     
     - Parameter viewsToBeHidden: The views such as titleLabel, imageViewto be hidden while showing loading indicator.
     - Parameter userInteraction: Enable the user interaction while displaying the loader.
     - Parameter completion:      The completion handler.
    */
    func showLoader(_ viewsToBeHidden: [UIView?], userInteraction: Bool = false) {
        guard !self.subviews.contains(indicator) else { return }
        // Set up loading indicator and update loading state
        self.isUserInteractionEnabled = userInteraction
        indicator.radius = min(0.7*self.frame.height/2, indicator.radius)
        indicator.alpha = 0.0
        self.addSubview(self.indicator)
        // Clean up
        loaderWorkItem?.cancel()
        loaderWorkItem = nil
        // Create a new work item
        loaderWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
            UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
                viewsToBeHidden.forEach {
                    $0?.alpha = 0.0
                }
                self.indicator.alpha = 1.0
            }) { _ in
                guard !item.isCancelled else { return }
                self.isLoading ? self.indicator.startAnimating() : self.hideLoader()
            }
        }
        loaderWorkItem?.perform()
    }
    /**
     Hide the loader displayed.
     
     - Parameter completion: The completion handler.
     */
    open func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard self.subviews.contains(self.indicator) else { return }
            self.isUserInteractionEnabled = true
            self.indicator.stopAnimating()
            // Clean up
            self.indicator.removeFromSuperview()
            self.loaderWorkItem?.cancel()
            self.loaderWorkItem = nil
            // Create a new work item
            self.loaderWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self, let item = self.loaderWorkItem, !item.isCancelled else { return }
                UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
                    self.titleLabel?.alpha = 1.0
                    self.imageView?.alpha = 1.0
                }) { _ in
                    guard !item.isCancelled else { return }
                }
            }
            self.loaderWorkItem?.perform()
        }
    }
}

public extension ZButton {
    
    func text(_ value: String?) -> Self {
        self.text = value
        return self
    }
    
    func icon(_ value: URL?) -> Self {
        self.icon = value
        return self
    }
    
//    public func loadingText(_ value: String?) -> Self {
//        self.loadingText = value
//        return self
//    }
//
//    public func loadingIcon(_ value: URL?) -> Self {
//        self.loadingIcon = value
//        return self
//    }
    
    func buttonType(_ value: ZButton.ButtonType) -> Self {
        self.buttonType2 = value
        return self
    }
    
    func buttonSize(_ value: ZButton.ButtonSize) -> Self {
        self.buttonSize = value
        return self
    }
    
    func buttonAppearance(_ value: ZButtonAppearance) -> Self {
        self.buttonAppearance = value
        return self
    }

}
