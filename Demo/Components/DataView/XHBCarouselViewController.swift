//
//  XHBCarouselViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/6.
//

import Foundation
import UIBase

class XHBCarouselViewController: ComponentController, XHBCarouselViewDelegate {

    class Styles : ViewStyles {
        
        @objc static let _slideDirection = ["滚动方向", "默认横向滚动"]
        @objc static let _slideDirectionStyle: NSObject = EnumStyle(Styles.self, "slideDirection", XHBCarouselView.SlideDirection.self)
        @objc var slideDirection = 0

        @objc static let _slideInterval = ["间隔时间", "两次自动滚动的间隔时间，设为 0 不自动滚动"]
        @objc var slideInterval: CGFloat = 2

        @objc static let _itemSpacing = ["图片间距", "相邻两张图片之间的间距"]
        @objc var itemSpacing: CGFloat = 0
        
        @objc static let _manualSlidable = ["允许滚动", "是否允许手动滚动"]
        @objc var manualSlidable = false
        
        @objc static let _cyclic = ["循环滚动", "是否循环滚动，好像有无限张图片"]
        @objc var cyclic = true
        
        @objc static let _slideAnimType = ["翻页动效", "翻页的动画效果"]
        @objc static let _slideAnimTypeStyle: NSObject = EnumStyle(Styles.self, "slideAnimType", XHBCarouselView.SlideAnimType.self)
        @objc var slideAnimType: Int = 0
        
        var slideDirection2: XHBCarouselView.SlideDirection {
            XHBCarouselView.SlideDirection(rawValue: slideDirection)!
        }

        var slideAnimType2: XHBCarouselView.SlideAnimType {
            XHBCarouselView.SlideAnimType(rawValue: slideAnimType)!
        }
    }
    
    class Model : ViewModel, XHBCarouselViewDataSource {
        
        let images = [
            Icons.jpgURL("carousel1"),
            Icons.jpgURL("carousel2"),
            Icons.jpgURL("carousel3")
        ]

        func numberOfItems(in carouselView: XHBCarouselView) -> Int {
            return images.count
        }
        
        func carouselView(_ carouselView: XHBCarouselView, imageForItemAt index: Int) -> UIImage {
            return UIImage(withUrl: images[index]!)!
        }
        
        //let
    }
    
    private let styles = Styles()
    private let model = Model()
    private let carouselView = XHBCarouselView()
    private var views = [XHBCarouselView]()

    private let label = UILabel()
    private let text = UILabel()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "当前图片"
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
        
        carouselView.dataSource2 = model
        carouselView.delegate2 = self
        carouselView.slideInterval = styles.slideInterval
        carouselView.cyclic = styles.cyclic
        view.addSubview(carouselView)
        carouselView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(310)
            maker.height.equalTo(150)
        }
        views.append(carouselView)


        styles.listen { (name: String) in
            if name == "slideDirection" {
                for b in self.views { b.slideDirection = self.styles.slideDirection2 }
            } else if name == "slideInterval" {
                for b in self.views { b.slideInterval = self.styles.slideInterval }
            } else if name == "itemSpacing" {
                for b in self.views { b.itemSpacing = self.styles.itemSpacing }
            } else if name == "manualSlidable" {
                for b in self.views { b.manualSlidable = self.styles.manualSlidable }
            } else if name == "slideAnimType" {
                for b in self.views { b.slideAnimType = self.styles.slideAnimType2 }
            } else if name == "cyclic" {
                for b in self.views { b.cyclic = self.styles.cyclic }
            }
        }
    }
    
    func carouselView(_ carouselView: XHBCarouselView, didSlideTo index: Int) {
        text.text = String(index)
    }
    
}
