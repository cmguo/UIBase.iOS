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
    
    // textColor, textColorDisabled, backgroundColor, backgroundColorPressed, backgroundColorDisabled, radius
    private static let typeStyles: [ButtonType: (UIColor, UIColor, UIColor, UIColor, UIColor, CGFloat)] = [
        .Primitive: (ThemeColor.shared.static_bluegrey_900, ThemeColor.shared.bluegrey_500,
                     ThemeColor.shared.brand_500, ThemeColor.shared.brand_600, ThemeColor.shared.bluegrey_100, 100),
        .Secondary: (ThemeColor.shared.static_bluegrey_900, ThemeColor.shared.bluegrey_500,
                     ThemeColor.shared.brand_500, ThemeColor.shared.brand_600, ThemeColor.shared.bluegrey_100, 100),
        .Tertiary: (ThemeColor.shared.static_bluegrey_900, ThemeColor.shared.bluegrey_500,
                    ThemeColor.shared.brand_500, ThemeColor.shared.brand_600, ThemeColor.shared.bluegrey_100, 100),
        .Danger: (ThemeColor.shared.static_bluegrey_900, ThemeColor.shared.bluegrey_500,
                  ThemeColor.shared.brand_500, ThemeColor.shared.brand_600, ThemeColor.shared.bluegrey_100, 100),
        .TextLink: (ThemeColor.shared.static_bluegrey_900, ThemeColor.shared.bluegrey_500,
                    ThemeColor.shared.brand_500, ThemeColor.shared.brand_600, ThemeColor.shared.bluegrey_100, 100)
    ]
    
    // height, padding(left, rigth), textSize, iconPadding
    private static let sizeStyles: [ButtonSize: (CGFloat, CGFloat, CGFloat, CGFloat)] = [
        .Large: (44, 24, 18, 5),
        .Middle: (36, 16, 16, 4),
        .Small: (24, 12, 14, 3)
    ]
    
    // MARK: - Public variables
    /**
     Current loading state.
     */
    public var isLoading: Bool = false

    /**
     The corner radius of the button
     */
    @IBInspectable open var cornerRadius: CGFloat = 12.0 {
        didSet {
            self.clipsToBounds = (self.cornerRadius > 0)
            self.layer.cornerRadius = self.cornerRadius
        }
    }

    /**
     The loading indicator used with the button.
     */
    open var indicator: UIView & IndicatorProtocol = UIActivityIndicatorView()

    // Private properties
    private var loaderWorkItem: DispatchWorkItem?

    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /**
     Convenience init of theme button with required information
     
     - Parameter type:      the icon of the button, it is be nil by default.
     - Parameter sizeMode:  the size mode of the button.
     - Parameter widthMode: the width mode of the button.
     - Parameter icon:      the icon of the button, it is be nil by default.
     - Parameter text:      the title of the button.
     */
    public init(
        frame: CGRect = .zero,
        type: ButtonType = .Primitive,
        sizeMode: ButtonSize = .Large,
        widthMode: ButtonWidth = .WrapContent,
        icon: UIImage? = nil,
        text: String? = nil
    ) {
        let typeStyles = XHBButton.typeStyles[type]!
        let sizeStyles = XHBButton.sizeStyles[sizeMode]!
        var frame = frame
        frame.size.height = sizeStyles.0
        super.init(frame: frame)
        
        self.setTitleColor(typeStyles.0, for: .normal)
        self.setTitleColor(typeStyles.1, for: .disabled)
        self.backgroundColor = typeStyles.2
        //self.setBackgroundImage(UIImage(typeStyles.4), for: .disabled)
        self.setCornerBorder(cornerRadius: typeStyles.5)
        self.cornerRadius = typeStyles.5

        //let font = UIFont().withSize(sizeStyles.2);
        //self.titleLabel?.font = font
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: sizeStyles.0, bottom: 0, right: sizeStyles.0)

        // Set button contents
        // Set the title of the button
        if let text = text {
            self.setTitle(text)
        }
        // Set the icon of the button
        if let icon = icon {
            self.setImage(icon)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    open func showLoader(_ viewsToBeHidden: [UIView?], userInteraction: Bool = false) {
        guard !self.subviews.contains(indicator) else { return }
        // Set up loading indicator and update loading state
        isLoading = true
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
            // Update loading state
            self.isLoading = false
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
