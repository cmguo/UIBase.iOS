//
//  XHBNumberViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/1.
//

import Foundation
import UIBase

class XHBNumberViewController: ComponentController {

    class Styles : ViewStyles {
        
        @objc static let _minimun = ["最小数量", "最小输入数量；默认0"]
        @objc var minimum = 0

        @objc static let _maximun = ["最大数量", "最大输入数量；设置0，则不限制数量；默认为0"]
        @objc var maximum = 0

        @objc static let _step = ["步进距离", "每次点击增减的数量"]
        @objc var step = 1

        @objc static let _wraps = ["循环步进", "当数量超出时，是否循环到另一端"]
        @objc var wraps = false

        @objc static let _autoRepeat = ["自动重复", "当一直按着按钮时，自动重复改变数值"]
        @objc var autoRepeat = true

        @objc static let _continues = ["持续通知", "当一直按着按钮时，持续通知数值变化"]
        @objc var continues = true

        @objc static let _number = ["数量", "当前输入的数量"]
        @objc var number = 0 {
            didSet { notify("number") }
        }
    }
    
    class Model : ViewModel {
    }
    
    private let styles = Styles()
    private let model = Model()
    private let numberView = XHBNumberView()
    private var views = [XHBNumberView]()

    private let label = UILabel()
    private let text = UILabel()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        label.text = "当前数值"
        view.addSubview(label)
        view.addSubview(text)
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(120)
            maker.bottom.equalToSuperview().offset(-100)
        }
        text.snp.makeConstraints { (maker) in
            maker.top.equalTo(label.snp.top)
            maker.leading.equalTo(label.snp.trailing).offset(20)
        }
        
        numberView.autoRepeat = styles.autoRepeat
        numberView.addTarget(self, action: #selector(numberChanged(_:)), for: .valueChanged)
        view.addSubview(numberView)
        numberView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(250)
            maker.height.equalTo(150)
        }
        views.append(numberView)


        styles.listen { (name: String) in
            if name == "maximum" {
                for b in self.views { b.maximum = self.styles.maximum }
            } else if name == "minimum" {
                for b in self.views { b.minimum = self.styles.minimum }
            } else if name == "step" {
                for b in self.views { b.step = self.styles.step }
            } else if name == "wraps" {
                for b in self.views { b.wraps = self.styles.wraps }
            } else if name == "autoRepeat" {
                for b in self.views { b.autoRepeat = self.styles.autoRepeat }
            } else if name == "continues" {
                for b in self.views { b.continues = self.styles.continues }
            } else if name == "number" {
                for b in self.views { b.number = self.styles.number }
            }
        }
    }
    
    @objc private func numberChanged(_ sender: UIView) {
        text.text = String(numberView.number)
    }

}

