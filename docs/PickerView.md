# 选择器
选择器具有下列特性
- 列表项包含标题、图标、复选框
- 列表项目可以具有不同的显示状态（enabled）
- 支持复选或者单选
- 可双向绑定选择状态

# 使用选择器
* 定义选择器样式
``` xml
<com.eazy.uibase.widget.ZPickerView
    android:id="@+id/picker"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:titles="@array/picker_titles"
    app:icons="@array/icons"
    app:singleSelection="true"
    app:selection="@={model.selection}"
    app:selections="@={model.selections}"
    />
```
* 通过代码弹出
``` kotlin
// 通过 Panel 弹出
val panel = ZPanel(requireContext())
panel.titleBar = R.style.title_bar_text
panel.addView(picker)
panel.popUp(parentFragmentManager)
```