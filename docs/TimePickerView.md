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

# 时间选择器的使用
* 定义选择器样式
``` swift
let picker = ZTimePickerView()
picker.backgroundColor = .bluegrey_00
picker.startTime = dateFormatter.date(from: "2021-08-31 15:40:04")
picker.endTime = dateFormatter.date(from: "2021-09-30 15:40:04")
picker.timeDelegate = this
```
* 通过代码弹出
``` swift
// 通过 Panel 弹出
let panel = ZPanel()
panel.titleBar = [
    "title": "标题",
    "leftButton": URL.icon_close,
    "rightButton": URL.icon_more
]
picker.removeFromSuperview()
panel.content = picker
panel.delegate = self
panel.popUp(target: view)
```
* 响应选择时间的变化
``` swift
func timePickerSelectTimeChanged(picker: ZTimePickerView, time: Date) {
    timeLabel.text = dateFormater.string(from: time)
}
```

# 高级时间模式
``` swift
// 9 bits 分别对应
// 年、月、周次、天、周；上下午、小时、分钟、秒
// 0b1010010110 显示：月、天、周、小时、分钟
// 其中“月”将被跨年展开，天、周合并显示
timePicker.timeMode2 = 0b0010110110
```
