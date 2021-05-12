//
//  ZButtonController.swift
//  demo
//
//  Created by 郭春茂 on 2021/4/19.
//

import Foundation
import UIKit
import UIBase

class ZAvatarViewController: ComponentController {

    class Styles : ViewStyles {
        
        @objc static let _clipType = ["剪切方式", "剪切图片的方式，有 None，Circle，Ellipse，RoundSquare，RoundRect五种方式，默认Circle方式"]
        @objc static let _clipTypeStyle: NSObject = EnumStyle(Styles.self, "clipType", ZAvatarView.ClipType.self)
        @objc var clipType = ZAvatarView.ClipType.Circle.rawValue

        @objc static let _clipRegion = ["剪切区域", "剪切区域，有视图区域（WholeView）、图片区域（Drawable）两种方式"]
        @objc static let _clipRegionStyle: NSObject = EnumStyle(Styles.self, "clipRegion", ZAvatarView.ClipRegion.self)
        @objc var clipRegion = ZAvatarView.ClipRegion.Drawable.rawValue

        @objc static let _roundRadius = ["剪切半径", "圆角剪切时，剪切圆角半径，设为0，则为直角"]
        @objc var roundRadius: CGFloat = 0

        @objc static let _borderWidth = ["边框宽度", "设置头像边框宽度，设为0，则没有边框"]
        @objc var borderWidth: CGFloat = 0.5

        @objc static let _borderColor = ["边框颜色", "设置头像边框颜色"]
        @objc static let _borderColorStyle = ColorStyle(Styles.self, "borderColor")
        @objc var borderColor = UIColor.red
        
        var clipRegion2: ZAvatarView.ClipRegion {
            ZAvatarView.ClipRegion.init(rawValue: clipRegion)!
        }
        
        var clipType2: ZAvatarView.ClipType {
            ZAvatarView.ClipType.init(rawValue: clipType)!
        }
    }
    
    class Model : ViewModel {
    }
    
    private let styles = Styles()
    private let model = Model()
    private let imageView = ZAvatarView()
    private var views = [ZAvatarView]()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(withUrl: Icons.jpgURL("component")!)
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(250)
            maker.height.equalTo(150)
        }
        views.append(imageView)


        styles.listen { (name: String) in
            if name == "borderWidth" {
                for b in self.views { b.borderWidth = self.styles.borderWidth }
            } else if name == "borderColor" {
                for b in self.views { b.borderColor = self.styles.borderColor }
            } else if name == "clipRegion" {
                for b in self.views { b.clipRegion = self.styles.clipRegion2 }
            } else if name == "clipType" {
                for b in self.views { b.clipType = self.styles.clipType2 }
            } else if name == "roundRadius" {
                for b in self.views { b.roundRadius = self.styles.roundRadius }
            }
        }
    }

}

