//
//  MainController.swift
//  app
//
//  Created by 郭春茂 on 2021/2/20.
//
    
import UIKit
import SnapKit
import Demo

class MainController: UIViewController {

    private var component_ : Component? = nil
    
    private var componentsController = ComponentsController()
    private var stylesController = StylesController()
    private var informationController = InformationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "基础控件演示"
        view.backgroundColor = .white
        
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
        let image = UIImage(withUrl: Icons.pngURL("img_share_moment")!)
        let buttonComponents = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showComponents))
        navigationController?.topViewController?.navigationItem.leftBarButtonItem = buttonComponents
        buttonStyles.addTarget(self, action: #selector(showStyles), for: .touchUpInside)
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
            component.controller.view.removeFromSuperview()
        }
        let controller = component.component.controller
        view.insertSubview(controller.view, belowSubview: buttonStyles)
        controller.view.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(informationController.view.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        })
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
    
}

