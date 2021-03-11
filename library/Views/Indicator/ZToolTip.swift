//
//  XHBToolTip.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/11.
//

import Foundation

public class XHBToolTip : UIView
{
    
    public class func tip(_ target: UIView, _ message: String, maxWidth: CGFloat = 100, location: Location = Location.TopRight, delayTime: Double = 3) {
        
        let tipView = XHBToolTip()
        tipView.message = message
        tipView.maxWidth = maxWidth
        tipView.location = location
        tipView.popAt(target)
        
        if delayTime > 0 {
            DispatchQueue.main.delay(delayTime) {
                tipView.dismissAnimated(true)
            }
        }

    }
    
    public enum Location : Int, RawRepresentable, CaseIterable {
        case TopLeft
        case TopCenter
        case TopRight
        case BottomLeft
        case BottomCenter
        case BottomRight
    }
    
    private static let arrowSize: CGFloat = 6
    private static let arrowOffset: CGFloat = 16
    private static let radius: CGFloat = 8
    private static let padding: CGFloat = 13
    private static let iconPadding: CGFloat = 8
    private static let defaultBackgroundColor = UIColor(rgb: 0x1D2126)
    private static let defaultTextColor = ThemeColor.shared.bluegrey_00
    private static let defaultFont = systemFontSize(fontSize: 16, type: .regular)

    public var location = Location.TopRight
    
    public var maxWidth: CGFloat = 100 // if < 0, add window size

    public var message: String {
        get { messageLabel.text ?? "" }
        set { messageLabel.text = newValue }
    }
    
    public var textColor: UIColor {
        get { messageLabel.textColor }
        set { messageLabel.textColor = newValue }
    }
    
    public var font: UIFont {
        get { messageLabel.font }
        set { messageLabel.font = newValue }
    }
    
    public var icon: URL? {
        didSet {
            iconView.setIcon(svgURL: icon) {(boundingBox: CGRect) in
                self.iconView.bounds = boundingBox.centerBounding()
            }
        }
    }
    
    /* private variables */
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        return imageView
    }()
    
    private let backLayer = CALayer()
    private let arrowLayer = CAShapeLayer()

    public init() {
        super.init(frame: CGRect.zero)
        backLayer.backgroundColor = XHBToolTip.defaultBackgroundColor.cgColor
        arrowLayer.fillColor = XHBToolTip.defaultBackgroundColor.cgColor
        backLayer.cornerRadius = XHBToolTip.radius
        layer.addSublayer(backLayer)
        layer.addSublayer(arrowLayer)

        messageLabel.font = XHBToolTip.defaultFont
        textColor = XHBToolTip.defaultTextColor
        addSubview(messageLabel)
    }
    
    private var location2 = Location.TopLeft
    
    public func popAt(_ target: UIView) {
        let wbounds = target.window!.bounds
        let tbounds = target.convert(target.bounds, to: nil)
        let width = self.maxWidth < 0 ? wbounds.width + self.maxWidth : self.maxWidth
        let size = message.boundingSize(with: CGSize(width: width, height: 0), font: font)
        var frame = CGRect(origin: CGPoint.zero, size: size)
        frame.inflate(XHBToolTip.padding)
        if icon != nil {
            frame.width2 += XHBToolTip.iconPadding * 2 - XHBToolTip.padding + iconView.bounds.width
        }
        frame.height2 += XHBToolTip.arrowSize
        
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
                checkY(y)
            } else {
                y = !y
            }
        }
        
        location2 = Location(rawValue: x + (y ? 3 : 0))!
        target.window?.addSubview(self)
        self.frame = frame
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
    }

    public override func layoutSubviews() {
        var frame = self.frame
        frame.origin = CGPoint.zero
        let x = location2.rawValue % 3
        let y = location2.rawValue >= 3
        var arrowRect = y ? frame.cutTop(XHBToolTip.arrowSize) : frame.cutBottom(XHBToolTip.arrowSize)
        backLayer.frame = frame
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
        if icon != nil {
            var iconRect = frame.cutRight(XHBToolTip.iconPadding + iconView.bounds.width)
            frame.width2 += XHBToolTip.padding - XHBToolTip.iconPadding
            iconView.frame = iconRect.leftCenterPart(ofSize: iconView.bounds.size)
        }
        frame.deflate(XHBToolTip.padding)
        messageLabel.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
