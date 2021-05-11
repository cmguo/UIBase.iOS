//
//  Self.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

@IBDesignable
public class XHBRadioButton: UIButton {
    
    private static let backgroundFillColor = StateListColor.bluegrey_00_disabled
    
    private static let backgroundBorderColor = StateListColor.bluegrey_500_checked_disabled
    
    private static let foregroundFillColor = StateListColor.transparent_checked_disabled2
        
    private static let height: CGFloat = 24.0
    private static let iconSize: CGFloat = 18.0
    private static let radius: CGFloat = 9.0
    private static let borderSize: CGFloat = 2.0
    private static let borderSize2: CGFloat = 4.0
    private static let textPadding: CGFloat = 7.0
    
    public var checked: Bool = false {
        didSet {
            updateStates()
            sendActions(for: .valueChanged)
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
        
        var frame = CGRect(x: 0, y: 0, width: Self.iconSize, height: Self.height)
        self.frame = frame

        self.setImage(UIImage.from(color: .clear))
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: Self.iconSize, height: Self.iconSize)
        backgroundLayer.cornerRadius = Self.radius
        backgroundLayer.borderWidth = Self.borderSize
        self.imageView?.layer.addSublayer(backgroundLayer)

        foregroundLayer.frame = CGRect(x: Self.borderSize2, y: Self.borderSize2, width: Self.iconSize - Self.borderSize2 * 2, height: Self.iconSize - Self.borderSize2 * 2)
        foregroundLayer.cornerRadius = Self.radius - Self.borderSize2
        foregroundLayer.borderWidth = 0
        self.imageView?.layer.addSublayer(foregroundLayer)

        if let text = text, !text.isEmpty {
            self.setTitle(text)
            self.titleLabel?.sizeToFit()
            let size = self.titleLabel!.sizeThatFits(CGSize())
            frame.size.width = frame.width + Self.textPadding + size.width
        }

        self.frame = frame
        
        addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)

        updateStates()
        _ = updateSizeConstraint(nil, frame.size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func toggle() {
        if (checked) { return }
        checked = true
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.leftCenterPart(ofSize: CGSize(width: Self.iconSize, height: Self.iconSize))
    }
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.rightCenterPart(ofSize: CGSize(width: contentRect.width - Self.iconSize - Self.textPadding, height: Self.height))
    }
    
    public override func sizeToFit() {
        var size = CGSize(width: Self.iconSize, height: Self.height)
        if currentTitle != nil && !currentTitle!.isEmpty {
            self.titleLabel?.sizeToFit()
            let tsize = self.titleLabel!.sizeThatFits(CGSize())
            size.width += Self.textPadding + tsize.width
        }
        bounds.size = size
    }
    
    func updateStates() {
        var states = self.state
        if checked {
            states = states.union(.STATE_CHECKED)
        }
        self.setTitleColor(Self.backgroundBorderColor.color(for: states), for: .normal)
        backgroundLayer.borderColor = Self.backgroundBorderColor.color(for: states).cgColor
        backgroundLayer.backgroundColor = Self.backgroundFillColor.color(for: states).cgColor
        foregroundLayer.backgroundColor = Self.foregroundFillColor.color(for: states).cgColor
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        toggle()
    }
}
