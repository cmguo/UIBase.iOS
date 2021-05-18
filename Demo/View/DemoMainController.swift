//
//  DemoMainController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import UIBase

open class DemoMainController: UIViewController, ZDropDownDelegate {

    private var component_ : Component? = nil
    
    private var componentsController = ComponentsController()
    private var stylesController = StylesController()
    private var informationController = InformationController()

    private let dropDrow = ZDropDown()
    private let gridLayer = GridLayer()
    private let backView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "基础控件演示"
        
        gridLayer.isHidden = true
        backView.layer.addSublayer(gridLayer)
        
        view.addSubview(informationController.view)
        informationController.view.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        view.addSubview(buttonStyles)
        buttonStyles.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        componentsController.setComponentListener { (component: ComponentInfo) in
            self.switchComponent(component)
        }
        let buttonComponents = UIBarButtonItem(image: UIImage(withUrl: Icons.pngURL("img_humburger")!), style: .plain, target: self, action: #selector(showComponents))
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = buttonComponents
        let buttonSettings = UIBarButtonItem(image: UIImage(withUrl: Icons.pngURL("img_menu")!), style: .plain, target: self, action: #selector(showSettings))
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = buttonSettings
        buttonStyles.addTarget(self, action: #selector(showStyles), for: .touchUpInside)
        
        dropDrow.titles = ["设置", "网格背景(x)", "夜间模式(x)"]
    }
    
    @objc func showSettings() {
        guard let target = navigationController?.navigationBar.subviews[1].subviews[1] else { return }
        dropDrow.popAt(target, withDelegate: self)
    }
    
    @objc func showComponents() {
        let nav = UINavigationController(rootViewController: componentsController)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true, completion: nil)
    }
    
    func hideComponents() {
        componentsController.parent?.dismiss(animated: true, completion: nil)
    }
    
    @objc func showStyles() {
        view.addSubview(stylesController.view)
        stylesController.view.frame = view.bounds
        //present(stylesController, animated: true, completion: nil)
    }
    
    func switchComponent(_ component: ComponentInfo) {
        if let component = component_ {
            component.controller.removeFromParent()
        }
        let controller = component.component.controller
        view.insertSubview(controller.view, belowSubview: buttonStyles)
        controller.view.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(informationController.view.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        controller.view.insertSubview(backView, at: 0)
        addChild(controller)
        component_ = component.component
        title = component_?.title
        // Styles
        stylesController.switchComponent(component)
        informationController.switchComponent(component)
        hideComponents()
    }
    
    private let buttonStyles: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.backgroundColor = .green
        return button
    }()
    
    public func dropDownFinished(dropDown: ZDropDown, selection: Int, withValue: Any?) {
        if selection == 1 {
            gridLayer.isHidden = withValue as! ZCheckBox.CheckedState == ZCheckBox.CheckedState.NotChecked
        } else if selection == 2 {
            let night = withValue as! ZCheckBox.CheckedState == ZCheckBox.CheckedState.FullChecked
            if #available(iOS 13.0, *) {
                view.window?.overrideUserInterfaceStyle = night ? .dark : .light
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
}

