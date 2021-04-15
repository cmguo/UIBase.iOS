//
//  XHBButton.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/1.
//

import Foundation

@IBDesignable
public class XHBButton : UIButton
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
            self.syncAppearance(true, false)
        }
    }
    public var buttonSize: ButtonSize {
        didSet {
            self.syncAppearance(false, true)
        }
    }
    
    public var iconPosition = IconPosition.Left {
        didSet {
            self.syncSize()
            self.setNeedsLayout()
        }
    }
    
    public var buttonAppearance: XHBButtonAppearance? = nil {
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
            self.setImage(UIImage.transparent)
            self.imageView?.setIcon(svgURL: icon, inBounds: CGRect(origin: CGPoint.zero, size: imageSize)) {_ in
                self.syncStates()
            }
            self.syncSize()
        }
    }
    
    public var content: Any? = nil {
        didSet {
            self.syncContent()
        }
    }
    /**
     Current loading state.
     */
    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                showLoaderWithImage()
            } else {
                hideLoader()
            }
        }
    }

    public override var isEnabled: Bool {
        didSet {
            self.syncStates()
        }
    }
    
    /**
     The loading indicator used with the button.
     */
    open var indicator: UIView & IndicatorProtocol = MaterialLoadingIndicator()

    // Private properties
    private var typeStyles: XHBButtonTypeStyle
    private var sizeStyles: XHBButtonSizeStyle
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
    public init(style: XHBButtonStyle = .defaultStyle) {
        buttonAppearance = style.appearance
        buttonType2 = style.buttonType ?? .Primitive
        buttonSize = style.buttonSize ?? .Large
        typeStyles = style.appearance?.typeStyle ?? XHBButton.typeStyles[style.buttonType ?? .Primitive]!
        sizeStyles = style.appearance?.sizeStyle ?? XHBButton.sizeStyles[style.buttonSize ?? .Large]!
        iconPosition = typeStyles.iconPosition
        
        super.init(frame: CGRect.zero)
        
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
            self.imageView?.setIcon(svgURL: icon, inBounds: CGRect(origin: CGPoint.zero, size: imageSize)) {_ in
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
    
    /* private */
    
    fileprivate func applyStyle(_ style: XHBButtonStyle) {
        buttonType2 = style.buttonType ?? .Primitive
        buttonSize = style.buttonSize ?? .Large
        buttonAppearance = style.appearance
        self.text = style.text
        self.icon = style.icon
    }
    
    private static let typeStyles: [ButtonType: XHBButtonTypeStyle] = [
        .Primitive: .primitiveAppearance,
        .Secondary: .secondaryAppearance,
        .Tertiary: .tertiaryAppearance,
        .Danger: .dangerAppearance,
        .TextLink: .textLinkAppearance
    ]
    
    private static let sizeStyles: [ButtonSize: XHBButtonSizeStyle] = [
        .Large: .largeAppearance,
        .Middle: .middleAppearance,
        .Small: .smallAppearance,
        .Thin: .thinAppearance
    ]
    
    private var imageSize = CGSize.zero
    private var titleSize = CGSize.zero
    
    fileprivate func syncAppearance(_ type: Bool = true, _ size: Bool = true) {
        typeStyles = buttonAppearance?.typeStyle ?? XHBButton.typeStyles[buttonType2]!
        sizeStyles = buttonAppearance?.sizeStyle ?? XHBButton.sizeStyles[buttonSize]!
        if type {
            iconPosition = typeStyles.iconPosition
            self.setTitleColor(typeStyles.textColor.normalColor(), for: .normal)
            self.setTitleColor(typeStyles.textColor.disabledColor(), for: .disabled)
            self.setBackgroundColor(color: typeStyles.backgroundColor.normalColor(), forState: .normal)
            self.setBackgroundColor(color: typeStyles.backgroundColor.disabledColor(), forState: .disabled)
            self.setBackgroundColor(color: typeStyles.backgroundColor.pressedColor(), forState: .highlighted)
            indicator.color = typeStyles.textColor.normalColor()
        }
        if size {
            self.setCornerBorder(cornerRadius: sizeStyles.radius)
            self.titleLabel?.font = systemFontSize(fontSize: sizeStyles.textSize, type: .semibold)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: sizeStyles.padding, bottom: 0, right: sizeStyles.padding)
            imageSize = CGSize(width: sizeStyles.iconSize, height: sizeStyles.iconSize)
            self.syncSize()
        }
    }
    
    fileprivate func syncContent() {
        if let string = content as? String {
            text = string
        } else if let url = content as? URL {
            icon = url
        } else if let style = content as? XHBButtonStyle {
            applyStyle(style)
        } else if let (string, url) = content as? (String, URL) {
            text = string
            icon = url
        }
    }
    
    fileprivate func syncSize() {
        minSize = CGSize.zero
        if self.text != nil {
            self.titleLabel?.sizeToFit()
            titleSize = self.titleLabel!.bounds.size
            minSize.width += titleSize.width
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
        bounds = CGRect(origin: CGPoint.zero, size: size)
        superview?.setNeedsLayout()
    }
    
    fileprivate func syncStates() {
        if self.icon != nil {
            self.imageView?.setIconColor(color: currentTitleColor)
        }
    }
    
    /**
     Show a loader inside the button with image.
     
     - Parameter userInteraction: Enable user interaction while showing the loader.
     */
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
