//
//  ButtonsController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/2/24.
//

import Foundation
import UIKit

class ButtonsController: ComponentController {

    class Styles : ViewStyles {
        
    }
    
    class Model : ViewModel {
        let colors = Colors.stdDynamicColors()
    }
    
    private let styles = Styles()
    private let model = Model()
    let button = UIButton()

    override func getStyles() -> ViewStyles {
        return self.styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("按钮")
        button.setTitleColor(.bluegrey_800, for: .normal)
        button.titleLabel?.textAppearance = .body_18
        view.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
    
}
