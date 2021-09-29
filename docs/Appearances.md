# 文字样式

文字样式概况：
- 正文样式（Body）文字尺寸 10 ～ 18
- 标题样式（Title）文字尺寸 14 ～ 24
- 样式属性
  - textSize
  - textColor
  - lineHeight
  - lineSpacing
  - textAlignment 居中、靠右

# 使用文字样式
``` swift
label.textStyle = .Body_Middle // 没有颜色
label.textAppearance = .body_16 // 使用样式中的颜色
// 也可以分别设置
label.lineHeight = 30
label.textForegroundColor = .blue // 注意：设置 textColor 可能无效
label.textBackgroundColor = .red
label.textAlignment = .center // 注意：原生的 textAlignment 已经被扩展覆盖
// 同时支持 UILabel、UITextField，UITextView
textField.lineHeight = 30
textView.lineHeight = 30
textView.textAppearance = .title_18
```
