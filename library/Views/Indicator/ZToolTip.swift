//
//  XHBToolTip.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation

@objc public protocol XHBToolTipDelegate {
}

@objc public protocol XHBToolTipContentDelegate : XHBToolTipDelegate {
    
    @objc optional func toolTipMaxWidth(_ toolTip: XHBToolTip) -> CGFloat
    @objc optional func toolTipSingleLine(_ toolTip: XHBToolTip) -> Bool
    @objc optional func toolTipPerfectLocation(_ toolTip: XHBToolTip) -> XHBToolTip.Location
    @objc optional func toolTipIcon(_ toolTip: XHBToolTip) -> URL?
    @objc optional func toolTipLeftIcon(_ toolTip: XHBToolTip) -> URL?
    @objc optional func toolTipRightIcon(_ toolTip: XHBToolTip) -> URL?
    @objc optional func toolTipButton(_ toolTip: XHBToolTip) -> XHBButton?
}

@objc public protocol XHBToolTipCallbackDelegate : XHBToolTipDelegate {
        
    @objc optional func toolTipDelayTime(_ toolTip: XHBToolTip) -> Double
    @objc optional func toolTipIconTapped(_ toolTip: XHBToolTip, index: Int)
    @objc optional func toolTipDismissed(_ toolTip: XHBToolTip, isFromUser: Bool)
}

public class XHBToolTip : UIView
{
    
    public class func tip(_ target: UIView, _ message: String, delegate:  XHBToolTipDelegate? = nil) {
        
        let tipView = XHBToolTip()
        tipView.message = message
        tipView.delegate = delegate
        tipView.popAt(target)
        
        let delayTime = (delegate as? XHBToolTipCallbackDelegate)?.toolTipDelayTime?(tipView) ?? 3
        if delayTime > 0 {
            DispatchQueue.main.delay(delayTime) {
                tipView.dismissAnimated(true)
            }
        }

    }
    
    @objc public enum Location : Int, RawRepresentable, CaseIterable, Comparable {
        
        public static func < (lhs: XHBToolTip.Location, rhs: XHBToolTip.Location) -> Bool {
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
    private static let padding: CGFloat = 16
    private static let iconSize: CGFloat = 16
    private static let iconPadding: CGFloat = 8
    private static let defaultFrameColor = UIColor(rgb: 0x1D2126)
    private static let defaultTextColor = ThemeColor.shared.bluegrey_00
    private static let defaultFont = systemFontSize(fontSize: 16, type: .regular)

    public var location = Location.TopRight
    
    public var maxWidth: CGFloat = 200 // if < 0, add window size

    public var message: String {
        get { messageLabel.text ?? "" }
        set { messageLabel.text = newValue }
    }
    
    public var frameColor: UIColor = XHBToolTip.defaultFrameColor {
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
    
    public var singleLine: Bool = false {
        didSet {
            messageLabel.numberOfLines = singleLine ? 1 : 0
        }
    }
    
    public var leftIcon: URL? {
        didSet {
            leftIconView.setIcon(svgURL: leftIcon)
        }
    }
    
    public var rightIcon: URL? {
        didSet {
            rightIconView.setIcon(svgURL: rightIcon)
        }
    }
    
    public var icon: URL? {
        didSet {
            iconView.setIcon(svgURL: icon) {_ in
                //self.iconView.bounds = boundingBox.centerBounding()
                //self.iconView.setIconColor(color: self.textColor)
            }
        }
    }
    
    public var button: XHBButton? = nil {
        didSet {
            if let button = button {
                addSubview(button)
            }
            setNeedsLayout()
        }
    }
    
    public var delegate: XHBToolTipDelegate? = nil {
        didSet {
            if let delegate = self.delegate as? XHBToolTipContentDelegate {
                self.singleLine = delegate.toolTipSingleLine?(self) ?? self.singleLine
                self.maxWidth = delegate.toolTipMaxWidth?(self) ?? self.maxWidth
                self.location = delegate.toolTipPerfectLocation?(self) ?? self.location
                if let icon = delegate.toolTipLeftIcon?(self) {
                    self.leftIcon = icon
                }
                if let icon = delegate.toolTipRightIcon?(self) {
                    self.rightIcon = icon
                }
                if let icon = delegate.toolTipIcon?(self) {
                    self.icon = icon
                }
                self.button = delegate.toolTipButton?(self) ?? self.button
            }

        }
    }
    
    /* private variables */
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var leftIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.bounds.width2 = XHBToolTip.iconSize
        imageView.bounds.height2 = XHBToolTip.iconSize
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(iconTap(_:)))
        imageView.addGestureRecognizer(recognizer)
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var rightIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.bounds.width2 = XHBToolTip.iconSize
        imageView.bounds.height2 = XHBToolTip.iconSize
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(iconTap(_:)))
        imageView.addGestureRecognizer(recognizer)
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.bounds.width2 = XHBToolTip.iconSize
        imageView.bounds.height2 = XHBToolTip.iconSize
        addSubview(imageView)
        return imageView
    }()
    
    private let backLayer = CALayer()
    private let arrowLayer = CAShapeLayer()

    public init() {
        super.init(frame: CGRect.zero)
        backLayer.backgroundColor = XHBToolTip.defaultFrameColor.cgColor
        arrowLayer.fillColor = XHBToolTip.defaultFrameColor.cgColor
        backLayer.cornerRadius = XHBToolTip.radius
        layer.addSublayer(backLayer)

        messageLabel.font = XHBToolTip.defaultFont
        textColor = XHBToolTip.defaultTextColor
        addSubview(messageLabel)
    }
    
    public func popAt(_ target: UIView) {
        let mWidth = self.maxWidth < 0 ? target.window!.bounds.width + self.maxWidth : self.maxWidth
        let size = calcSize(mWidth)
        var frame = CGRect(origin: calcLocation(target, size), size: size)
        if location == .ManualLayout {
            frame.width2 = target.bounds.width
        }
        target.window?.addSubview(self)
        self.frame = frame
    }
    
    fileprivate func calcSize(_ mWidth: CGFloat) -> CGSize {
        var size = CGSize(width: XHBToolTip.padding * 2, height: XHBToolTip.padding * 2)
        if leftIcon != nil {
            size.width += XHBToolTip.padding + XHBToolTip.iconSize
        }
        if icon != nil {
            size.width += XHBToolTip.iconPadding + XHBToolTip.iconSize
        }
        if rightIcon != nil {
            size.width += XHBToolTip.padding + XHBToolTip.iconSize
        }
        if let button = button {
            size.width += XHBToolTip.padding + button.frame.width
        }
        if location < .AutoToast {
            size.height += XHBToolTip.arrowSize
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
        let wbounds = target.window!.bounds
        // for toast location
        if location == .AutoToast {
            if XHBToolTip.toastCount <= 0 {
                XHBToolTip.toastY = wbounds.bottom - wbounds.width / 8
            } else {
                XHBToolTip.toastY -= size.height + 20
            }
            XHBToolTip.toastCount += 1
            location2 = location
            return CGPoint(x: wbounds.centerX - size.width / 2, y: XHBToolTip.toastY - size.height / 2)
        } else if location == .ManualLayout {
            return CGPoint.zero
        }
        // for arrow locations
        var frame = CGRect(origin: CGPoint.zero, size: size)
        let tbounds = target.convert(target.bounds, to: nil)
        let checkX: (Int) -> Int = { (x) in
            switch x {
            case 0: // Left
                frame.right = tbounds.centerX + XHBToolTip.arrowOffset
            case 1:
                frame.centerX = tbounds.centerX
            case 2:
                frame.left = tbounds.centerX - XHBToolTip.arrowOffset
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
            XHBToolTip.toastCount -= 1
        }
    }
    
    @objc func iconTap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            (delegate as? XHBToolTipCallbackDelegate)?.toolTipIconTapped?(self, index: leftIcon != nil && recognizer.view == leftIconView ? 0 : 1)
        }
    }

    public override func layoutSubviews() {
        var frame = self.frame
        frame.origin = CGPoint.zero
        if let l = location2, l != .AutoToast {
            let x = l.rawValue % 3
            let y = l.rawValue >= 3
            var arrowRect = y ? frame.cutTop(XHBToolTip.arrowSize) : frame.cutBottom(XHBToolTip.arrowSize)
            if x == 2 { arrowRect.centerX = frame.left + XHBToolTip.arrowOffset }
            else if (x == 1) { arrowRect.centerX = frame.centerX }
            else { arrowRect.centerX = frame.right - XHBToolTip.arrowOffset }
            let path = CGMutablePath()
            if !y { // down
                path.move(to: CGPoint.zero)
                path.addLine(to: CGPoint(x: XHBToolTip.arrowSize * 2, y: 0))
                path.addLine(to: CGPoint(x: XHBToolTip.arrowSize, y: XHBToolTip.arrowSize))
            } else {
                path.move(to: CGPoint(x: 0, y: XHBToolTip.arrowSize))
                path.addLine(to: CGPoint(x: XHBToolTip.arrowSize * 2, y: XHBToolTip.arrowSize))
                path.addLine(to: CGPoint(x: XHBToolTip.arrowSize, y: 0))
            }
            path.closeSubpath()
            arrowLayer.path = path
            arrowLayer.frame = arrowRect.centerPart(ofSize: CGSize(width: XHBToolTip.arrowSize * 2, height: XHBToolTip.arrowSize))
            layer.addSublayer(arrowLayer)
        }
        backLayer.frame = frame
        frame.deflate(XHBToolTip.padding)
        if leftIcon != nil {
            let iconRect = frame.cutLeft(XHBToolTip.padding + XHBToolTip.iconSize)
            leftIconView.frame = iconRect.leftCenterPart(ofSize: leftIconView.bounds.size)
        }
        if rightIcon != nil {
            let iconRect = frame.cutRight(XHBToolTip.padding + XHBToolTip.iconSize)
            rightIconView.frame = iconRect.rightCenterPart(ofSize: rightIconView.bounds.size)
        }
        if icon != nil {
            let iconRect = frame.cutLeft(XHBToolTip.iconPadding + XHBToolTip.iconSize)
            iconView.frame = iconRect.leftCenterPart(ofSize: iconView.bounds.size)
        }
        if let button = button {
            let iconRect = frame.cutRight(XHBToolTip.padding + button.bounds.width)
            button.frame = iconRect.rightCenterPart(ofSize: button.bounds.size)
        }
        messageLabel.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
