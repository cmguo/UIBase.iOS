//
//  ZDropDownController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/22.
//

import Foundation
import UIBase

class ZDropDownController: ComponentController, UICollectionViewDataSource, UICollectionViewDelegate, ZDropDownCallback {

    class Styles : ViewStyles {
        
        @objc static let _width = ["宽度", "整体最大宽度，设置负数，则自动加上窗口宽度，设置为 0，自动计算宽度"]
        @objc var width: CGFloat = 200
        
    }
    
    class Model : ViewModel {
        let titles = ["菜单项目1", "菜单项目2", "菜单项目3", "菜单项目4", "菜单项目5"]
        let icons = Icons.iconURLs
    }
    
    private let styles = Styles()
    private let model = Model()
    
    private lazy var gridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width / 4, height:  self.view.frame.height / 6)
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()
    
    init() {
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
        gridView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DropDown")
        view.addSubview(gridView)
        gridView.backgroundColor = .white
        gridView.frame = view.frame
        gridView.dataSource = self
        gridView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(withReuseIdentifier: "DropDown", for: indexPath)
        let button = ZButton()
        button.text = "点我"
        cell.contentView.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonClicked(_ sender: UIView) {
        let dropDown = ZDropDown()
        dropDown.titles = model.titles
        dropDown.icons = model.icons
        dropDown.popAt(sender, withCallback: self)
    }
    
    func dropDownFinished(dropDown: ZDropDown, selection: Int) {
        ZTipView.toast(view, "选择了项目 \(selection)")
    }
}

