# 标题栏（导航栏）
标题栏具有下列特性：
- 具有标题文字和图标、左右按钮
- 支持扩展标题中间的内容
- 当无左按钮，有右按钮时，标题居左，且改变文字样式
- 内部元素的颜色可以随正文内容滚动而渐变

# 标题栏的使用
* 自定义标题栏样式
``` xml
<com.eazy.uibase.widget.ZAppTitleBar
    android:id="@+id/titleBar"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:background="@drawable/transparent_gradient2"
    app:leftButton="@style/leftButton"
    app:rightButton="@style/rightButton"
    app:icon="@drawable/icon_title"
    app:title="标题"
    app:textAppearance="@style/TextAppearance.Z.Head0"
    />
```
* 响应按钮点击
``` kotlin
titleBar.listener = object : TitleBarListener() {
    override fun titleBarButtonClicked(bar: ZAppTitleBar, btnId: Int) {
        // btnId 可能是：R.id.leftButton, R.id.rightButton, R.id.rightButton2
        val name = resources.getResourceEntryName(btnId)
        ZTipView.toast(requireView(), "点击了按钮: ${name}")
    }
}
```

# 内部元素颜色渐变
* 定义使用渐变色

参考 [颜色](docs/Colors.md) 定义渐变色
``` xml
<!-- 自定义按钮样式，使用渐变色 -->
<style name="ZButton.Appearance.AppTitleBar.Gradient">
    <item name="android:textColor">@color/bluegrey_00_gradient</item>
</style>
<!-- 自定义文字样式，使用渐变色 -->
<style name="TextAppearance.Z.Head2.Gradient">
    <item name="android:textColor">@color/transparent_gradient</item>
</style>
```
* 代码实现元素颜色渐变
``` kotlin
// 设置样式
titleBar.leftButtonAppearance = R.style.ZButton_Appearance_AppTitleBar_Gradient
titleBar.rightButtonAppearance = R.style.ZButton_Appearance_AppTitleBar_Gradient
titleBar.textAppearance = R.style.TextAppearance_Z_Head2_Gradient
// 直接设置进度
titleBar.setGradientProgress(progress)
// 或者自动跟踪内容视图的滚动
titleBar.gradientWith(view, 0, length)
```


# 扩展中间内容
* 在 layout 中指定扩展内容
``` xml
<com.eazy.uibase.widget.ZAppTitleBar
    android:layout_width="@dimen/dialog_width"
    android:layout_height="wrap_content">
    
    <RecylerView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:padding="20dp"
        />
    
</com.eazy.uibase.widget.ZAppTitleBar>

```
* 在代码中增加扩展内容
``` kotlin
titleBar.content = R.layout.body_view
// 或者
titleBar.addView(view)
```