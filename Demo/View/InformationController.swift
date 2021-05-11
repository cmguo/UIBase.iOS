//
//  InformationController.swift
//  Demo
//
//  Created by 郭春茂 on 2021/5/11.
//

import Foundation
import UIBase

public class InformationController : UIViewController {
    
    private var components_ = Components.allGroups().sorted() { l, r in
        l.key.rawValue < r.key.rawValue
    }
    
    private let summaryLabel = UILabel()
    private let descLabel = UILabel()
    private let authorLabel = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue_100
        
        summaryLabel.text = "简介"
        view.addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints() { maker in
            maker.top.equalToSuperview().offset(10)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }

        descLabel.numberOfLines = 0
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints() { maker in
            maker.top.equalTo(summaryLabel.snp.bottom).offset(10)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.height.lessThanOrEqualTo(80)
        }
        
        view.addSubview(authorLabel)
        authorLabel.snp.makeConstraints() { maker in
            maker.top.equalTo(descLabel.snp.bottom).offset(10)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.bottom.equalToSuperview().offset(-10)
        }
    }

    public func switchComponent(_ component: ComponentInfo) {
        descLabel.text = component.component.desc
        authorLabel.text = component.component.author
    }

}
