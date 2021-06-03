//
// Created by Crap on 2021/6/3.
//

import Foundation
import SwiftUI
import SnapKit

class FishTestController : ComponentController {

    override func getStyles() -> ViewStyles {
        return ViewStyles()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImageView()
        image.setImage(svgURL: .icon_clock)
        image.setIconColor(color: .redorange_600)
        image.bounds.size = CGSize(width: 300, height: 300)

        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
