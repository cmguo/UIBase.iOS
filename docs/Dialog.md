# 对话框

对话框控件具有下列特性：
- 基础内容（可灵活组合）：图片、关闭图标、标题、说明文字、按钮、底部复选框
- 按钮组合：单按钮、双按钮（一个主要）、多按钮（仍然有主要按钮）
- 扩展内容（Body）

# 使用对话框
* 定义按钮布局
``` swift
let dialog = ZDialog()
dialog.title = "标题"
dialog.subTitle = "说明文字"
dialog.cancelButton = "取消"
dialog.confirmButton = "确定"
dialog.moreButtons = ["项目1", "项目2"]
dialog.delegate = self
dialog.popUp(target: view)

```
* 处理对话框回调
``` swift
func dialogButtonClicked(dialog: ZDialog, btnId: ZButton.ButtonId?) {
    ZTipView.toast(dialog, "点击了按钮 \(btnId ?? .Unknown)")
}

func dialogMoreButtonClicked(dialog: ZDialog, index: Int) {
    ZTipView.toast(dialog, "点击了按钮 \(index)")
}
```
