# 对话框

对话框控件具有下列特性：
- 基础内容（可灵活组合）：图片、关闭图标、标题、说明文字、按钮、底部复选框
- 按钮组合：单按钮、双按钮（一个主要）、多按钮（仍然有主要按钮）
- 扩展内容（Body）

# 使用对话框
* 定义按钮布局
``` xml
<com.eazy.uibase.widget.ZDialog
    android:id="@+id/dialog"
    android:layout_width="@dimen/dialog_width"
    android:layout_height="wrap_content"
    app:image="@drawable/image1"
    app:closeIconColor="@color/blue_300"
    app:title="标题"
    app:subTitle="说明文字"
    app:confirmButton="@style/confirmButton"
    app:cancelButton="@style/cancelButton"
    app:checkBox="下次不再提示"
    app:listener="@{fragment}"
    />
```
* 在代码中使用
``` kotlin
val dialog = DiaglogBinding.inflate(inflater)
dialog.popUp(parentFragmentManager, object: DialogListener {
    override fun buttonClicked(dialog: ZDialog, btnId: Int) {
        // btnId 可能是：R.id.confirmButton, R.id.cancelButton
        // 对于扩展按钮集合，btnId 代表集合 index
        val name = if (btnId < 256) "index_$btnId" else resources.getResourceEntryName(btnId)
        Log.d(TAG, "点击了按钮: ${name}")
    }
}
```

# 扩展 Body 内容
* 在 layout 中指定扩展内容
``` xml
<com.eazy.uibase.widget.ZDialog
    android:layout_width="@dimen/dialog_width"
    android:layout_height="wrap_content">
    
    <RecylerView
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:padding="20dp"
        />
    
</com.eazy.uibase.widget.ZDialog>

```
* 在代码中增加扩展内容
``` kotlin
dialog.content = R.layout.body_view
// 或者
dialog.addView(view)
```