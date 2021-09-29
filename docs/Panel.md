# 面板
面板作为很多控件的弹出容器，具有下列特性
- 组合标题栏、中间内容，底部按钮

# 使用面板
* 定义面板样式
``` swift
let panel = ZPanel()
panel.titleBar = [
    "title": "标题",
    "leftButton": URL.icon_close,
    "rightButton": URL.icon_more
]
panel.bottomButton = ["去查看", URL.icon_right]
panel.content = contentView
panel.delegate = self
panel.popUp(target: view)
```
* 响应面板事件
``` swift
func panelButtonClicked(_ panel: ZPanel, _ btnId: ZButton.ButtonId?) {
    ZTipView.toast(panel, "点击了按钮 \(btnId ?? .Unknown)")
}

func panelDismissed(panel: ZPanel) {
    ZTipView.toast(view, "面板消失")
}
```
