//
//  ContributionRequestController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation
import UIBase

class ContributionRequestController: ComponentController {

    class Styles : ViewStyles {
        
        @objc static let _colorStyle = ColorStyle(Styles.self, "color")
        @objc var color = UIColor.red
        
    }
    
    class Model : ViewModel {
        let message = "很抱歉，该组件（控件）暂未实现。\n如果您有意愿加入并贡献一份力量，我们将非常欢迎！"
    }
    
    private let styles = Styles()
    private let model = Model()

    private let label = UILabel()

    override func getStyles() -> ViewStyles {
        return styles
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        label.text = model.message
        label.textColor = styles.color
        view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }

        styles.listen { (name: String) in
            if name == "color" {
                self.label.textColor = self.styles.color
            }
        }
    }
    
}

