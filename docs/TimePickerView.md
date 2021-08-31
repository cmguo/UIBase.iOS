# 时间选择器
时间选择器控件具有下列特性：
- 时间策略
  - 范围：起止时间，默认 1900～2100
  - 时间段：年、月、周次、天、周；上下午、小时、分钟、秒；支持自定义各段标题
  - 周、天合并为一个时间段“天”（显示为：“11日 周二”）
  - 跨时间段展开（比如12月的后继是下年1月）
  - 合并展示（比如 2021年6月，2021年7月）
  - 时间间隔（最后一段时间，如5分钟间隔）
  - 循环滚动
- 当前选择时间，可双向绑定（DataBinding）

# 时间选择器的使用
* 定义选择器样式
``` xml
<com.eazy.uibase.widget.ZTimePickerView
    android:id="@+id/picker"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_gravity="center_vertical"
    app:timeMode="yearMonthDay"
    app:timeInterval="5"
    app:cyclic="true"
    app:centerLabel="true"
    app:itemsVisibleCount="5"
    app:selectTime="@={styles.selectTime}"
    />
```
* 通过代码弹出
``` kotlin
val timePicker = inflater.inflate(R.layout.time_picker)
timePicker.startTime = dateFormat.parse("2021/08/31 13:15:01")
timePicker.endTime = dateFormat.parse("2021/09/30 13:15:01")
// 通过 Panel 弹出
val panel = ZPanel(requireContext())
panel.titleBar = R.style.title_bar_text
panel.addView(timePicker)
panel.popUp(parentFragmentManager)
```

# 高级时间模式
``` kotlin
// 9 bits 分别对应
// 年、月、周次、天、周；上下午、小时、分钟、秒
// 0b1010010110 显示：月、天、周、小时、分钟
// 其中“月”将被跨年展开，天、周合并显示
timePicker.timeMode2 = 0b0010110110
```
