//
//  UIButton.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/1.
//

import Foundation

// MARK: - UIButton
extension UIButton {
    /**
     Set button image for all button states
     
     - Parameter image: The image to be set to the button.
     */
    open func setImage(_ image: UIImage?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setImage(image, for: state)
        }
    }
    /**
     Set button title for all button states
     
     - Parameter text: The text to be set to the button title.
     */
    open func setTitle(_ text: String?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setTitle(text, for: state)
        }
        superview?.setNeedsLayout()
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        if let image = UIImage.from(color: color) {
            self.setBackgroundImage(image, for: forState)
        }
    }
}
