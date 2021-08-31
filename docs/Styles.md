# 文字样式

文字样式概况：
- 正文样式（Body）文字尺寸 10 ～ 18
- 标题样式（Title）文字尺寸 14 ～ 24
- 样式属性
  - android:textSize
  - android:textColor
  - lineHeight
  - lineSpacing
  - android:gravity 居中、靠右

# 使用文字样式
``` xml
<!-- 注意：不支持 lineHeight、lineSpacing -->
<androidx.appcompat.widget.AppCompatCheckBox
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:checked='@={value.checked}'
    android:textAppearance="@style/TextAppearance.Z.Title.16"
    android:text="@{value.value}">
```
``` kotlin
// 可以支持 lineHeight、lineSpacing
textView.textAppearance = R.style.TextAppearance_Z_Title_18
```
