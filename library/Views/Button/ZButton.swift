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
        case Small
        case Middle
        case Large
    }
    
    public enum ButtonWidth : Int, RawRepresentable, CaseIterable {
        case WrapContent
        case MatchParent
    }
    
    private struct TypeStyles {
        let textColor: StateListColor
        let backgroundColor: StateListColor
        
        init(_ textColor: StateListColor, _ backgroundColor: StateListColor) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor
        }
    }
    
    // textColor, textColorDisabled, backgroundColor, backgroundColorPressed, backgroundColorDisabled
    private static let typeStyles: [ButtonType: TypeStyles] = [
        .Primitive: TypeStyles(
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.bluegrey_900, StateColor.STATES_NORMAL)]),
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.brand_600, StateColor.STATES_PRESSED),
                StateColor(ThemeColor.shared.brand_500, StateColor.STATES_NORMAL)])),
        .Secondary: TypeStyles(
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.blue_600, StateColor.STATES_NORMAL)]),
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.blue_200, StateColor.STATES_PRESSED),
                StateColor(ThemeColor.shared.blue_100, StateColor.STATES_NORMAL)])),
        .Tertiary: TypeStyles(
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.bluegrey_800, StateColor.STATES_NORMAL)]),
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.bluegrey_300, StateColor.STATES_PRESSED),
                StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_NORMAL)])),
        .Danger: TypeStyles(
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.red_600, StateColor.STATES_NORMAL)]),
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.red_500, StateColor.STATES_PRESSED),
                StateColor(ThemeColor.shared.red_100, StateColor.STATES_NORMAL)])),
        .TextLink: TypeStyles(
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.blue_600, StateColor.STATES_NORMAL)]),
            StateListColor([
                StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
                StateColor(ThemeColor.shared.bluegrey_200, StateColor.STATES_PRESSED),
                StateColor(ThemeColor.shared.transparent, StateColor.STATES_NORMAL)])),
    ]
    
    private struct SizeStyles {
        let height: CGFloat
        let radius: CGFloat
        let padding: CGFloat // (left, rigth)
        let textSize: CGFloat
        let iconPadding: CGFloat
        
        init(_ height: CGFloat, _ radius: CGFloat, _ padding: CGFloat, _ textSize: CGFloat, _ iconPadding: CGFloat) {
            self.height = height
            self.radius = radius
            self.padding = padding
            self.textSize = textSize
            self.iconPadding = iconPadding
        }
    }
    // height, padding(left, rigth), textSize, iconPadding, radius
    private static let sizeStyles: [ButtonSize: SizeStyles] = [
        .Large: SizeStyles(44, 24, 24, 18, 5),
        .Middle: SizeStyles(36, 18, 16, 16, 4),
        .Small: SizeStyles(24, 12, 12, 14, 3)
    ]
    
    // MARK: - Public variables
    
    public var text: String? = nil {
        didSet {
            //self.titleLabel?.text = text
            self.setTitle(text)
            updateSize()
        }
    }
    
    public var icon: URL? = nil {
        didSet {
            self.setImage(UIImage.transparent)
            self.imageView?.setIcon(svgURL: icon, completion: {(boundingBox: CGRect) in
                self.imageSize = boundingBox.centerBoundingSize()
                self.updateSize()
            })
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

    /**
     The loading indicator used with the button.
     */
    open var indicator: UIView & IndicatorProtocol = MaterialLoadingIndicator()

    // Private properties
    private var typeStyles: TypeStyles
    private var sizeStyles: SizeStyles
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
    public init(
        type: ButtonType = .Primitive,
        sizeMode: ButtonSize = .Large,
        icon: URL? = nil,
        text: String? = nil
    ) {
        typeStyles = XHBButton.typeStyles[type]!
        sizeStyles = XHBButton.sizeStyles[sizeMode]!
        
        super.init(frame: CGRect.zero)
        
        indicator.color = typeStyles.textColor.normalColor()

        self.contentMode = .redraw
        self.setTitleColor(typeStyles.textColor.normalColor(), for: .normal)
        self.setTitleColor(typeStyles.textColor.disabledColor(), for: .disabled)
        self.setBackgroundColor(color: typeStyles.backgroundColor.normalColor(), forState: .normal)
        self.setBackgroundColor(color: typeStyles.backgroundColor.disabledColor(), forState: .disabled)
        self.setBackgroundColor(color: typeStyles.backgroundColor.pressedColor(), forState: .highlighted)
        self.setCornerBorder(cornerRadius: sizeStyles.radius)
        self.titleLabel?.font = systemFontSize(fontSize: sizeStyles.textSize, type: .semibold)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: sizeStyles.padding, bottom: 0, right: sizeStyles.padding)
        
        // Set button contents
        // Set the icon of the button
        if let icon = icon {
            self.icon = icon
            self.imageView?.setIcon(svgURL: icon, completion: {(boundingBox: CGRect) in
                self.imageSize = boundingBox.centerBoundingSize()
                self.updateSize()
            })
        }
        // Set the title of the button
        if let text = text {
            self.text = text
            self.setTitle(text)
        }
        updateSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageSize = CGSize.zero
    private var titleSize = CGSize.zero
    
    fileprivate func updateSize() {
        minSize = CGSize.zero
        if self.text != nil {
            self.titleLabel?.sizeToFit()
            titleSize = self.titleLabel!.bounds.size
            minSize.width += titleSize.width
            minSize.height = titleSize.height
        }
        if self.icon != nil {
            //imageSize = self.imageView!.layer.frame.size
            minSize.width += imageSize.width
            if text != nil {
                minSize.width += 6
            }
            if imageSize.height > minSize.height {
                minSize.height = imageSize.height
            }
        }
        let size = CGSize(width: minSize.width + sizeStyles.padding * 2, height: sizeStyles.height)
        bounds = CGRect(origin: CGPoint.zero, size: size)
        superview?.setNeedsLayout()
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return bounds.centerPart(ofSize: minSize).leftCenterPart(ofSize: imageSize)
    }
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return bounds.centerPart(ofSize: minSize).rightCenterPart(ofSize: titleSize)
    }
    
    // layoutSubviews
    open override func layoutSubviews() {
        super.layoutSubviews()
        let rect = bounds.centerPart(ofSize: minSize)
        if icon != nil {
            imageView?.frame = rect.leftCenterPart(ofSize: imageView!.bounds.size)
        }
        if text != nil {
            titleLabel?.frame = rect.rightCenterPart(ofSize: titleLabel!.bounds.size)
        }
        indicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
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
