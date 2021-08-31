# 下拉菜单
下拉菜单控件具有下列特性：
- 列表项包含标题、图标、复选框、单选框
- 圆角边框，阴影，弹出动画
- 自动弹出位置

# 下拉菜单的使用
``` swift
let dropDown = ZDropDown()
dropDown.titles = model.titles
dropDown.icons = model.icons
dropDown.popAt(sender, withDelegate: self)
```

# 复选、单选菜单
``` swift
// 网格背景、夜间模式是复选菜单
dropDrow.titles = ["设置", "网格背景(x)", "夜间模式(x)"]
// 单选菜单
ropDrow.titles = ["选项1(*)", "选项2(*)", "选项3(*)"]
```