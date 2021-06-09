//
// Created by Crap on 2021/6/4.
//
// Used for empty content displaying.
//

import Foundation
import SwiftUI

public class ZEmptyViewDefault: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    var data: ZEmptyViewData = ZEmptyViewData() {
        didSet {
            self.updateView(data: data)
        }
    }

     lazy var image: UIImageView = {
        let view = UIImageView()
        view.frame.size = CGSize(width: 72, height: 72)
        view.setIconColor(color: .bluegrey_700)
        return view
    }()

    private lazy var text: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .bluegrey_700
        view.textAlignment = .center
        return view
    }()

    lazy var button: ZButton = {
        let view = ZButton().buttonSize(.Middle)
        view.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        return view
    }()

    @objc func onButtonClick() {
        data.buttonListener?()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }

    open func setUpView() {
        let container = self
        let centerContainer = UIView()
        centerContainer.addSubview(image)
        centerContainer.addSubview(text)
        centerContainer.addSubview(button)
        container.addSubview(centerContainer)

        centerContainer.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: image.frame.size.width),
            image.heightAnchor.constraint(equalToConstant: image.frame.size.height),
            image.centerXAnchor.constraint(equalTo: container.centerXAnchor),

            text.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            text.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            text.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 12),

            button.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 24),

            centerContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            centerContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            centerContainer.topAnchor.constraint(equalTo: image.topAnchor, constant: 0),
            centerContainer.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            centerContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }

    open func updateView(data: ZEmptyViewData) {
        if data.loading {
            image.isHidden = true
            button.isHidden = true
            text.text = "加载中 ..."
        } else {
            image.isHidden = false
            button.isHidden = data.buttonText == nil
            if data.icon is URL {
                image.setImage(svgURL: data.icon as! URL)
            } else if data.icon is UIImage {
                image.image = data.icon as! UIImage
            } else {
                // do nothing ...
            }
            text.text = data.text
            button.text = data.buttonText
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


public extension UITableView {

    var uibase_emptyViewDefault: ZEmptyViewData? {
        set {
            if newValue != nil {
                let emptyView: ZEmptyViewDefault = backgroundView as? ZEmptyViewDefault ?? ZEmptyViewDefault()
                emptyView.data = newValue!
                backgroundView = emptyView
            } else {
                backgroundView = nil
            }
        }
        get {
            let view = backgroundView as? ZEmptyViewDefault
            return view?.data ?? nil
        }
    }

}