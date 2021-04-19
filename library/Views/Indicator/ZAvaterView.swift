//
//  XHBAvaterView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/16.
//

import Foundation

public class XHBAvaterView : UIImageView {
    
    enum ClipType {
        case None
        case Circle
        case Ellipse
        case RoundSquare
        case RoundRect
    }

    enum ClipRegion {
        case WholeView
        case Drawable
    }

    var clipType = ClipType.Circle {
        didSet {
            computeRoundBounds()
        }
    }
    
    var clipRegion = ClipRegion.Drawable {
        didSet {
            computeRoundBounds()
        }
    }

    var roundRadius: CGFloat = 0 {
        didSet {
            
        }
    }

    var borderColor: UIColor = .white {
        didSet {
            
        }
    }

    var borderWidth: CGFloat = 0 {
        didSet {
            
        }
    }

    public override init(image: UIImage? = nil) {
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func computeRoundBounds() {
        
    }
    
}
