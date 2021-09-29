# 颜色资源

颜色资源概况：
- 标准色：分为动态颜色和静态颜色
  - 动态颜色：具有夜间模式
  - 静态颜色（static_*）：没有夜间模式，在不同模式下，保持不变
- 有状态颜色：(StateListColor)
  - 扩展了 UIControl.State 状态
  - 有状态颜色可以使用“动态颜色“，实现夜间模式

# 自定义动态颜色
values/colors.xml
``` swift
extension UIColor {
    @DayNightColorWrapper(name: "bluegrey_100", dayColor: 0xFFF2F3F4, nightColor: 0xFF262D38)
    public static var bluegrey_100
}
```

# 自定义有状态颜色
``` swift
public extension StateListColor {
    static let bluegrey_00_checked_disabled = StateListColor([
        StateColor(.bluegrey_100, .disabled),
        StateColor(.brand_500, .checked),
        StateColor(.brand_500, .half_checked),
        StateColor(.bluegrey_00, .normal)
    ])
}
```

# 使用颜色资源
``` swift
view.backgroundColor = .bluegrey_100

let buttonAppearance = ZButtonAppearance(.textLinkThin,
                textColor: .blue_100_pressed_disabled)
```