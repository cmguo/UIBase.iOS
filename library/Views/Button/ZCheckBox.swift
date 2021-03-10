//
//  XHBCheckBox.swift
//  UIBase
//
//  Created by 郭春茂 on 2021/3/8.
//

import Foundation
import SwiftSVG

@IBDesignable
public class XHBCheckBox: UIButton {
    
    private static let fillColor = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_100, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.brand_500, StateColor.STATES_CHECKED),
        StateColor(ThemeColor.shared.brand_500, StateColor.STATES_HALF_CHECKED),
        StateColor(ThemeColor.shared.bluegrey_00, StateColor.STATES_NORMAL)
    ])
    
    private static let borderColor = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_300, StateColor.STATES_DISABLED),
        StateColor(ThemeColor.shared.brand_500, StateColor.STATES_CHECKED),
        StateColor(ThemeColor.shared.brand_500, StateColor.STATES_HALF_CHECKED),
        StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_NORMAL)
    ])
    
    private static let foregroundCheckedFillColor = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED_CHECKED),
        StateColor(ThemeColor.shared.bluegrey_00, StateColor.STATES_CHECKED),
        StateColor(ThemeColor.shared.transparent, StateColor.STATES_NORMAL)
    ])
        
    private static let foregroundHalfCheckedFillColor = StateListColor([
        StateColor(ThemeColor.shared.bluegrey_500, StateColor.STATES_DISABLED_HALF_CHECKED),
        StateColor(ThemeColor.shared.bluegrey_00, StateColor.STATES_HALF_CHECKED),
        StateColor(ThemeColor.shared.transparent, StateColor.STATES_NORMAL)
    ])
        
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

        self.setImage(UIImage.from(color: ThemeColor.shared.transparent))
        self.imageView?.layer.cornerRadius = XHBCheckBox.radius
        self.imageView?.layer.borderWidth = XHBCheckBox.borderSize
        
        let foregroundLayerChecked = CALayer(svgURL: XHBCheckBox.svg_checked) { (layer: SVGLayer) in
            layer.frame = layer.boundingBox.centeredAt(CGPoint(x: XHBCheckBox.iconSize / 2, y: XHBCheckBox.iconSize / 2))
            layer.fillColor = ThemeColor.shared.transparent.cgColor
            DispatchQueue.main.async {
                self.foregroundLayerChecked = layer
                layer.fillColor = XHBCheckBox.foregroundCheckedFillColor.color(for: self.states()).cgColor
            }
        }
        self.imageView?.layer.addSublayer(foregroundLayerChecked)
        
        let foregroundLayerHalfChecked = CALayer(svgURL: XHBCheckBox.svg_half_checked) { (layer: SVGLayer) in
            layer.frame = layer.boundingBox.centeredAt(CGPoint(x: XHBCheckBox.iconSize / 2, y: XHBCheckBox.iconSize / 2))
            layer.fillColor = ThemeColor.shared.transparent.cgColor
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
        
        addTarget(self, action: Selector("buttonClicked:"), for: .touchUpInside)
        
        updateStates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: (contentRect.height - XHBCheckBox.iconSize) / 2, width: XHBCheckBox.iconSize, height: XHBCheckBox.iconSize)
    }
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: XHBCheckBox.iconSize + XHBCheckBox.textPadding, y: 0, width: contentRect.width, height: XHBCheckBox.height)
    }
    
    private func states() -> Int {
        var states = StateColor.STATES_NORMAL
        switch checkedState {
        case .NotChecked:
            break
        case .HalfChecked:
            states |= StateColor.STATE_HALF_CHECKED
        case .FullChecked:
            states |= StateColor.STATE_CHECKED
        }
        if !isEnabled {
            states |= StateColor.STATE_DISABLED
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
        if self.checkedState == .FullChecked {
            self.checkedState = .NotChecked
        } else {
            self.checkedState = .FullChecked
        }
        updateStates()
        sendActions(for: .valueChanged)
    }
}
