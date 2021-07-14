# ZUiBase.iOS 已经确认的使用 UI 库组件示例

## TextAppearance
* 支持定义类型
```swift
label.textAppearance = .Body_Middle
```

## ZButton
* 产品已经确认

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
