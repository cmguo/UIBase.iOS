//
//  XHBAvatarView.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/16.
//

import Foundation

public class XHBAvatarView : UIImageView {
    
    public enum ClipType : Int, RawRepresentable, CaseIterable {
        case None
        case Circle
        case Ellipse
        case RoundSquare
        case RoundRect
    }

    public enum ClipRegion : Int, RawRepresentable, CaseIterable {
        case WholeView
        case Drawable
    }

    public var clipType = ClipType.Circle {
        didSet {
            syncClipBounds()
        }
    }
    
    public var clipRegion = ClipRegion.Drawable {
        didSet {
            syncClipBounds()
        }
    }

    public var roundRadius: CGFloat = 0 {
        didSet {
            if clipType == .RoundRect || clipType == .RoundSquare {
                layer.cornerRadius = roundRadius
            }
        }
    }

    public var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    public override init(image: UIImage? = nil) {
        super.init(image: image)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func syncClipBounds() {
        if (clipType == .None) {
            layer.bounds = self.bounds
            return
        }
        var vsize = self.bounds.size
        if clipRegion == .Drawable, let image = image, contentMode == .scaleAspectFit {
            let isize = image.size
            if isize.width * vsize.height > isize.height * vsize.width {
                vsize.height = isize.height * vsize.width / isize.width
            } else {
                vsize.width = isize.width * vsize.height / isize.height
            }
        }
        if clipType == .Circle || clipType == .RoundSquare {
            if vsize.width > vsize.height {
                vsize.width = vsize.height
            } else {
                vsize.height = vsize.width
            }
        }
        if (clipType == .Circle || clipType == .Ellipse) {
            // TODO: Ellipse shape
            layer.cornerRadius = vsize.width / 2
        }
        layer.bounds = self.bounds.centerPart(ofSize: vsize)
    }
    
}
