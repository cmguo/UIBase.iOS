//
//  ZTabBarController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/7.
//

import Foundation
import UIBase
import JXSegmentedView

class ZTabBarController: ComponentController, ZTabBarDelegate, JXSegmentedListContainerViewDataSource {

    class Styles : ViewStyles {
        
    }
    
    class Model : ViewModel {
        
        let titles1 = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        
        let icons = ["monkey", "frog", "dog", "pig", "sheep", "chicken", "horse", "cow", "elephant", "dragon"]
        
        let titles2 = ["高尔夫", "滑雪", "自行车"]
        
    }
    
    private let styles = Styles()
    private let model = Model()
    private let tabBar1 = ZTabBar()
    private let tabBar2 = ZTabBar(style: {
        let s = ZTabBarStyle()
        s.titleStyle = .Frame
        return s
    }())
    private let tabBar3 = ZTabBar(style: {
        let s = ZTabBarStyle()
        s.titleStyle = .Flat
        return s
    }())
    private let tabBar4 = ZTabBar(style: {
        let s = ZTabBarStyle()
        s.titleStyle = .Round
        return s
    }())
    private var views = [ZTabBar]()

    private lazy var page1: JXSegmentedListContainerView = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    private lazy var page2: JXSegmentedListContainerView = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar1.titles = model.titles1
        tabBar1.indicator = ZTabBarLineIndicator()
        tabBar1.listContainer = page1
        tabBar1.delegate = self
        view.addSubview(tabBar1)
        tabBar1.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(50)
        }
        views.append(tabBar1)
        
        tabBar2.titles = model.titles1
        tabBar2.indicator = ZTabBarLineIndicator()
        tabBar2.listContainer = page1
        tabBar2.delegate = self
        view.addSubview(tabBar2)
        tabBar2.snp.makeConstraints { (maker) in
            maker.top.equalTo(tabBar1.snp.bottom).offset(10)
            maker.width.equalToSuperview()
            maker.height.equalTo(50)
        }
        views.append(tabBar2)

        view.addSubview(page1)
        page1.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(tabBar2.snp.bottom)
            maker.height.equalTo(180)
        }

        tabBar3.titles = model.titles2
        tabBar3.indicator = ZTabBarRoundIndicator()
        tabBar3.listContainer = page2
        tabBar3.delegate = self
        view.addSubview(tabBar3)
        tabBar3.snp.makeConstraints { (maker) in
            maker.top.equalTo(page1.snp.bottom).offset(20)
            maker.width.equalToSuperview()
            maker.height.equalTo(50)
        }
        views.append(tabBar3)
        
        tabBar4.titles = model.titles2
        let style = ZTabBarRoundIndicatorStyle()
        style.widthMode = .MatchContent
        tabBar4.indicator = ZTabBarRoundIndicator(style: style)
        tabBar4.listContainer = page2
        tabBar4.delegate = self
        view.addSubview(tabBar4)
        tabBar4.snp.makeConstraints { (maker) in
            maker.top.equalTo(tabBar3.snp.bottom).offset(10)
            maker.width.equalToSuperview()
            maker.height.equalTo(50)
        }
        views.append(tabBar4)

        view.addSubview(page2)
        page2.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(tabBar4.snp.bottom)
            maker.height.equalTo(180)
        }

        styles.listen { (name: String) in
            if name == "slideDirection" {
                
            }
        }
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return listContainerView == page1 ? model.titles1.count :  model.titles2.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return ListBaseViewController()
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

}

class ListBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: CGFloat(arc4random()%255)/255, green: CGFloat(arc4random()%255)/255, blue: CGFloat(arc4random()%255)/255, alpha: 1)
    }
}

extension ListBaseViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
