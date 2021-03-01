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

    func configUI() {
        view.addSubview(infoContainer)
        infoContainer.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        view.addSubview(buttonComponents)
        buttonComponents.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-100)
            make.bottom.equalToSuperview().offset(-10)
        }
        view.addSubview(buttonStyles)
        buttonStyles.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "demo"
        view.backgroundColor = .blue
        configUI()
        componentsController.setComponentListener { (component: Component) in
            self.switchComponent(component)
        }
        buttonComponents.addTarget(self, action: #selector(showComponents), for: .touchUpInside)
        buttonStyles.addTarget(self, action: #selector(showStyles), for: .touchUpInside)
    }
    
    @objc func showComponents() {
        let nav = UINavigationController(rootViewController: componentsController)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showStyles() {
        view.addSubview(stylesController.view)
        stylesController.view.frame = view.bounds
        //present(stylesController, animated: true, completion: nil)
    }
    
    func switchComponent(_ component: Component) {
        if let component = component_ {
            component.controller.removeFromParent()
            component.controller.view.removeFromSuperview()
        }
        let controller = component.controller
        view.insertSubview(controller.view, belowSubview: buttonComponents)
        controller.view.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview()
            make.top.equalTo(infoContainer.snp.bottom)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        })
        addChild(controller)
        // Styles
        stylesController.switchComponent(component)
    }
    
    private let buttonComponents: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.backgroundColor = .red
        return button
    }()
    
    private let buttonStyles: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.backgroundColor = .green
        return button
    }()
    
    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
}

