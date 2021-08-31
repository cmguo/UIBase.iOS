//
//  ZActivityViewController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/4/23.
//

import Foundation
import UIBase

class ZActivityViewController: ComponentController, ZActivityViewDelegate, ZPanelDelegate {

    class Styles : ViewStyles {
    }
    
    class Model : ViewModel {
        
        let item1 = [
            ["班级", Icons.pngURL("img_share_class")!],
            ["微信", Icons.pngURL("img_share_weixin")!],
            ["朋友圈", Icons.pngURL("img_share_moment")!],
            ["QQ", Icons.pngURL("img_share_qq")!],
            ["QQ空间", Icons.pngURL("img_share_space")!],
            ["跟多", Icons.pngURL("img_share_class")!],
        ]
        
        let item2 = [
            ["置顶", URL.icon_stick],
            ["复制", URL.icon_copy],
            ["分享", URL.icon_repost],
            ["撤回", URL.icon_recall],
            ["收藏", URL.icon_star],
            ["链接", URL.icon_weblink],
            ["刷新", URL.icon_refresh],
        ]
    }
    
    private let styles = Styles()
    private let model = Model()
    private let activityView = ZActivityView()
    private var views = [ZActivityView]()
    
    private let button = ZButton()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue_100

        activityView.backgroundColor = .bluegrey_00
        activityView.items1 = model.item1
        activityView.items2 = model.item2
        activityView.delegate = self
        view.addSubview(activityView)
        activityView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        views.append(activityView)

        button.text = "弹出面板"
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(200)
        }
    }
    
    func activityViewButtonClicked(view: ZActivityView, line: Int, index: Int) {
        ZTipView.toast(view, "点击了按钮 \(line) - \(index)")
    }

    @objc func buttonClicked(_ sender: UIView) {
        let panel = ZPanel()
        panel.titleBar = ContentStyle.Contents["title_text"]
        panel.bottomButton = "取消"
        activityView.removeFromSuperview()
        panel.content = activityView
        panel.delegate = self
        panel.popUp(target: view)
    }
    
    func panelDismissed(panel: ZPanel) {
        panel.content = nil
        view.addSubview(activityView)
        activityView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
}

