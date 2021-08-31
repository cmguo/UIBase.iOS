# 单选框
单选框控件

# 单选框的使用
``` xml
<com.eazy.uibase.widget.ZRadioButton
    android:id="@+id/radio_button"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_gravity="center"
    android:onCheckedChanged="@{styles.radioCheckedChanged}"
    android:checked="@={(Boolean) data.state}"
    android:enabled="@{!styles.disabled}"
    android:text="@{styles.text}"/>
```

# 单选框分组管理
RadioGroup 不太适合列表等复杂场景，请参考下面的实现管理单选逻辑
``` kotlin
// simulate radio group
val radioCheckedChanged = CompoundButton.OnCheckedChangeListener { view: View, isChecked: Boolean ->
    if (isChecked) {
        val binding: RadioButtonItemBinding = DataBindingUtil.findBinding(view.parent as ViewGroup)!!
        for (item in fragment.model.states) {
            if (item != binding.data) {
                item.state = false
            }
        }
    }
}
```