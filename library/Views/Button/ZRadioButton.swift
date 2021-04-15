//
//  XHBRadioButton.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

@IBDesignable
public class XHBRadioButton: UIButton {
    
    private static let backgroundFillColor = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.bluegrey_00, .STATES_NORMAL)
    ])
    
    private static let backgroundBorderColor = StateListColor([
        StateColor(.bluegrey_300, .STATES_DISABLED),
        StateColor(.brand_500, .STATES_CHECKED),
        StateColor(.bluegrey_500, .STATES_NORMAL)
    ])
    
    private static let foregroundFillColor = StateListColor([
        StateColor(.bluegrey_500, .STATES_DISABLED_CHECKED),
        StateColor(.brand_500, .STATES_CHECKED),
        StateColor(.clear, .STATES_NORMAL)
    ])
        
    private static let height: CGFloat = 24.0
    private static let iconSize: CGFloat = 18.0
    private static let radius: CGFloat = 9.0
    private static let borderSize: CGFloat = 2.0
    private static let borderSize2: CGFloat = 4.0
    private static let textPadding: CGFloat = 7.0
    
    public var checked: Bool = false {
        didSet {
            updateStates()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            updateStates()
        }
    }
    
    
    private let backgroundLayer = CALayer()
    private let foregroundLayer = CALayer()

    public init(text: String? = nil) {
        super.init(frame: CGRect.zero)
        
        var frame = CGRect(x: 0, y: 0, width: XHBRadioButton.iconSize, height: XHBRadioButton.height)
        self.frame = frame

        self.setImage(UIImage.from(color: .clear))
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: XHBRadioButton.iconSize, height: XHBRadioButton.iconSize)
        backgroundLayer.cornerRadius = XHBRadioButton.radius
        backgroundLayer.borderWidth = XHBRadioButton.borderSize
        self.imageView?.layer.addSublayer(backgroundLayer)

        foregroundLayer.frame = CGRect(x: XHBRadioButton.borderSize2, y: XHBRadioButton.borderSize2, width: XHBRadioButton.iconSize - XHBRadioButton.borderSize2 * 2, height: XHBRadioButton.iconSize - XHBRadioButton.borderSize2 * 2)
        foregroundLayer.cornerRadius = XHBRadioButton.radius - XHBRadioButton.borderSize2
        foregroundLayer.borderWidth = 0
        self.imageView?.layer.addSublayer(foregroundLayer)

        if let text = text {
            self.setTitle(text)
            self.titleLabel?.sizeToFit()
            let size = self.titleLabel!.sizeThatFits(CGSize())
            frame.size.width = frame.width + XHBRadioButton.textPadding + size.width
        }

        self.frame = frame
        
        updateStates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.leftCenterPart(ofSize: CGSize(width: XHBRadioButton.iconSize, height: XHBRadioButton.iconSize))
    }
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.rightCenterPart(ofSize: CGSize(width: contentRect.width - XHBRadioButton.iconSize - XHBRadioButton.textPadding, height: XHBRadioButton.height))
    }
    
    func updateStates() {
        var states = self.state
        if checked {
            states = states.union(.STATE_CHECKED)
        }
        self.setTitleColor(XHBRadioButton.backgroundBorderColor.color(for: states), for: .normal)
        backgroundLayer.borderColor = XHBRadioButton.backgroundBorderColor.color(for: states).cgColor
        backgroundLayer.backgroundColor = XHBRadioButton.backgroundFillColor.color(for: states).cgColor
        foregroundLayer.backgroundColor = XHBRadioButton.foregroundFillColor.color(for: states).cgColor
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        self.checked = !self.checked
        updateStates()
        sendActions(for: .valueChanged)
    }
}
