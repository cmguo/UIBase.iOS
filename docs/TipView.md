# 提示视图
提示视图 TipView 对应产品上的多种提示类型的控件，实现了简单提示（Toast）、气泡提示（ToolTip）、横幅提示（SnackBar）

提示视图控件有下列特性
- 组合图标、文字、按钮多个元素
- 样式集管理（ZTipView.Appearance），标准样式集，自定义样式集
- 小三角指示器（气泡提示）
- 自动弹出位置（小三角指向的位置，简单提示堆叠）
- 自动消失：定时消失，外部点击消失

# 提示视图的一般用法
* 自定义布局（可选，使用自定义布局，可以比较清晰地自定义一些样式）
``` xml
<com.eazy.uibase.widget.ZTipView
    android:id="@+id/tipView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:maxWidth="300dp"
    app:message="@{styles.message}"
    app:singleLine="true"
    app:rightButton="@style/comfirm_button"
    app:icon="@drawable/icon_tip"/>
```

``` kotlin
val tipView = layoutInflater.inflate(R.layout.tip_view)
tipView.popAt(view, object : TipViewListener {
    override fun tipViewButtonClicked(view: ZTipView, btnId: Int) {
        // btnId 可能是：R.id.leftButton, R.id.rightButton
        val name = resources.getResourceEntryName(btnId)
        Log.d(TAG, "点击了按钮${name}")
    }
}
```

# 作为简单提示使用
``` xml
tipView.location = ZTipView.Location.AutoToast
tipView.popAt(view)
// 快速使用
ZTipView.toast(view, "简单提示")
// 自定义布局
ZTipView.toast(view, "简单提示", R.layout.tip_view)
```

# 作为气泡提示使用
``` xml
tipView.location = ZTipView.Location.TopCenter
tipView.popAt(view)
// 快速使用，需要明确指定小箭头位置
ZTipView.tip(view, "气泡提示", ZTipView.Location.TopCenter)
// 自定义布局
ZTipView.tip(view, "气泡提示", ZTipView.Location.TopCenter, R.layout.tip_view)
```

# 作为横幅提示使用
``` xml
tipView.location = ZTipView.Location.ManualLayout
tipView.popAt(view)
// 快速使用
ZTipView.snack(view, "横幅提示")
// 自定义布局
ZTipView.snack(view, "横幅提示", R.layout.tip_view)
```

# 标准样式集
标准样式集

# 自定义样式集
``` xml
<style name="ZTipView.Appearance.XXX">
    <item name="textAppearance">@style/TextAppearance.Z.Body.Small</item>
    <item name="frameColor">@color/red_100</item>
    <item name="textColor">@color/red_600</item>
    <item name="frameColor">@color/black</item>
    <item name="frameRadius">10dp</item></style>
```

# 作为系统 Toast 的内容弹出
``` kotlin
// 不支持回调，按钮不能点击
tipView.popUp(Toast.LENGTH_SHORT)
```