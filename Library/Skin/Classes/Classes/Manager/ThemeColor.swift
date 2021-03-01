//
//  ThemeColor.swift
//  blackboard
//
//  Created by roni on 2019/7/29.
//  Copyright © 2019 xkb. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
// MARK: - 配色规范 - 颜色读取统一入口
@objcMembers
public class ThemeColor: NSObject {
    public var white_card : UIColor {
        return ThemeColor.color(path: "white_card", defaultColor: "#FFFFFF", des: "#FFFFFF#212630")
    }
    public var bluegrey_00 : UIColor {
        return ThemeColor.color(path: "bluegrey_00", defaultColor: "#FFFFFF", des: "#FFFFFF#191E26")
    }
    public var bluegrey_05 : UIColor {
        return ThemeColor.color(path: "bluegrey_05", defaultColor: "#F7F8F9", des: "#F7F8F9#262C36")
    }
    public var bluegrey_50 : UIColor {
        return ThemeColor.color(path: "bluegrey_50", defaultColor: "#F7F8F9", des: "#F7F8F9#0B1117")
    }
    public var bluegrey_100 : UIColor {
        return ThemeColor.color(path: "bluegrey_100", defaultColor: "#F2F3F4", des: "#F2F3F4#262D38")
    }
    public var bluegrey_200 : UIColor {
        return ThemeColor.color(path: "bluegrey_200", defaultColor: "#EBECED", des: "#EBECED")
    }
    public var bluegrey_300 : UIColor {
        return ThemeColor.color(path: "bluegrey_300", defaultColor: "#E4E6E8", des: "#E4E6E8#2D3440")
    }
    public var bluegrey_400 : UIColor {
        return ThemeColor.color(path: "bluegrey_400", defaultColor: "#D5D7DB", des: "#D5D7DB")
    }
    public var bluegrey_500 : UIColor {
        return ThemeColor.color(path: "bluegrey_500", defaultColor: "#B7BBBF", des: "#B7BBBF#4D5666")
    }
    public var bluegrey_600 : UIColor {
        return ThemeColor.color(path: "bluegrey_600", defaultColor: "#9CA0A6", des: "#9CA0A6")
    }
    public var bluegrey_700 : UIColor {
        return ThemeColor.color(path: "bluegrey_700", defaultColor: "#81858C", des: "#81858C#707C8C")
    }
    public var bluegrey_800 : UIColor {
        return ThemeColor.color(path: "bluegrey_800", defaultColor: "#4E5359", des: "#4E5359#A3AFBF")
    }
    public var bluegrey_900 : UIColor {
        return ThemeColor.color(path: "bluegrey_900", defaultColor: "#1D2126", des: "#1D2126#E2ECFA")
    }
    public var brand_100 : UIColor {
        return ThemeColor.color(path: "brand_100", defaultColor: "#FFFCD4", des: "#FFFCD4#524C23")
    }
    public var brand_500 : UIColor {
        return ThemeColor.color(path: "brand_500", defaultColor: "#FFD630", des: "#FFD630#FFD630")
    }
    public var brand_600 : UIColor {
        return ThemeColor.color(path: "brand_600", defaultColor: "#F2C121", des: "#F2C121#D9B629")
    }
    public var red_100 : UIColor {
        return ThemeColor.color(path: "red_100", defaultColor: "#FFEDED", des: "#FFEDED#3D2929")
    }
    public var red_500 : UIColor {
        return ThemeColor.color(path: "red_500", defaultColor: "#FF6666", des: "#FF6666#DA7171")
    }
    public var red_600 : UIColor {
        return ThemeColor.color(path: "red_600", defaultColor: "#EB3B3B", des: "#EB3B3B#E48484")
    }
    public var redorange_100 : UIColor {
        return ThemeColor.color(path: "redorange_100", defaultColor: "#FFEDE5", des: "#FFEDE5#3E322E")
    }
    public var redorange_500 : UIColor {
        return ThemeColor.color(path: "redorange_500", defaultColor: "#FF6D2E", des: "#FF6D2E#DA825E")
    }
    public var redorange_600 : UIColor {
        return ThemeColor.color(path: "redorange_600", defaultColor: "#FF4D00", des: "#FF4D00#E69472")
    }
    public var orange_100 : UIColor {
        return ThemeColor.color(path: "orange_100", defaultColor: "#FFF0DB", des: "#FFF0DB#3C3325")
    }
    public var orange_500 : UIColor {
        return ThemeColor.color(path: "orange_500", defaultColor: "#FFA319", des: "#FFA319#E6A15C")
    }
    public var orange_600 : UIColor {
        return ThemeColor.color(path: "orange_600", defaultColor: "#FF8C00", des: "#FF8C00#F2AF6C")
    }
    public var green_100 : UIColor {
        return ThemeColor.color(path: "green_100", defaultColor: "#E8F7F0", des: "#E8F7F0#203A32")
    }
    public var green_500 : UIColor {
        return ThemeColor.color(path: "green_500", defaultColor: "#00CC66", des: "#00CC66#61BA8D")
    }
    public var green_600 : UIColor {
        return ThemeColor.color(path: "green_600", defaultColor: "#00B058", des: "#00B058#71C99D")
    }
    public var cyan_100 : UIColor {
        return ThemeColor.color(path: "cyan_100", defaultColor: "#E1F9FA", des: "#E1F9FA#233738")
    }
    public var cyan_500 : UIColor {
        return ThemeColor.color(path: "cyan_500", defaultColor: "#00D1D9", des: "#00D1D9#5DC3C6")
    }
    public var cyan_600 : UIColor {
        return ThemeColor.color(path: "cyan_600", defaultColor: "#00B9BF", des: "#00B9BF#6DD1D4")
    }
    public var blue_100 : UIColor {
        return ThemeColor.color(path: "blue_100", defaultColor: "#EDF4FF", des: "#EDF4FF#213452")
    }
    public var blue_200 : UIColor {
        return ThemeColor.color(path: "blue_200", defaultColor: "#CCE0FF", des: "#CCE0FF#324563")
    }
    public var blue_500 : UIColor {
        return ThemeColor.color(path: "blue_500", defaultColor: "#4F94FF", des: "#4F94FF#6B99DE")
    }
    public var blue_600 : UIColor {
        return ThemeColor.color(path: "blue_600", defaultColor: "#1970F2", des: "#1970F2#7FA6E2")
    }
    public var purple_100 : UIColor {
        return ThemeColor.color(path: "purple_100", defaultColor: "#F2F0FD", des: "#F2F0FD#343146")
    }
    public var purple_500 : UIColor {
        return ThemeColor.color(path: "purple_500", defaultColor: "#8C79F2", des: "#8C79F2#8C79F2")
    }
    public var purple_600 : UIColor {
        return ThemeColor.color(path: "purple_600", defaultColor: "#6A54E0", des: "#6A54E0#988BDC")
    }
    public var static_bluegrey_05 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_05", defaultColor: "#F7F8F9", des: "#F7F8F9#F7F8F9")
    }
    public var static_bluegrey_50 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_50", defaultColor: "#F7F8F9", des: "#F7F8F9#F7F8F9")
    }
    public var static_bluegrey_100 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_100", defaultColor: "#F2F3F4", des: "#F2F3F4#F2F3F4")
    }
    public var static_bluegrey_200 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_200", defaultColor: "#EBECED", des: "#EBECED#EBECED")
    }
    public var static_bluegrey_300 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_300", defaultColor: "#E4E6E8", des: "#E4E6E8#E4E6E8")
    }
    public var static_bluegrey_400 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_400", defaultColor: "#D5D7DB", des: "#D5D7DB#D5D7DB")
    }
    public var static_bluegrey_500 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_500", defaultColor: "#B7BBBF", des: "#B7BBBF#B7BBBF")
    }
    public var static_bluegrey_600 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_600", defaultColor: "#9CA0A6", des: "#9CA0A6#9CA0A6")
    }
    public var static_bluegrey_700 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_700", defaultColor: "#81858C", des: "#81858C#81858C")
    }
    public var static_bluegrey_800 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_800", defaultColor: "#4E5359", des: "#4E5359#4E5359")
    }
    public var static_bluegrey_900 : UIColor {
        return ThemeColor.color(path: "static_bluegrey_900", defaultColor: "#1D2126", des: "#1D2126#1D2126")
    }
    public var static_white_100 : UIColor {
        return ThemeColor.color(path: "static_white_100", defaultColor: "#FFFFFF", des: "#FFFFFF#FFFFFF")
    }
    public var static_white_90 : UIColor {
        return ThemeColor.color(path: "static_white_90", defaultColor: "#E5FFFFFF", des: "#E5FFFFFF#FFFFFF 90%")
    }
    public var static_white_80 : UIColor {
        return ThemeColor.color(path: "static_white_80", defaultColor: "#CCFFFFFF", des: "#CCFFFFFF#FFFFFF 80%")
    }
    public var static_white_70 : UIColor {
        return ThemeColor.color(path: "static_white_70", defaultColor: "#B2FFFFFF", des: "#B2FFFFFF#FFFFFF 70%")
    }
    public var static_white_60 : UIColor {
        return ThemeColor.color(path: "static_white_60", defaultColor: "#99FFFFFF", des: "#99FFFFFF#FFFFFF 60%")
    }
    public var static_white_50 : UIColor {
        return ThemeColor.color(path: "static_white_50", defaultColor: "#7FFFFFFF", des: "#7FFFFFFF#FFFFFF 50%")
    }
    public var static_white_40 : UIColor {
        return ThemeColor.color(path: "static_white_40", defaultColor: "#66FFFFFF", des: "#66FFFFFF#FFFFFF 40%")
    }
    public var static_white_30 : UIColor {
        return ThemeColor.color(path: "static_white_30", defaultColor: "#4CFFFFFF", des: "#4CFFFFFF#FFFFFF 30%")
    }
    public var static_white_20 : UIColor {
        return ThemeColor.color(path: "static_white_20", defaultColor: "#33FFFFFF", des: "#33FFFFFF#FFFFFF 20%")
    }
    public var static_white_10 : UIColor {
        return ThemeColor.color(path: "static_white_10", defaultColor: "#19FFFFFF", des: "#19FFFFFF#FFFFFF 10%")
    }
    public var static_white_05 : UIColor {
        return ThemeColor.color(path: "static_white_05", defaultColor: "#0CFFFFFF", des: "#0CFFFFFF#FFFFFF 5%")
    }
    public var static_black_100 : UIColor {
        return ThemeColor.color(path: "static_black_100", defaultColor: "#000000", des: "#000000#000000")
    }
    public var static_black_90 : UIColor {
        return ThemeColor.color(path: "static_black_90", defaultColor: "#E5000000", des: "#E5000000#000000 90%")
    }
    public var static_black_80 : UIColor {
        return ThemeColor.color(path: "static_black_80", defaultColor: "#CC000000", des: "#CC000000#000000 80%")
    }
    public var static_black_70 : UIColor {
        return ThemeColor.color(path: "static_black_70", defaultColor: "#B2000000", des: "#B2000000#000000 70%")
    }
    public var static_black_60 : UIColor {
        return ThemeColor.color(path: "static_black_60", defaultColor: "#99000000", des: "#99000000#000000 60%")
    }
    public var static_black_50 : UIColor {
        return ThemeColor.color(path: "static_black_50", defaultColor: "#7F000000", des: "#7F000000#000000 50%")
    }
    public var static_black_40 : UIColor {
        return ThemeColor.color(path: "static_black_40", defaultColor: "#66000000", des: "#66000000#000000 40%")
    }
    public var static_black_30 : UIColor {
        return ThemeColor.color(path: "static_black_30", defaultColor: "#4C000000", des: "#4C000000#000000 30%")
    }
    public var static_black_20 : UIColor {
        return ThemeColor.color(path: "static_black_20", defaultColor: "#33000000", des: "#33000000#000000 20%")
    }
    public var static_black_10 : UIColor {
        return ThemeColor.color(path: "static_black_10", defaultColor: "#19000000", des: "#19000000#000000 10%")
    }
    public var static_black_05 : UIColor {
        return ThemeColor.color(path: "static_black_05", defaultColor: "#0C000000", des: "#0C000000#000000 5%")
    }
    public static let shared = ThemeColor()
    // MARK: - 品牌色

    // 主色/主要按钮/登陆输入点击状态

    // 主色点击色

    // 主色不可点击色/聊天气泡底色/日历

    // 辅助色/发布按钮选中色/操作文字色/语音按钮色/链接文字/放大的数据文字/次要按钮

    // 辅助色不可点击

    // MARK: - 中性色/公共颜色

    // 首页标题/TAB颜色

    // 首页副标题/表单栏辅助颜色

    // 表单栏cell辅助文字颜色 and 晓书包 cell 文字副标题

    // 按钮旁边的文字颜色/搜索框内占位颜色/列表组头组尾颜色/标签文字

    // 弹框中输入框占位文字颜色

    // 正常输入框占位文字颜色

    // 分割线颜色

    // 元素背景色,用于区分块, eg. tableView 分组之间间隔颜色/ 标签底色

    // 卡片叠加背景色/发布底部按钮背景色, eg. 首页带有链接的卡片, 链接部分的背景色

    // 整个app的基础背景色

    // 按钮完成状态的背景颜色

    // 按钮不可点击的文字颜色

    // 搜索框背景颜色

    // 进度条颜色

    // MARK: - 功能色

    // 提示气泡色/小红点(背景色)

    // 小红点文字颜色

    // 提示文字颜色

    // 提示底色

    // 完成状态颜色 eg. 完成打钩 钩的颜色

    // MARK: - 按钮

    // 蓝色按钮不可点击的文字颜色

    // 蓝色按钮不可点击的文字颜色

    // 蓝色按钮不可点击的文字颜色

    // 蓝色按钮不可点击的文字颜色

    // 黄色按钮 正常/按下 文字颜色

    // 黄色按钮 不可点击 文字颜色

    // MARK: - 模块色

    //教师标签颜色


    // 图片编辑添加文字待输入的文字

    // 首页分类未选中

    // 首页分类选中

    // 私聊发送者 - 气泡边框颜色

    // 私聊发送者 - 气泡背景颜色

    // 私聊接收者 - 气泡边框颜色

    // 私聊接收者 - 气泡背景色

    // 私聊输入框背景色

    // 私聊撤回消息背景色 /  退出晓讨论背景色

    // 班级申请提示横条背景色

    // 班级申请提示横条文字颜色

    // 班级申请提示横条小红点颜色

    // 登陆输入框下边线未编辑状态下的颜色

    // 顶部提示文字颜色

    // 评论框背景色

    // 文档/链接里面文字(标题/副标题)颜色

    // 文档/链接 卡片背景色

    // 文档/链接 卡片边框颜色

    // 星期选择卡片文字颜色

    // 星期选择卡片未选中背景颜色

    // 饼状图正常颜色

    // 日历卡片数字颜色以及今天和以前的"第几天"的颜色

    // 日历卡片未来的"第几天"颜色

    // 日历卡片未来"暂未开始"

    // 日历卡片过去背景色

    // 日历卡片今天背景色

    // 日历卡片未来背景色

    // 首页背景色

    // 首页卡片背景色

    // 音频背景色

    // 音频边框颜色

    // 发布页工具栏颜色

    // 标签背景色

    // 首页卡片文本内容文字颜色
    // 消息卡片竖线颜色

    // 习惯卡片竖线颜色

    //消息详情发起私聊border颜色

    // 详情成果分割线

    // 我们是有底线滴

    // 首页结束卡片已结束文字颜色

    // 消息卡片结束蒙层

    //chat_send_document_bg_color

    // 调查提交按钮线框色

    // 私聊发出去的文档背景色

    //绿色部分


    
    //new




    public var alertTextViewTextColor: UIColor {
        return ThemeColor.shared.bluegrey_900
    }


    /// 取色函数
    ///
    /// - Parameters:
    ///   - path: 颜色在 style.json 文件中的名字
    ///   - defaultColor: 获取不到颜色 用于显示的默认色, 默认值为白色皮肤下的颜色
    ///   - des: 颜色查找关键字 白色+黑色
    /// - Returns: UIColor
    public class func color(path: String, defaultColor: String = "#000000", des: String = "") -> UIColor {
        if let stringValue = ThemeColor.value(path: path) {
            return UIColor(hexString: stringValue)
        }
        return ThemeColor.color(hexString: defaultColor)
    }

    public class func color(hexString: String) -> UIColor {
        return UIColor(hexString: hexString)
    }

    public class func value(path: String) -> String? {
        var json: JSON = SkinManager.instance.json

        if let stringValue = json[path].string { return stringValue }

        let items = path.components(separatedBy: ".")
        if items.isEmpty {
            return nil
        }
        for item in items {
            json = json[item]
        }

        return json.string
    }

    static public var statusBarStyle: UIStatusBarStyle {
        if let statusBarStyle = SkinManager.instance.json["Custom"]["Application"]["statusBarStyle"].string {
            switch statusBarStyle {
                case "UIStatusBarStyleLightContent":
                    return UIStatusBarStyle.lightContent
                case "UIStatusBarStyleDefault":
                    if #available(iOS 13.0, *) {
                        return UIStatusBarStyle.darkContent
                    } else {
                        return UIStatusBarStyle.default
                }
                default: break
            }
        }
        return UIStatusBarStyle.lightContent
    }

    static public var navigationBarStyle: UIBarStyle {
        if let statusBarStyle = SkinManager.instance.json["Custom"]["Application"]["statusBarStyle"].string {
            switch statusBarStyle {
                case "UIStatusBarStyleLightContent":
                    return UIBarStyle.black
                case "UIStatusBarStyleDefault":
                    return UIBarStyle.default
                default: break
            }
        }
        return UIBarStyle.default
    }

    static public var keyboardAppearance: UIKeyboardAppearance {
        if let statusBarStyle = SkinManager.instance.json["Custom"]["Application"]["keyboardStyle"].string {
            switch statusBarStyle {
                case "dark":
                    return .dark
                case "light":
                    return .light
                default: break
            }
        }
        return .default
    }
}
