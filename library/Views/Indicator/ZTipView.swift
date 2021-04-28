//
//  style.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation

@objc public protocol ZTipViewCallback {
        
    @objc optional func tipViewDelayTime(_ tipView: ZTipView) -> Double
    @objc optional func tipViewButtonClicked(_ tipView: ZTipView, _ btnId: ZButton.ButtonId?)
    @objc optional func tipViewDismissed(_ tipView: ZTipView, isFromUser: Bool)
}

public class ZTipView : UIView
{
    
    public class func tip(_ target: UIView, _ message: String, callback:  ZTipViewCallback? = nil) {
        let tipView = ZTipView()
        tipView.message = message
        tipView.callback = callback
        tipView.popAt(target)
    }
    
    public class func toast(_ target: UIView, _ message: String, callback:  ZTipViewCallback? = nil) {
        let tipView = ZTipView()
        tipView.message = message
        tipView.callback = callback
        tipView.location = .AutoToast
        tipView.popAt(target)
    }

    public class func remove(from target: UIView, animate: Bool = false) {
        for c in target.subviews {
            if let tip = c as? ZTipView {
                tip.dismissAnimated(animate)
            }
        }
    }
    
    @objc public enum Location : Int, RawRepresentable, CaseIterable, Comparable {
        
        public static func < (lhs: ZTipView.Location, rhs: ZTipView.Location) -> Bool {
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
                self.textAppearance = _style.textAppearanceSmall
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
        get { _backLayer.cornerRadius }
        set { _backLayer.cornerRadius = newValue }
    }
    
    public var frameColor: UIColor = .black {
        didSet {
            _backLayer.backgroundColor = frameColor.cgColor
            _arrowLayer.backgroundColor = frameColor.cgColor
        }
    }
    
    public var textAppearance = TextAppearance() {
        didSet {
            messageLabel.textAppearance = textAppearance
        }
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
            _iconView.setImage(withURL: icon)
        }
    }
    
    public var dismissDelay: Double = 0
    
    public var callback: ZTipViewCallback? = nil
    
    /* private variables */
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        //label = .zero
        return label
    }()
    
    private lazy var _leftButton: ZButton = {
        let button = ZButton()
        button.buttonType2 = .TextLink
        button.buttonSize = .Thin
        button.id = .Left
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _rightButton: ZButton = {
        let button = ZButton()
        button.buttonType2 = .TextLink
        button.buttonSize = .Thin
        button.id = .Right
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var _iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.bounds.width2 = _style.iconSize
        imageView.bounds.height2 = _style.iconSize
        addSubview(imageView)
        return imageView
    }()
    
    private let _style: ZTipViewStyle
    private let _backLayer = CALayer()
    private let _arrowLayer = CAShapeLayer()

    public init(_ style: ZTipViewStyle = ZTipViewStyle()) {
        self._style = style
        self.frameColor = style.frameColor
        super.init(frame: CGRect.zero)
        dismissDelay = style.dismissDelay
        
        _backLayer.backgroundColor = style.frameColor.cgColor
        _arrowLayer.fillColor = style.frameColor.cgColor
        _backLayer.cornerRadius = style.radius
        layer.addSublayer(_backLayer)

        messageLabel.textAppearance = style.textAppearance
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
            if _style.dismissDelay > 0 {
                DispatchQueue.main.delay(dismissDelay) {
                    self.dismissAnimated(true)
                }
            }
        }
    }
    
    fileprivate func calcSize(_ mWidth: CGFloat) -> CGSize {
        var size = CGSize(width: _style.paddingX * 2, height: _style.paddingY * 2)
        if leftButton != nil {
            size.width += _style.paddingX + _leftButton.bounds.width
        }
        if icon != nil {
            size.width += _style.iconPadding + _style.iconSize
        }
        if rightButton != nil {
            size.width += _style.paddingX + _rightButton.bounds.width
        }
        if location < .AutoToast {
            size.height += _style.arrowSize
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
                frame.right = tbounds.centerX + self._style.arrowOffset
            case 1:
                frame.centerX = tbounds.centerX
            case 2:
                frame.left = tbounds.centerX - self._style.arrowOffset
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
        callback?.tipViewButtonClicked?(self, (sender as! ZButton).id)
    }

    public override func layoutSubviews() {
        var frame = self.bounds
        if let l = location2, l != .AutoToast {
            let x = l.rawValue % 3
            let y = l.rawValue >= 3
            var arrowRect = y ? frame.cutTop(_style.arrowSize) : frame.cutBottom(_style.arrowSize)
            if x == 2 { arrowRect.centerX = frame.left + _style.arrowOffset }
            else if (x == 1) { arrowRect.centerX = frame.centerX }
            else { arrowRect.centerX = frame.right - _style.arrowOffset }
            let path = CGMutablePath()
            if !y { // down
                path.move(to: CGPoint.zero)
                path.addLine(to: CGPoint(x: _style.arrowSize * 2, y: 0))
                path.addLine(to: CGPoint(x: _style.arrowSize, y: _style.arrowSize))
            } else {
                path.move(to: CGPoint(x: 0, y: _style.arrowSize))
                path.addLine(to: CGPoint(x: _style.arrowSize * 2, y: _style.arrowSize))
                path.addLine(to: CGPoint(x: _style.arrowSize, y: 0))
            }
            path.closeSubpath()
            _arrowLayer.path = path
            _arrowLayer.frame = arrowRect.centerPart(ofSize: CGSize(width: _style.arrowSize * 2, height: _style.arrowSize))
            layer.addSublayer(_arrowLayer)
        }
        _backLayer.frame = frame
        frame.deflate(width: _style.paddingX, height: _style.paddingY)
        if leftButton != nil {
            let iconRect = frame.cutLeft(_style.paddingX + _leftButton.bounds.width)
            _leftButton.frame = iconRect.leftCenterPart(ofSize: _leftButton.bounds.size)
        }
        if rightButton != nil {
            let iconRect = frame.cutRight(_style.paddingX + _rightButton.bounds.width)
            _rightButton.frame = iconRect.rightCenterPart(ofSize: _rightButton.bounds.size)
        }
        if icon != nil {
            let iconRect = frame.cutLeft(_style.iconPadding + _style.iconSize)
            _iconView.frame = iconRect.leftCenterPart(ofSize: _iconView.bounds.size)
        }
        messageLabel.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
