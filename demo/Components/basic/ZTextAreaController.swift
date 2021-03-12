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

class XHBTextAreaController: ComponentController, XHBTextAreaDelegate {

    class Styles : ViewStyles {
        static let icons = ["<null>", "delete", "erase", "union"].map { (i) in
            makeValue(i, i)
        }

        @objc var maximumCharCount = 100
        @objc var minimunHeight: CGFloat = 100
        @objc var maximunHeight: CGFloat = 300
        @objc var placeholder = "请输入"
        @objc var showBorder = false
        @objc var leftIcon: String = "<null>"
        @objc var rightIcon: String = "<null>"

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
            case "leftIcon":
                return ["左图标", "设置左边的图标，URL 类型，控件内部会自动重新布局"]
            case "rightIcon":
                return ["右图标", "设置右边的图标，URL 类型，控件内部会自动重新布局"]
            default:
                return nil
            }
        }
        
        override class func valuesForStyle(name: String) -> NSArray? {
            switch name {
            case "leftIcon", "rightIcon":
                return Styles.icons as NSArray
            default:
                return nil
            }
        }
    }
    
    class Model : ViewModel {
        let text = ""
        let leftIcon = CALayer(svgURL: Bundle(for: Model.self).url(forResource: "union", withExtension: "svg")!) { (layer: SVGLayer) in
            layer.frame = layer.boundingBox
            layer.superlayer?.frame = layer.boundingBox
        }
        let rightIcon = CALayer(svgURL: Bundle(for: Model.self).url(forResource: "erase", withExtension: "svg")!) { (layer: SVGLayer) in
            layer.frame = layer.boundingBox
            layer.superlayer?.frame = layer.boundingBox
       }
    }
    
    private let styles = Styles()
    private let model = Model()
    private let textInput = XHBTextArea(single: true)
    private let textArea = XHBTextArea()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textInput.backgroundColor = .yellow
        textInput.maxWords = styles.maximumCharCount
        textInput.placeholder = styles.placeholder
        textInput.showBorder = styles.showBorder
        textInput.delegate = self
        view.addSubview(textInput)
        textInput.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview().offset(150)
            maker.height.equalTo(textInput.frame.height)
        }

        textArea.backgroundColor = .yellow
        textArea.minHeight = styles.minimunHeight
        textArea.maxHeight = styles.maximunHeight
        textArea.maxWords = styles.maximumCharCount
        textArea.placeholder = styles.placeholder
        textArea.showBorder = styles.showBorder
        textArea.delegate = self
        view.addSubview(textArea)
        textArea.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(textInput.snp.bottom).offset(50)
            maker.height.equalTo(textArea.frame.height)
        }

        styles.listen { (name: String) in
            if name == "maximumCharCount" {
                self.textInput.maxWords = self.styles.maximumCharCount
                self.textArea.maxWords = self.styles.maximumCharCount
            } else if name == "minimunHeight" {
                self.textArea.minHeight = self.styles.minimunHeight
            } else if name == "maximunHeight" {
                self.textArea.maxHeight = self.styles.maximunHeight
            } else if name == "placeholder" {
                self.textInput.placeholder = self.styles.placeholder
                self.textArea.placeholder = self.styles.placeholder
            } else if name == "showBorder" {
                self.textInput.showBorder = self.styles.showBorder
                self.textArea.showBorder = self.styles.showBorder
            } else if name == "leftIcon" {
                self.textInput.leftIcon = Bundle(for: Model.self).url(forResource: self.styles.leftIcon, withExtension: "svg")
            } else if name == "rightIcon" {
                self.textInput.rigthIcon = Bundle(for: Model.self).url(forResource: self.styles.rightIcon, withExtension: "svg")
            }
        }
    }
   
    func textAreaIconTapped(_ textArea: XHBTextArea, index: Int) {
        XHBToolTip.tip(textArea, "点击了图标\(index)")
    }
   
    override func viewWillLayoutSubviews() {
        textArea.snp.updateConstraints { (maker) in
            maker.height.equalTo(textArea.bounds.height)
        }
    }
}

