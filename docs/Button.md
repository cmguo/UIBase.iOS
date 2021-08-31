# 按钮

按钮控件具有下列特性
- 增强样式：在系统按钮基础上，增加圆角尺寸、背景色、前景色，图标位置，图标尺寸等样式
- 标准样式：预置标准样式，分为类型、尺寸两个大类，两者可自由组合
- 自定义样式：可扩展定义样式集合，其中可以组合使用标准样式
- 特殊行为模式：图标变色，加载状态
- 内容样式：组合内容样式（文字、图标），可在集成控件中灵活定义按钮内容

# 基础使用方式
``` xml
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

# 按钮样式增强
| 样式 | 使用说明 | 是否展示样式 | 备注 |
| ------ | ------ | ------ | ------ |
| backgroundColor | 背景色，支持夜间模式 | 是 | 同时应用于图标颜色 |
| textColor | 文字颜色，支持夜间模式 | 是 | 同时应用于图标颜色 |
| textSize | 文字尺寸 | 是 ||
| iconPosition | 图标位置，4个方向 | 是 | |
| minHeight | 指定按钮高度 | 是 | 最小约束 |
| cornerRadius | 背景圆角尺寸 | 是 ||
| paddingX | 左、右填充 | 是 | |
| paddingY | 上、下填充，与 minHeight 配合使用，用于高度不固定情形 | 是 | |
| iconPadding | 文字、图标之间的距离 | 是 | |
| iconSize | 图标尺寸，宽高相等 | 是 | |
| iconColor | 图标颜色 | 是 | 如果指定，则不跟随文字颜色 |
| buttonType | 组合定义按钮标准类型 | 是 | |
| buttonSize | 组合定义按钮标准尺寸 | 是 | |
| content | 按钮组合内容 | 否 | 可以是 String，URL，(String,URL) 类型 |
| text | 按钮文字 | 否 | |
| icon | 按钮图标 | 否 | |
| buttonAppearance | 按钮样式集合 | 否 | 部分覆盖 buttonType，buttonSize |


# 标准按钮样式
* 标准按钮类型

 ![buttonType.png](images/buttonType.png)
* 标准按钮尺寸

 ![buttonSize.png](images/buttonSize.png)

# 自定义按钮样式集合
通过 buttonAppearance 中引用自定义按钮样式集合，部分组合控件也可以使用这些样式集合
``` swift
public var buttonApperance = ZButtonAppearance(.textLinkThin,
                                                 textColor: StateListColor(singleColor: .bluegrey_700),
                                                 iconPosition: .top,
                                                 height: 66,
                                                 textSize: 12,
                                                 iconSize: 40,
                                                 iconPadding: 8).normalized()
```

# 文字按钮
这是（TextLink）按钮的定义，默认没有 padding
``` swift
public static let textLink = ZButtonAppearance(
        textColor: .blue_600_disabled,
        backgroundColor: .transparent_pressed_disabled,
        minHeight: 0,
        paddingX: 0
    ).seal()
```
