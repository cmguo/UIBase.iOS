# ZUiBase.iOS 已经确认的使用 UI 库组件示例

## 标准色、有状态颜色
```swift
// 快速使用标准色
view.backgroundColor = .bluegrey_100
// 自定义有状态颜色
public extension StateListColor {
    static let blue_100_pressed_disabled = StateListColor([
        StateColor(.bluegrey_100, .STATES_DISABLED),
        StateColor(.blue_200, .STATES_PRESSED),
        StateColor(.blue_100, .STATES_NORMAL)
    ])
}
// 使用有状态颜色
let buttonAppearance = ZButtonAppearance(.textLinkThin,
                textColor: .blue_100_pressed_disabled)
```

## 图标资源
```swift
// 快速使用图标
button.icon = .icon_back
// 使用 UIImageView 加载图标
imageView.bounds.size = CGSize(20, 20) // SVG 图标根据容器大小自动调整
imageView.setImage(withURL: .icon_left)
imageView.setIconColor(.blue_100) // 仅 SVG 图标有效
```

## 文字样式
```swift
label.textStyle = .Body_Middle // 没有颜色
label.textAppearance = .Body_Middle // 使用样式中的颜色
// 也可以分别设置
label.lineHeight = 30
label.textForegroundColor = .blue // 注意：设置 textColor 可能无效
label.textBackgroundColor = .red
label.textAlignment = .center // 注意：原生的 textAlignment 已经被扩展覆盖
// 同时支持 UILabel、UITextField，UITextView
textField.lineHeight = 30
textView.lineHeight = 30
```

## 按钮
```swift
// 示例1
let button = ZButton()
            .buttonType(type)
            .buttonSize(styles.buttonSize2)
            .text(styles.text)
            .icon(styles.icon)
// 示例2
let buttonAppearance = ZButtonAppearance(.textLinkThin,
                                                      textColor: StateListColor(singleColor: .bluegrey_800),
                                                      iconSize: 20,
                                                      iconPadding: 5)
```

## 下拉菜单
```swift
let dropDown = ZDropDown()
dropDown.titles = model.titles
dropDown.icons = model.icons
dropDown.popAt(sender, withDelegate: self)
```
