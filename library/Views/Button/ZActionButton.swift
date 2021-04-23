//
//  XHBActionButton.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/4/23.
//

import Foundation

public class XHBActionButton : XHBButton {
    
    private let _wrapLayer = CALayer()
    
    public override init(style: XHBButtonStyle = .defaultStyle) {
        super.init(style: style)
        _wrapLayer.backgroundColor = UIColor.bluegrey_100.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func postHandleIcon() {
        let layer = imageView!.layer
        if let layers = layer.sublayers, !layers.isEmpty  {
            for l in layers {
                l.removeFromSuperlayer()
            }
            let bounds = imageView!.bounds
            layer.addSublayer(_wrapLayer)
            _wrapLayer.frame = bounds
            _wrapLayer.cornerRadius = sizeStyles.iconSize / 2
            for l in layers {
                layer.addSublayer(l)
                if let layers2 = l.sublayers {
                    for l2 in layers2 {
                        let scale = l2.transform.m11
                        var frame = bounds.centerPart(ofSize: CGSize(width: bounds.width / scale, height: bounds.height / scale))
                        l2.transform = CATransform3DMakeScale(1, 1, 1)
                        l.frame = frame
                        frame.moveLeftTopTo(.zero)
                        l2.frame = frame
                    }
                }
            }
        }
    }
}
