# 图标资源

图标资源概况：
- 矢量图标：SVG 格式
- 位图图标：JPG、PNG 格式

# 使用矢量图标
``` swift
// 快速使用图标
button.icon = .icon_back
// 使用 UIImageView 加载图标
imageView.bounds.size = CGSize(20, 20) // SVG 图标根据容器大小自动调整
imageView.setImage(withURL: .icon_left)
imageView.setIconColor(.blue_100) // 仅 SVG 图标有效
```

# 夜间模式
- 矢量图标中使用动态颜色，不需要处理夜间模式
