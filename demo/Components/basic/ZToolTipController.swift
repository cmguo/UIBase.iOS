//
//  XHBToolTipController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase

class XHBToolTipController: ComponentController, UICollectionViewDataSource, UICollectionViewDelegate, XHBToolTipContentDelegate, XHBToolTipCallbackDelegate {

    @objc enum Location : Int {
        case TopLeft
        case TopCenter
        case TopRight
        case BottomLeft
        case BottomCenter
        case BottomRight
        case AutoToast
    }
    
    class Styles : ViewStyles {
        @objc var maxWidth: CGFloat = 200
        @objc var singleLine = false
        @objc var message = "你点击了按钮"
        
        override class func descsForStyle(name: String) -> NSArray? {
            if (name == "maxWidth") {
                return ["最大宽度", "整体最大宽度，设置负数，则自动加上窗口宽度"]
            } else if (name == "singleLine") {
                return ["单行文字", "限制单行文字，默认是多行的"]
            } else if (name == "singleLine") {
                return ["消息内容", "自适应消息内容的宽度和高度"]
            } else {
                return nil
            }
        }
        
        override class func valuesForStyle(name: String) -> NSArray? {
            if name == "location" {
                return makeValues(enumType: XHBToolTip.Location.self)
            } else if name.contains("con") {
                return Icons.icons as NSArray
            } else {
                return nil
            }
        }
    }
    
    class TipStyles : Styles {

        @objc var location = Location.TopRight
        var location2 = XHBToolTip.Location.TopRight
        @objc var rightIcon = "<null>"

        override class func descsForStyle(name: String) -> NSArray? {
            if name == "rightIcon" {
                return ["右侧图标", "右侧显示的图标，URL 类型，一般用于关闭，也可以自定义其他行为"]
            } else if (name == "location") {
                return ["建议位置", "建议弹出位置，如果左右或者上下超过窗口区域，则会分别自动调整为其他适当位置"]
            } else {
                return super.descsForStyle(name: name)
            }
        }
        
        override func notify(_ name: String) {
            if name == "location" {
                location2 = XHBToolTip.Location(rawValue: location.rawValue)!
            }
            super.notify(name)
        }
    }
    
    class ToastStyles : Styles {

        @objc var leftIcon = "<null>"
        @objc var rightIcon = "<null>"
        @objc var icon = "<null>"
        @objc var button = "<null>"

        override class func descsForStyle(name: String) -> NSArray? {
            if name == "icon" {
                return ["提示图标", "附加在文字左侧的图标，URL 类型，不能点击"]
            } else if name == "leftIcon" {
                return ["左侧图标", "左侧显示的图标，URL 类型，一般用于关闭，也可以自定义其他行为"]
            } else if name == "rightIcon" {
                return ["右侧图标", "右侧显示的图标，URL 类型，一般用于关闭，也可以自定义其他行为"]
            } else if name == "button" {
                return ["右侧按钮", "右侧显示的按钮，外部扩展提供，点击行为由外部自定义"]
            } else {
                return super.descsForStyle(name: name)
            }
        }
    }
    
    class Model : ViewModel {
        let buttonTitle = "点我"
    }
    
    private let component: Component
    private let styles: Styles
    private let model = Model()
    
    private lazy var gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width / 4, height:  self.view.frame.height / 6)
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()
    
    init(_ component: Component) {
        self.component = component
        styles = component is XHBToolTipComponent ? TipStyles() : ToastStyles()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getStyles() -> ViewStyles {
        return styles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ToolTip")
        view.addSubview(gridView)
        gridView.backgroundColor = .white
        gridView.frame = view.frame
        gridView.dataSource = self
        gridView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        styles is TipStyles ? 15 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(withReuseIdentifier: "ToolTip", for: indexPath)
        let button = XHBButton(type: .Primitive, sizeMode: .Large, icon: nil, text: model.buttonTitle)
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.size.equalTo(button.bounds.size)
            maker.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        XHBToolTip.tip(sender, styles.message, delegate: self)
    }
    
    func toolTipMaxWidth(_ toolTip: XHBToolTip) -> CGFloat {
        return styles.maxWidth
    }
    
    func toolTipSingleLine(_ toolTip: XHBToolTip) -> Bool {
        return styles.singleLine
    }
    
    func toolTipLeftIcon(_ toolTip: XHBToolTip) -> URL? {
        guard  let icon = (styles as? ToastStyles)?.leftIcon else {
            return nil
        }
        return Icons.iconURL(icon)
    }
    
    func toolTipRightIcon(_ toolTip: XHBToolTip) -> URL? {
        if let styles = styles as? TipStyles {
            return Icons.iconURL(styles.rightIcon)
        } else if let styles = styles as? ToastStyles {
            return Icons.iconURL(styles.rightIcon)
        } else {
            return nil
        }
    }
    
    func toolTipIcon(_ toolTip: XHBToolTip) -> URL? {
        guard  let icon = (styles as? ToastStyles)?.icon else {
            return nil
        }
        return Icons.iconURL(icon)
    }
    
    func toolTipPrefectLocation(_ toolTip: XHBToolTip) -> XHBToolTip.Location {
        return (styles as? TipStyles)?.location2 ?? .AutoToast
    }
    
    func toolTipIconTapped(_ toolTip: XHBToolTip, index: Int) {
        XHBToolTip.tip(toolTip, "图标被点击了")
    }
}