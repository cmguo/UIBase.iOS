//
//  style.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation

@objc public protocol XHBTipViewDelegate {
}

@objc public protocol XHBTipViewContentDelegate : XHBTipViewDelegate {
    
    @objc optional func tipViewMaxWidth(_ tipView: XHBTipView) -> CGFloat
    @objc optional func tipViewNumberOfLines(_ tipView: XHBTipView) -> Int
    @objc optional func tipViewPerfectLocation(_ tipView: XHBTipView) -> XHBTipView.Location
    @objc optional func tipViewIcon(_ tipView: XHBTipView) -> URL?
    @objc optional func tipViewLeftButton(_ tipView: XHBTipView) -> Any?
    @objc optional func tipViewRightButton(_ tipView: XHBTipView) -> Any?
}

@objc public protocol XHBTipViewCallbackDelegate : XHBTipViewDelegate {
        
    @objc optional func tipViewDelayTime(_ tipView: XHBTipView) -> Double
    @objc optional func tipViewButtonClicked(_ tipView: XHBTipView, _ btnId: XHBButton.ButtonId?)
    @objc optional func tipViewDismissed(_ tipView: XHBTipView, isFromUser: Bool)
}

public class XHBTipView : UIView
{
    
    public class func tip(_ target: UIView, _ message: String, delegate:  XHBTipViewDelegate? = nil) {
        let tipView = XHBTipView()
        tipView.message = message
        tipView.delegate = delegate
        tipView.popAt(target)
    }
    
    public class func toast(_ target: UIView, _ message: String, delegate:  XHBTipViewDelegate? = nil) {
        let tipView = XHBTipView()
        tipView.message = message
        tipView.delegate = delegate
        tipView.location = .AutoToast
        tipView.popAt(target)
    }

    public class func remove(from target: UIView, animate: Bool = false) {
        for c in target.subviews {
            if let tip = c as? XHBTipView {
                tip.dismissAnimated(animate)
            }
        }
    }
    
    @objc public enum Location : Int, RawRepresentable, CaseIterable, Comparable {
        
        public static func < (lhs: XHBTipView.Location, rhs: XHBTipView.Location) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        case TopLeft
        case TopCenter
        case TopRight
        case BottomLeft
        case BottomCenter
        case BottomRight
        case AutoToast // No arrow
        case ManualLayout // No arrow
    }
    
    private static let arrowSize: CGFloat = 6
    private static let arrowOffset: CGFloat = 16
    private static let radius: CGFloat = 8
    private static let paddingX: CGFloat = 16
    private static let paddingY: CGFloat = 12
    private static let iconSize: CGFloat = 16
    private static let iconPadding: CGFloat = 8
    private static let defaultFrameColor = UIColor(rgb: 0x1D2126)
    private static let defaultTextColor = UIColor.bluegrey_00
    private static let defaultFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    private static let defaultSmallFont = UIFont.systemFont(ofSize: 14, weight: .regular)

    public var location = Location.TopRight {
        didSet {
            if (self.location >= .AutoToast) {
                self.font = style.smallFont
                if (self.location == .ManualLayout) {
                    self.frameRadius = 0
                }
            }
        }
    }
    
    public var maxWidth: CGFloat = 200 // if < 0, add window size

    public var message: String {
        get { messageLabel.text ?? "" }
        set { messageLabel.text = newValue }
    }
    
    public var frameRadius: CGFloat {
        get { backLayer.cornerRadius }
        set { backLayer.cornerRadius = newValue }
    }
    
    public var frameColor: UIColor = .black {
        didSet {
            backLayer.backgroundColor = frameColor.cgColor
            arrowLayer.backgroundColor = frameColor.cgColor
        }
    }
    
    public var textColor: UIColor {
        get { messageLabel.textColor }
        set { messageLabel.textColor = newValue }
    }
    
    public var font: UIFont {
        get { messageLabel.font }
        set { messageLabel.font = newValue }
    }
    
    public var numberOfLines: Int {
        get { messageLabel.numberOfLines }
        set { messageLabel.numberOfLines = newValue }
    }
    
    public var leftButton: Any? {
        didSet {
            _leftButton.content = leftButton
        }
    }
    
    public var rightButton: Any? {
        didSet {
            _rightButton.content = rightButton
        }
    }
    
    public var icon: URL? {
        didSet {
            iconView.setImage(withURL: icon)
        }
    }
    
    public var delegate: XHBTipViewDelegate? = nil {
        didSet {
            if let delegate = self.delegate as? XHBTipViewContentDelegate {
                self.numberOfLines = delegate.tipViewNumberOfLines?(self) ?? self.numberOfLines
                self.maxWidth = delegate.tipViewMaxWidth?(self) ?? self.maxWidth
                self.location = delegate.tipViewPerfectLocation?(self) ?? self.location
                if let button = delegate.tipViewLeftButton?(self) {
                    self.leftButton = button
                }
                if let button = delegate.tipViewRightButton?(self) {
                    self.rightButton = button
                }
                if let icon = delegate.tipViewIcon?(self) {
                    self.icon = icon
                }
            }

        }
    }
    
    /* private variables */
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //label = .zero
        return label
    }()
    
    private lazy var _leftButton: XHBButton = {
        let button = XHBButton()
        button.buttonType2 = .TextLink
        button.buttonSize = .Thin
        button.id = .Left
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _rightButton: XHBButton = {
        let button = XHBButton()
        button.buttonType2 = .TextLink
        button.buttonSize = .Thin
        button.id = .Right
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.bounds.width2 = style.iconSize
        imageView.bounds.height2 = style.iconSize
        addSubview(imageView)
        return imageView
    }()
    
    private let style: XHBTipViewStyle
    private let backLayer = CALayer()
    private let arrowLayer = CAShapeLayer()

    public init(_ style: XHBTipViewStyle = XHBTipViewStyle()) {
        self.style = style
        self.frameColor = style.frameColor
        super.init(frame: CGRect.zero)
        backLayer.backgroundColor = style.frameColor.cgColor
        arrowLayer.fillColor = style.frameColor.cgColor
        backLayer.cornerRadius = style.radius
        layer.addSublayer(backLayer)

        messageLabel.font = style.font
        messageLabel.textColor = style.textColor
        addSubview(messageLabel)
    }
    
    public func popAt(_ target: UIView) {
        var mWidth = self.maxWidth
        if mWidth < 0 {
            mWidth += target.window!.bounds.width
        }
        if location == .ManualLayout {
            mWidth = target.bounds.width
        }
        let size = calcSize(mWidth)
        var frame = CGRect(origin: calcLocation(target, size), size: size)
        if location == .ManualLayout {
            frame.width2 = target.bounds.width
            target.addSubview(self)
        } else {
            target.window?.addSubview(self)
        }
        self.frame = frame
        
        if location != .ManualLayout {
            let delayTime = (delegate as? XHBTipViewCallbackDelegate)?.tipViewDelayTime?(self) ?? 3
            if delayTime > 0 {
                DispatchQueue.main.delay(delayTime) {
                    self.dismissAnimated(true)
                }
            }
        }
    }
    
    fileprivate func calcSize(_ mWidth: CGFloat) -> CGSize {
        var size = CGSize(width: style.paddingX * 2, height: style.paddingY * 2)
        if leftButton != nil {
            size.width += style.paddingX + _leftButton.bounds.width
        }
        if icon != nil {
            size.width += style.iconPadding + style.iconSize
        }
        if rightButton != nil {
            size.width += style.paddingX + _rightButton.bounds.width
        }
        if location < .AutoToast {
            size.height += style.arrowSize
        }
        let textSize = messageLabel.sizeThatFits(CGSize(width: mWidth - size.width, height: 0))
        size.width += textSize.width
        size.height += textSize.height
        return size
    }
    
    private var location2: Location? = nil
    
    private static var toastY: CGFloat = 0
    private static var toastCount = 0
    
    fileprivate func calcLocation(_ target: UIView, _ size: CGSize) -> CGPoint {
        if location == .ManualLayout {
            return CGPoint.zero
        }
        let wbounds = target.window!.bounds
        // for toast location
        if location == .AutoToast {
            if Self.toastCount <= 0 {
                Self.toastY = wbounds.bottom - wbounds.width / 8
            } else {
                Self.toastY -= size.height + 20
            }
            Self.toastCount += 1
            location2 = location
            return CGPoint(x: wbounds.centerX - size.width / 2, y: Self.toastY - size.height / 2)
        }
        // for arrow locations
        var frame = CGRect(origin: CGPoint.zero, size: size)
        let tbounds = target.convert(target.bounds, to: nil)
        let checkX: (Int) -> Int = { (x) in
            switch x {
            case 0: // Left
                frame.right = tbounds.centerX + self.style.arrowOffset
            case 1:
                frame.centerX = tbounds.centerX
            case 2:
                frame.left = tbounds.centerX - self.style.arrowOffset
            default:
                break
            }
            if (frame.left >= wbounds.left && frame.right <= wbounds.right) || (frame.left < wbounds.left && frame.right > wbounds.right) {
                return 0
            } else if frame.left < wbounds.left {
                return 1
            } else {
                return -1
            }
        }
        
        let checkY: (Bool) -> (Bool) = { (y) in
            if y {
                frame.top = tbounds.bottom
            } else {
                frame.bottom = tbounds.top
            }
            if (frame.top >= wbounds.top && frame.bottom <= wbounds.bottom) || (frame.top < wbounds.top && frame.bottom > wbounds.bottom) {
                return true
            }
            return false
        }
        
        var x = location.rawValue % 3
        var y = location.rawValue >= 3
        
        var d = checkX(x)
        while d != 0 {
            x += d
            if x < 0 || x >= 3 {
                x -= d
                break
            }
            let d1 = checkX(x)
            if (d1 != 0 && d1 != d) {
                x -= d
                d = checkX(x)
                break
            }
            d = d1
        }
        if !checkY(y) {
            if !checkY(!y) {
                _ = checkY(y)
            } else {
                y = !y
            }
        }
        
        location2 = Location(rawValue: x + (y ? 3 : 0))!
        return frame.origin
    }

    public func dismissAnimated(_ animated: Bool) {
        if animated {
            var customFrame = frame
            customFrame.origin.y += 10

            UIView.beginAnimations(nil, context: nil)
            alpha = 0
            frame = customFrame
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(finaliseDismiss))
            UIView.commitAnimations()
        } else {
            finaliseDismiss()
        }
    }

    @objc func finaliseDismiss() {
        removeFromSuperview()
        if location2 == .AutoToast {
            Self.toastCount -= 1
        }
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        (delegate as? XHBTipViewCallbackDelegate)?.tipViewButtonClicked?(
            self, (sender as! XHBButton).id)
    }

    public override func layoutSubviews() {
        var frame = self.bounds
        if let l = location2, l != .AutoToast {
            let x = l.rawValue % 3
            let y = l.rawValue >= 3
            var arrowRect = y ? frame.cutTop(style.arrowSize) : frame.cutBottom(style.arrowSize)
            if x == 2 { arrowRect.centerX = frame.left + style.arrowOffset }
            else if (x == 1) { arrowRect.centerX = frame.centerX }
            else { arrowRect.centerX = frame.right - style.arrowOffset }
            let path = CGMutablePath()
            if !y { // down
                path.move(to: CGPoint.zero)
                path.addLine(to: CGPoint(x: style.arrowSize * 2, y: 0))
                path.addLine(to: CGPoint(x: style.arrowSize, y: style.arrowSize))
            } else {
                path.move(to: CGPoint(x: 0, y: style.arrowSize))
                path.addLine(to: CGPoint(x: style.arrowSize * 2, y: style.arrowSize))
                path.addLine(to: CGPoint(x: style.arrowSize, y: 0))
            }
            path.closeSubpath()
            arrowLayer.path = path
            arrowLayer.frame = arrowRect.centerPart(ofSize: CGSize(width: style.arrowSize * 2, height: style.arrowSize))
            layer.addSublayer(arrowLayer)
        }
        backLayer.frame = frame
        frame.deflate(width: style.paddingX, height: style.paddingY)
        if leftButton != nil {
            let iconRect = frame.cutLeft(style.paddingX + _leftButton.bounds.width)
            _leftButton.frame = iconRect.leftCenterPart(ofSize: _leftButton.bounds.size)
        }
        if rightButton != nil {
            let iconRect = frame.cutRight(style.paddingX + _rightButton.bounds.width)
            _rightButton.frame = iconRect.rightCenterPart(ofSize: _rightButton.bounds.size)
        }
        if icon != nil {
            let iconRect = frame.cutLeft(style.iconPadding + style.iconSize)
            iconView.frame = iconRect.leftCenterPart(ofSize: iconView.bounds.size)
        }
        messageLabel.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
