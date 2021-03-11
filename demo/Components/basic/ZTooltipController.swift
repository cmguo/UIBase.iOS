//
//  XHBTooltipController.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/23.
//

import Foundation
import UIKit
import UIBase

class XHBTooltipController: ComponentController, UICollectionViewDataSource, UICollectionViewDelegate {

    @objc enum Location : Int {
        case TopLeft
        case TopCenter
        case TopRight
        case BottomLeft
        case BottomCenter
        case BottomRight
    }
    
    class Styles : ViewStyles {
        @objc var location = Location.TopRight
        var location2 = XHBToolTip.Location.TopRight
        @objc var maxWidth: CGFloat = 150
        @objc var tipText = "你点击了按钮"
        @objc var closeable = false
        
        override class func valuesForStyle(name: String) -> NSArray? {
            if name == "location" {
                return makeValues(enumType: XHBToolTip.Location.self)
            } else {
                return nil
            }
        }
        
        override func notify(_ name: String) {
            if name == "location" {
                location2 = XHBToolTip.Location(rawValue: location.rawValue)!
            }
            super.notify(name)
        }
    }
    
    class Model : ViewModel {
        let buttonTitle = "点我"
    }
    
    private let styles = Styles()
    private let model = Model()
    private lazy var gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width / 4, height:  self.view.frame.height / 6)
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()
    
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
        15
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
        XHBToolTip.tip(sender, styles.tipText, maxWidth: styles.maxWidth, location: styles.location2)
    }
}

