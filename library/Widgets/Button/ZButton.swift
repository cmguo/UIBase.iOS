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
    
    // MARK: - Public variables
    
    // store value from style or set manually, not affect by value in ButtonAppearance
    public var buttonType2: ZButtonAppearance.ButtonType {
        get { return _appearance.buttonType! }
        set {
            if newValue == _appearance.buttonType {
                return
            }
            _appearance.buttonType = newValue
            if buttonAppearance == nil {
                self.syncAppearance(newValue.value.fill(_appearance))
            }
        }
    }
    
    // store value from style or set manually, not affect by value in ButtonAppearance
    public var buttonSize: ZButtonAppearance.ButtonSize {
        get { return _appearance.buttonSize! }
        set {
            if newValue == _appearance.buttonSize {
                return
            }
            _appearance.buttonSize = newValue
            if buttonAppearance == nil {
                self.syncAppearance(newValue.value.fill(_appearance))
            }
        }
    }
    
    public var iconPosition : ZButtonAppearance.IconPosition {
        get { return _appearance.iconPosition! }
        set {
            if newValue == _appearance.iconPosition {
                return
            }
            _appearance.iconPosition = newValue
            self.syncSize()
            self.setNeedsLayout()
        }
    }
    
    public var buttonAppearance: ZButtonAppearance? {
        get { return _buttonAppearance }
        set {
            if _buttonAppearance === newValue {
                return
            }
            _buttonAppearance = newValue
            if let buttonAppearance = _buttonAppearance {
                self.syncAppearance(buttonAppearance.fill(_appearance))
            }
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
            if icon == oldValue {
                return
            }
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
    var _buttonAppearance : ZButtonAppearance? = nil
    var _appearance = ZButtonAppearance(iconPosition: .Left)
    
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
        _appearance.buttonType = style.buttonType ?? .Primitive
        _appearance.buttonSize = style.buttonSize ?? .Large
        _buttonAppearance = style.appearance
        _ = _appearance.normalized()
        _ = style.fill(_appearance)

        super.init(frame: CGRect.zero)
        //translatesAutoresizingMaskIntoConstraints = false
        
        self.contentMode = .redraw
        self.syncAppearance(511)

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
    
    convenience init(styler: (ZButtonStyle) -> Void) {
        let style = ZButtonStyle()
        styler(style)
        self.init(style: style)
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
        backgroundColors = _appearance.backgroundColor!
    }
    
    /* private */
    
    fileprivate func applyStyle(_ style: ZButtonStyle) {
        var change = 0
        if let appearance = style.appearance {
            _buttonAppearance = appearance
            change |= appearance.fill(_appearance)
        }
        change |= style.fill(_appearance)
        self.text = style.text
        self.icon = style.icon
        syncAppearance(change)
    }
    
    
    private var imageSize = CGSize.zero
    private var titleSize = CGSize.zero
    
    fileprivate func syncAppearance(_ change: Int) {
        if ZButtonAppearance.textColorChanged(change) {
            self.titleColors = _appearance.textColor!
            indicator.color = _appearance.textColor!.normalColor()
            if icon != nil {
                syncStates()
            }
        }
        if ZButtonAppearance.backgroundColorChanged(change) {
            self.backgroundColors = _appearance.backgroundColor!
        }
        if ZButtonAppearance.radiusChanged(change) {
            self.layer.cornerRadius = _appearance.radius!
        }
        if ZButtonAppearance.textSizeChanged(change) {
            self.titleLabel?.font = UIFont.systemFont(ofSize: _appearance.textSize!, weight: .semibold)
        }
        if ZButtonAppearance.paddingChanged(change) {
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: _appearance.padding!, bottom: 0, right: _appearance.padding!)
        }
        if ZButtonAppearance.iconSizeChanged(change) {
            let oldSize = imageSize
            imageSize = CGSize(width: _appearance.iconSize!, height: _appearance.iconSize!)
            if icon != nil {
                imageView?.updateSvgScale(oldSize, imageSize)
            }
        }
        if ZButtonAppearance.sizeChanged(change) {
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
            if let pos = map["iconPosition"] as? ZButtonAppearance.IconPosition {
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
                    minSize.width += _appearance.iconPadding!
                }
                if imageSize.height > minSize.height {
                    minSize.height = imageSize.height
                }
            } else {
                minSize.height += imageSize.height
                if text != nil {
                    minSize.height += _appearance.iconPadding!
                }
                if imageSize.width > minSize.width {
                    minSize.width = imageSize.width
                }
            }
        }
        let size = CGSize(width: minSize.width + _appearance.padding! * 2, height: _appearance.height!)
        self.bounds.size = size
        sizeConstraint = updateSizeConstraint(sizeConstraint, size, widthRange: 1, heightRange: 1)
    }
    
    fileprivate func syncStates() {
        if self.icon != nil && _appearance.textSize! > 0 {
            // TODO: split with title color, ZTextInput icon
            //self.imageView?.setIconColor(color: currentTitleColor)
            self.imageView?.setIconColor(color: _appearance.textColor!.color(for: state))
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
    
    @discardableResult
    func text(_ value: String?) -> Self {
        self.text = value
        return self
    }
    
    @discardableResult
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
    
    @discardableResult
    func buttonType(_ value: ZButtonAppearance.ButtonType) -> Self {
        self.buttonType2 = value
        return self
    }
    
    @discardableResult
    func buttonSize(_ value: ZButtonAppearance.ButtonSize) -> Self {
        self.buttonSize = value
        return self
    }
    
    @discardableResult
    func buttonAppearance(_ value: ZButtonAppearance) -> Self {
        self.buttonAppearance = value
        return self
    }

}
