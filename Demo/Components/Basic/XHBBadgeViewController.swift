//
//  XHBButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase

class XHBBadgeViewController: ComponentController {

    class Styles : ViewStyles {
        
        @objc static let _borderWidth = ["边框宽度", "加上边框；如果徽标显示在复杂图形上或者带有强烈色彩的图标上，建议具有1px容器背景色（通常为白色）的描边。"]
        var borderWidth: CGFloat = 0.5

        @objc static let _gravity = ["对齐方式", "对齐到哪个角落，9个点；可结合位置偏移来精确定位；默认右上角"]
        @objc static let _gravityStyle = GravityStyle(Styles.self, "gravity")
        @objc var gravity = Gravity.RIGHT_TOP

        @objc static let _offset = ["位置偏移", "相对于对齐点的偏移量，向中心偏移；如果某一边是中间对齐，则这边无法再调整"]
        @objc var offset = CGSize.zero

        @objc static let _draggabe = ["拖拽删除", "通过拖拽小圆点，可以将其删除，拖拽过程中会有事件回调"]
        @objc var draggabe = false

        @objc static let _dragRadius = ["拖拽距离", "最大拖拽半径，当超过该范围时松开，可以将其删除，拖拽过程中会有事件回调"]
        @objc var dragRadius = 90

        @objc static let _maximum = ["最大数值", "如果数值超过最大数值，展示为XX+，XX为最大数值"]
        @objc var maximum = 0

        @objc static let _number = ["数字", "改变数字，实际作用是改变文字；但是在非精确模式下，会作调整"]
        @objc var number = 1

        @objc static let _text = ["文字", "改变文字，小圆点会自动适应文字宽度"]
        @objc var text = "1"
    }
    
    class Model : ViewModel {
    }
    
    private let styles = Styles()
    private let model = Model()
    private let label = UILabel()
    private let imageView = UIImageView()
    private let button = XHBButton()
    private var badges = [XHBBadgeView]()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label.backgroundColor = .yellow
        label.text = "文字"
        view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.width.equalTo(150)
            maker.top.equalToSuperview().offset(150)
        }
        attachBadge(label)

        imageView.image = UIImage(withUrl: Icons.pngURL("img_share_weixin")!)
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.top.equalTo(label.snp.bottom).offset(20)
            maker.width.equalTo(150)
            maker.height.equalTo(150)
        }
        attachBadge(imageView)

        button.text = "按钮"
        button.clipsToBounds = false
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(20)
            maker.top.equalTo(imageView.snp.bottom).offset(20)
        }
        attachBadge(button)

        styles.listen { (name: String) in
            if name == "borderWidth" {
                for b in self.badges { b.borderWidth = self.styles.borderWidth }
            } else if name == "gravity" {
                for b in self.badges { b.gravity = self.styles.gravity }
//            } else if name == "offset" {
//                for b in self.badges { /* b.offset = self.styles.offset */ }
//            } else if name == "dragable" {
//                for b in self.badges { /* b.dragable = self.styles.dragable */ }
//            } else if name == "dragRadius" {
//                for b in self.badges { /* b.dragRadius = self.styles.dragRadius */ }
            } else if name == "text" {
                for b in self.badges { b.text = self.styles.text }
            } else if name == "number" {
                for b in self.badges { b.number = self.styles.number }
            } else if name == "maximum" {
                for b in self.badges { b.maximum = self.styles.maximum }
            }
        }
    }

    private func attachBadge(_ view: UIView) {
        let badge = XHBBadgeView()
        badge.text = styles.text
        badge.maximum = styles.maximum
        badge.number = styles.number
        badge.attach(view)
        badges.append(badge)
    }
}

