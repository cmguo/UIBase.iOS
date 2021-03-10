//
//  XHBTextAreaController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase
import SnapKit
import SwiftSVG

class XHBTextAreaController: ComponentController {

    class Styles : ViewStyles {
        @objc var maximumCharCount = 100
        @objc var minimunHeight: CGFloat = 100
        @objc var maximunHeight: CGFloat = 300
        @objc var placeholder = "请输入"
        @objc var showBorder = false
        @objc var showLeftIcon = false
        @objc var showRightIcon = false

        override class func descsForStyle(name: String) -> NSArray? {
            switch name {
            case "maximumCharCount":
                return ["最大字数", "设为0不限制；如果有限制，将展现字数指示"]
            case "minimunHeight":
                return ["最小高度", "没有文字时的高度"]
            case "maximunHeight":
                return ["最大高度", "高度随文字变化，需要指定最大高度；包含字数指示（如果有的话）"]
            case "placeholder":
                return ["占位文字", "没有任何输入文字时，显示的占位文字（灰色）"]
            case "showBorder":
                return ["显示边框", "设置是否显示边框"]
            case "showLeftIcon":
                return ["显示左图", "设置是否显示左边的图标"]
            case "showRightIcon":
                return ["显示右图", "设置是否显示右边的图标"]
            default:
                return nil
            }
        }
    }
    
    class Model : ViewModel {
        let text = ""
        let leftIcon = CALayer(svgURL: Bundle(for: Model.self).url(forResource: "union", withExtension: "svg")!) { (layer: SVGLayer) in
            layer.superlayer?.bounds = layer.boundingBox
        }
        let rightIcon = CALayer(svgURL: Bundle(for: Model.self).url(forResource: "erase", withExtension: "svg")!) { (layer: SVGLayer) in
            layer.superlayer?.bounds = layer.boundingBox
       }
    }
    
    private let styles = Styles()
    private let model = Model()
    private let textArea = XHBTextArea(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    
    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.backgroundColor = .yellow
        textArea.minHeight = styles.minimunHeight
        textArea.maxHeight = styles.maximunHeight
        textArea.maxWords = styles.maximumCharCount
        textArea.placeholder = styles.placeholder
        textArea.showBorder = styles.showBorder
        view.addSubview(textArea)
        textArea.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(textArea.frame.height)
        }

        styles.listen { (name: String) in
            if name == "maximumCharCount" {
                self.textArea.maxWords = self.styles.maximumCharCount
            } else if name == "minimunHeight" {
                self.textArea.minHeight = self.styles.minimunHeight
            } else if name == "maximunHeight" {
                self.textArea.maxHeight = self.styles.maximunHeight
            } else if name == "placeholder" {
                self.textArea.placeholder = self.styles.placeholder
            } else if name == "showBorder" {
                self.textArea.showBorder = self.styles.showBorder
            } else if name == "showLeftIcon" {
                self.textArea.leftIcon = self.styles.showLeftIcon ? self.model.leftIcon : nil
            } else if name == "showRightIcon" {
                self.textArea.rigthIcon = self.styles.showRightIcon ? self.model.rightIcon : nil
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        textArea.snp.updateConstraints { (maker) in
            maker.height.equalTo(textArea.bounds.height)
        }
    }
}

