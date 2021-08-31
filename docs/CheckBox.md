# 复选框

复选框控件具有下列特性：
- 半选 HalfChecked 状态
- 状态可 DataBinding 双向绑定

# 使用复选框
``` xml
<com.eazy.uibase.widget.ZCheckBox
    android:id="@+id/check_box"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:layout_gravity="center"
    app:onCheckedStateChanged="@{styles.checkBoxCheckedStateChanged}"
    app:checkedState="@={(CheckedState) data.state}"
    android:enabled="@{!styles.disabled}"
    android:text="@{styles.text}"/>
```

# 父子复选框状态联动
``` kotlin
var states: List<ZCheckBox.CheckedState>

var allCheckedState: ZCheckBox.CheckedState = ZCheckBox.CheckedState.HalfChecked
    set(value) {
        if (field == value)
            return
        field = value
        notifyPropertyChanged(BR.allCheckedState)
        if (value == ZCheckBox.CheckedState.HalfChecked)
            return
        for (i = 0 until states.size) {
            states[i] = value
        }
    }

fun updateAllCheckedState() {
    allCheckedState = when (states.filter { s -> s == ZCheckBox.CheckedState.FullChecked }.size) {
        0 -> ZCheckBox.CheckedState.NotChecked
        states.size -> ZCheckBox.CheckedState.FullChecked
        else -> ZCheckBox.CheckedState.HalfChecked
    }
}
```