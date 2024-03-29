//
//  ZTextInputController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIBase
import SnapKit

class ZTextInputController: ComponentController, ZTextInputDelegate, ZTextAreaDelegate {

    class Styles : ViewStyles {
        
        @objc static let _maxWordCount = ["最大字数", "设为0不限制；如果有限制，将展现字数指示"]
        @objc var maxWordCount = 100
        
        @objc static let _placeholder = ["占位文字", "没有任何输入文字时，显示的占位文字（灰色）"]
        @objc var placeholder = "请输入"
        
        @objc static let _showBorder = ["显示边框", "设置是否显示边框"]
        @objc var showBorder = false
        
        @objc static let _leftIcon = ["左图标", "设置左边的图标，URL 类型，控件内部会自动重新布局"]
        @objc static let _leftIconStyle: NSObject = IconStyle(Styles.self, "leftIcon")
        @objc var leftIcon: URL? = nil
        
        @objc static let _rightIcon = ["右图标", "设置右边的图标，URL 类型，控件内部会自动重新布局"]
        @objc static let _rightIconStyle: NSObject = IconStyle(Styles.self, "rightIcon")
        @objc var rightIcon: URL? = nil
    }
    
    class Model : ViewModel {
        let text = ""
    }
    
    private let styles = Styles()
    private let model = Model()
    private let textInput = ZTextInput()
    private let textArea = ZTextArea(single: true)

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue_100

        textInput.maxWordCount = styles.maxWordCount
        textInput.placeholder = styles.placeholder
        textInput.singleLine = true
        //textInput.showBorder = styles.showBorder
        //textInput.delegate = self
        view.addSubview(textInput)
        textInput.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.top.equalToSuperview().offset(150)
            //maker.height.equalTo(textInput.frame.height)
        }

        textArea.backgroundColor = .white
        textArea.maxWords = styles.maxWordCount
        textArea.placeholder = styles.placeholder
        textArea.showBorder = styles.showBorder
        textArea.delegate = self
        view.addSubview(textArea)
        textArea.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
            maker.top.equalTo(textInput.snp.bottom).offset(50)
            maker.height.equalTo(textArea.frame.height)
        }

        styles.listen { (name: String) in
            if name == "maxWordCount" {
                self.textInput.maxWordCount = self.styles.maxWordCount
                self.textArea.maxWords = self.styles.maxWordCount
            } else if name == "placeholder" {
                self.textInput.placeholder = self.styles.placeholder
                self.textArea.placeholder = self.styles.placeholder
            } else if name == "showBorder" {
                //self.textInput.showBorder = self.styles.showBorder
                self.textArea.showBorder = self.styles.showBorder
            } else if name == "leftIcon" {
                self.textInput.leftButton = self.styles.leftIcon
            } else if name == "rightIcon" {
                self.textInput.rightButton = self.styles.rightIcon
            }
        }
    }
    
    func textInput(_ textArea: ZTextInput, buttonTapped id: ZButton.ButtonId) {
        ZTipView.tip(textArea, "点击了按钮 \(id)", .topCenter)
    }

    func textAreaIconTapped(_ textArea: ZTextArea, index: Int) {
        ZTipView.tip(textArea, "点击了图标\(index)", .topCenter)
    }
   
    override func viewWillLayoutSubviews() {
        textArea.snp.updateConstraints { (maker) in
            maker.height.equalTo(textArea.bounds.height)
        }
    }
    
}

