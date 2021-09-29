# 提示视图
提示视图 TipView 对应产品上的多种提示类型的控件，实现了简单提示（Toast）、气泡提示（ToolTip）、横幅提示（SnackBar）

提示视图控件有下列特性
- 组合图标、文字、按钮多个元素
- 样式集管理（ZTipView.Appearance），标准样式集，自定义样式集
- 小三角指示器（气泡提示）
- 自动弹出位置（小三角指向的位置，简单提示堆叠）
- 自动消失：定时消失，外部点击消失

# 提示视图的一般用法
* 定义样式
``` swift
let v = ZTipView()
tipView.message = message
tipView.location = .topRight
tipView.tipAppearance = tipAppearance
tipView.rightButton = ["去查看", URL.icon_right]
tipView.dismissDelay = 0
tipView.maxWidth = maxWidth
tipView.numberOfLines = 1
tipView.delegate = self
tipView.popAt(button)
```
* 处理回调事件
``` swift
func tipViewButtonClicked(_ tipView: ZTipView, _ btnId: ZButton.ButtonId?) {
    ZTipView.toast(tipView, "点击了按钮 \(btnId ?? .Unknown)")
    tipView.dismiss()
}
```

# 作为简单提示使用
``` swift
tipView.location = .autoToast
tipView.popAt(view)
// 快速使用
ZTipView.toast(view, "简单提示")
```

# 作为气泡提示使用
``` swift
tipView.location = .topCenter
tipView.popAt(view)
// 快速使用，需要明确指定小箭头位置
ZTipView.tip(view, "气泡提示", .topCenter)
```

# 作为横幅提示使用
``` swift
tipView.location = .manualLayout
tipView.popAt(view)
// 快速使用
ZTipView.snack(view, "横幅提示")
```

# 标准样式集
标准样式集

# 自定义样式集
``` swift
let toolTipSpecial = ZTipViewAppearance(copy: toolTip).frameColor(.blue_600)
```
