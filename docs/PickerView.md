# 选择器
选择器具有下列特性
- 列表项包含标题、图标、复选框
- 列表项目可以具有不同的显示状态（enabled）
- 支持复选或者单选

# 使用选择器
* 定义选择器样式
``` swift
let picker = ZPickerView()
picker.titles = [
            "不可选择的已选择项",
            "不可选择的未选择项",
            "普通选项",
            "普通选项",
            "普通选项",
            "过于长的选项过于长的选项过于长的选项…",
            "普通选项",
        ]
picker.icons = icons
picker.states = [.disabled, .disabled]
picker.singleSelection = false
picker.selections = [0, 1]
```
* 通过面板弹出
``` swift
picker.callback = self
let panel = ZPanel()
panel.titleBar = [
    "title": "标题",
    "leftButton": URL.icon_close,
    "rightButton": URL.icon_more
]
panel.content = picker
panel.popUp(target: view)
```
* 响应选择项目的变化
``` swift
func onSelectionChanged(picker: ZPickerView, selection: Int) {
    model.selection = selection >= 0 ? selection : nil
}
func onSelectionsChanged(picker: ZPickerView, selections: [Int]) {
    model.selections = selections
}
```