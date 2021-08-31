# 面板
面板作为很多控件的弹出容器，具有下列特性
- 组合标题栏、中间内容，底部按钮

# 使用面板
* 定义面板样式
``` xml
<com.eazy.uibase.widget.ZPanel
    android:id="@+id/panel"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:titleBar="@style/titlebar_content"
    app:content="@style/panel_content"
    app:bottomButton="@style/bottomButton"
    />
```
* 通过代码弹出面板
``` kotlin
panel.listener = object: PanelListener() {
    override fun panelButtonClicked(panel: ZPanel, btnId: Int) {
        // btnId 可能的：TitleBar 的按钮，底部按钮 R.id.bottomButton
        val name = resources.getResourceEntryName(btnId)
        ZTipView.toast(panel, "点击了按钮: ${name}")
    }
}
panel.popUp(parentFragmentManager)
```

# 指定中间内容
* 在 layout 中指定中间内容
``` xml
<com.eazy.uibase.widget.ZPanel
    android:layout_width="400dp"
    android:layout_height="wrap_content">
    
    <ZPickerView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        />
    
</com.eazy.uibase.widget.ZPanel>

```
* 在代码中增加扩展内容
``` kotlin
panel.content = R.layout.body_view
// 或者
panel.addView(view)
```