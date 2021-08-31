# 下拉菜单
下拉菜单控件具有下列特性：
- 列表项包含标题、图标、复选框、单选框
- 圆角边框，阴影，弹出动画
- 自动弹出位置

# 下拉菜单的使用
* 定义菜单
``` swift
let dropDown = ZDropDown()
dropDown.titles = ["菜单项目1", "菜单项目2", "菜单项目3", "菜单项目4", "菜单项目5"]
dropDown.icons = icons
dropDown.popAt(sender, withDelegate: self)
```
* 处理菜单选择
``` swift
func dropDownFinished(dropDown: ZDropDown, selection: Int, withValue: Any?) {
    // selection 为 -1 表示没有选择任何项目
    ZTipView.toast(view, "选择了项目 \(selection)")
}
```

# 复选、单选菜单
``` swift
// 网格背景、夜间模式是复选菜单
dropDrow.titles = ["设置", "网格背景(x)", "夜间模式(x)"]
// 单选菜单
dropDrow.titles = ["选项1(*)", "选项2(*)", "选项3(*)"]
```