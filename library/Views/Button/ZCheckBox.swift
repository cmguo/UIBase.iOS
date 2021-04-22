//
//  XHBCheckBox.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation
import SwiftSVG

public class XHBCheckBox: UIButton {
    
    private static let fillColor = StateListColor.bluegrey_00_checked_disabled
    
    private static let borderColor = StateListColor.bluegrey_500_checked_disabled
    
    private static let foregroundCheckedFillColor = StateListColor.transparent_checked_disabled
    
    private static let foregroundHalfCheckedFillColor = StateListColor.transparent_halfchecked_disabled
    
    private static let height: CGFloat = 24.0
    private static let radius: CGFloat = 4.0
    private static let borderSize: CGFloat = 2.0
    private static let iconSize: CGFloat = 18.0
    private static let textPadding: CGFloat = 7.0
    
    private static let svg_checked = Bundle(for: XHBCheckBox.self).url(forResource: "checked", withExtension: "svg")!
    private static let svg_half_checked = Bundle(for: XHBCheckBox.self).url(forResource: "half_checked", withExtension: "svg")!

    public enum CheckedState : Int, RawRepresentable, CaseIterable {
        case NotChecked
        case HalfChecked
        case FullChecked
    }
    
    public var checkedState: CheckedState = CheckedState.NotChecked {
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
    
    private var foregroundLayerChecked = CALayer()
    private var foregroundLayerHalfChecked = CALayer()


    public init(text: String? = nil) {
        super.init(frame: CGRect.zero)
        
        var frame = CGRect(x: 0, y: 0, width: XHBCheckBox.iconSize, height: XHBCheckBox.height)
        self.frame = frame

        self.setImage(UIImage.transparent)
        self.imageView?.layer.cornerRadius = XHBCheckBox.radius
        self.imageView?.layer.borderWidth = XHBCheckBox.borderSize
        
        let foregroundLayerChecked = CALayer(svgURL: XHBCheckBox.svg_checked) { (layer: SVGLayer) in
            layer.frame = layer.boundingBox.centeredAt(CGPoint(x: XHBCheckBox.iconSize / 2, y: XHBCheckBox.iconSize / 2))
            layer.fillColor = UIColor.clear.cgColor
            DispatchQueue.main.async {
                self.foregroundLayerChecked = layer
                layer.fillColor = XHBCheckBox.foregroundCheckedFillColor.color(for: self.states()).cgColor
            }
        }
        self.imageView?.layer.addSublayer(foregroundLayerChecked)
        
        let foregroundLayerHalfChecked = CALayer(svgURL: XHBCheckBox.svg_half_checked) { (layer: SVGLayer) in
            layer.frame = layer.boundingBox.centeredAt(CGPoint(x: XHBCheckBox.iconSize / 2, y: XHBCheckBox.iconSize / 2))
            layer.fillColor = UIColor.clear.cgColor
            DispatchQueue.main.async {
                self.foregroundLayerHalfChecked = layer
                layer.fillColor = XHBCheckBox.foregroundHalfCheckedFillColor.color(for: self.states()).cgColor
            }
        }
        self.imageView?.layer.addSublayer(foregroundLayerHalfChecked)

        if let text = text {
            self.setTitle(text)
            self.titleLabel?.sizeToFit()
            let size = self.titleLabel!.sizeThatFits(CGSize())
            frame.size.width = frame.width + XHBCheckBox.textPadding + size.width
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
        if self.checkedState == .FullChecked {
            self.checkedState = .NotChecked
        } else {
            self.checkedState = .FullChecked
        }
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.leftCenterPart(ofSize: CGSize(width: XHBCheckBox.iconSize, height: XHBCheckBox.iconSize))
    }
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.rightCenterPart(ofSize: CGSize(width: contentRect.width - XHBCheckBox.iconSize - XHBCheckBox.textPadding, height: XHBCheckBox.height))
    }
    
    private func states() -> UIControl.State {
        var states = self.state
        switch checkedState {
        case .NotChecked:
            break
        case .HalfChecked:
            states = states.union(.STATE_HALF_CHECKED)
        case .FullChecked:
            states = states.union(.STATE_CHECKED)
        }
        return states
    }
    
    private func updateStates() {
        let states = self.states()
        self.setTitleColor(XHBCheckBox.borderColor.color(for: states), for: .normal)
        self.imageView?.layer.borderColor = XHBCheckBox.borderColor.color(for: states).cgColor
        self.imageView?.layer.backgroundColor = XHBCheckBox.fillColor.color(for: states).cgColor
        if let l = foregroundLayerChecked as? SVGLayer {
            l.fillColor = XHBCheckBox.foregroundCheckedFillColor.color(for: states).cgColor
        }
        if let l = foregroundLayerHalfChecked as? SVGLayer {
            l.fillColor = XHBCheckBox.foregroundHalfCheckedFillColor.color(for: states).cgColor
        }
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        toggle()
    }
    
}
