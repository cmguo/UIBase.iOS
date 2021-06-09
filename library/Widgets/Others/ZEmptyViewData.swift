//
// Created by Crap on 2021/6/7.
//

import Foundation


public struct ZEmptyViewData {
    var icon: Any = URL.icon_bulb
    var text: String = "暂无数据"
    var buttonText: String? = "重试"
    var buttonListener: (() -> Void)? = nil
    var loading: Bool = false

    public static func build(icon: Any = URL.icon_bulb, text: String = "暂无数据", buttonText: String? = "重试", buttonListener: (() -> Void)? = nil, loading: Bool = false) -> ZEmptyViewData {
        let data = ZEmptyViewData(icon: icon, text: text, buttonText: buttonText, buttonListener: buttonListener, loading: loading)
        return data
    }
}