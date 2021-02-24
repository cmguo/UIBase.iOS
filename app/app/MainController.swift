//
//  MainController.swift
//  app
//
//  Created by 郭春茂 on 2021/2/20.
//

import UIKit
import SnapKit
import demo

class MainController: UIViewController {

    private var component_ : Component? = nil
    
    func configUI() {
        view.addSubview(infoContainer)
        infoContainer.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        view.addSubview(buttonComponents)
        buttonComponents.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "demo"
        view.backgroundColor = .blue
        configUI()
        buttonComponents.addTarget(self, action: #selector(showComponents), for: .touchUpInside)
    }
    
    @objc func showComponents() {
        
        let controller = ComponentsController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .formSheet
        controller.view.backgroundColor = .yellow
        controller.setComponentListener { (component: Component) in
            self.switchComponent(component)
        }
        present(nav, animated: true, completion: nil)
    }
    
    func switchComponent(_ component: Component) {
        if let component = component_ {
            component.controller.removeFromParent()
        }
        let controller = component.controller
        view.addSubview(controller.view)
        controller.view.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(infoContainer.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        addChild(controller)
    }
    
    private let buttonComponents: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.backgroundColor = .red
        return button
    }()
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
}

