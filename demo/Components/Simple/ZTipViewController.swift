//
//  ZTipViewController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase

class ZTipViewController: ComponentController, UICollectionViewDataSource, UICollectionViewDelegate, ZTipViewContentDelegate, ZTipViewCallbackDelegate {

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
        
        @objc static let _maxWidth = ["最大宽度", "整体最大宽度，设置负数，则自动加上窗口宽度"]
        @objc var maxWidth: CGFloat = 200
        
        @objc static let _numberOfLines = ["单行文字", "限制单行文字，默认是多行的"]
        @objc var numberOfLines = 0
        
        @objc static let _message = ["消息内容", "自适应消息内容的宽度和高度"]
        @objc var message = "你点击了按钮"
    }
    
    class ToolTipStyles : Styles {

        @objc static let _location = ["建议位置", "建议弹出位置，如果左右或者上下超过窗口区域，则会分别自动调整为其他适当位置"]
        @objc static let _locationStyle: NSObject = EnumStyle(ToolTipStyles.self, "location", ZTipView.Location.self)
        @objc var location = Location.TopRight

        @objc static let _rightButton = ["右侧按钮", "右侧显示的图标，URL 类型，一般用于关闭，也可以自定义其他行为"]
        @objc static let _rightButtonStyle: NSObject = ContentStyle(ToolTipStyles.self, "rightButton", ["<button>"])
        @objc var rightButton: Any? = URL.icon_close

        var location2: ZTipView.Location {
            get { ZTipView.Location.init(rawValue: location.rawValue)! }
        }
    }
    
    class SnackToastStyles : Styles {
        
        let location: ZTipView.Location

        @objc static let _rightButton = ["右侧按钮", "右侧显示的图标，URL 类型，一般用于关闭，也可以自定义其他行为"]
        @objc static let _rightButtonStyle: NSObject = ContentStyle(SnackToastStyles.self, "rightButton", ["<button>"])
        @objc var rightButton: Any? = Icons.iconURL("erase")
        
        @objc static let _icon = ["提示图标", "附加在文字左侧的图标，URL 类型，不能点击"]
        @objc static let _iconStyle: NSObject = IconStyle(SnackToastStyles.self, "icon")
        @objc var icon: URL? = Icons.iconURL("info")
        
        init(_ location: ZTipView.Location) {
            self.location = location
            super.init()
            maxWidth = 300
        }
    }
    
    class ToastStyles : SnackToastStyles {
        
        init() {
            super.init(.AutoToast)
            message = "网络不给力，请稍后重试"
        }
    }
    
    class SnackStyles : SnackToastStyles {
        
        @objc static let _leftButton = ["左侧按钮", "左侧按钮的内容，详见按钮 content 属性；一般用于关闭，也可以自定义其他行为"]
        @objc static let _leftButtonStyle: NSObject = ContentStyle(SnackStyles.self, "leftButton", ["<button>"])
        @objc var leftButton: Any? = nil

        init() {
            super.init(.ManualLayout)
            message = "我们会基于您所填写的年级和学科来提供对应功能"
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
        styles = component is ZToolTipComponent ? ToolTipStyles()
            : (component is ZToastComponent ? ToastStyles() : SnackStyles())
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
                
        if component is ZSnackBarComponent {
            ZTipView.tip(gridView, styles.message, delegate: self)
            styles.listen() {_ in
                ZTipView.remove(from: self.gridView)
                ZTipView.tip(self.gridView, self.styles.message, delegate: self)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        styles is ToolTipStyles ? 15 : (component is ZSnackBarComponent ? 0 : 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(withReuseIdentifier: "ToolTip", for: indexPath)
        let button = ZButton()
        button.text = model.buttonTitle
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        ZTipView.tip(sender, styles.message, delegate: self)
    }
        
    func tipViewMaxWidth(_ tipView: ZTipView) -> CGFloat {
        return styles.maxWidth
    }
    
    func tipViewNumberOfLines(_ tipView: ZTipView) -> Int {
        return styles.numberOfLines
    }
    
    func tipViewLeftButton(_ tipView: ZTipView) -> Any? {
        return (styles as? SnackStyles)?.leftButton
    }
    
    func tipViewRightButton(_ tipView: ZTipView) -> Any? {
        if let styles = styles as? ToolTipStyles {
            return styles.rightButton
        } else if let styles = styles as? SnackToastStyles {
            return styles.rightButton
        } else {
            return nil
        }
    }
    
    func tipViewIcon(_ tipView: ZTipView) -> URL? {
        return (styles as? SnackToastStyles)?.icon
    }
    
    func tipViewPerfectLocation(_ tipView: ZTipView) -> ZTipView.Location {
        return (styles as? ToolTipStyles)?.location2 ?? (styles as! SnackToastStyles).location
    }
    
    func tipViewButtonClicked(_ tipView: ZTipView, _ btnId: ZButton.ButtonId?) {
        ZTipView.toast(tipView, "点击了按钮 \(btnId ?? .Unknown)")
        tipView.dismissAnimated(true)
    }
    
}
