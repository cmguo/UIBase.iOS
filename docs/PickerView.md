# 选择器
选择器具有下列特性
- 列表项包含标题、图标、复选框
- 列表项目可以具有不同的显示状态（enabled）
- 支持复选或者单选
- 可双向绑定选择状态

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
picker.selections = [0, 1]
```
* 弹出
``` swift
picker.callback = self
panel.popUp(target: view)
```
