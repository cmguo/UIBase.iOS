# 头像
头像控件是基于 ImageView 实现的，额外提供下列特性
- 前景剪裁，背景保留不变
- 当留有边距时（因为等比缩放等原因），可以仅剪裁前景内容区域
- 支持圆形（椭圆），圆角矩形（包括矩形、正方形、圆角正方形）两种方式剪裁
- 支持不规则圆角

# 头像的使用
``` xml
<com.eazy.uibase.widget.ZAvatarView
    android:id="@+id/avatarView"
    android:layout_width="200dp"
    android:layout_height="150dp"
    android:background="@color/brand_500"
    android:src="@drawable/component"
    app:clipType="circle"
    app:clipRegion="roundRect"
    app:cornerRadius="8dp"
    app:borderWidth="1dp"
    app:borderColor="@color/red"
    />
```

# 不规则圆角
``` kotlin
// 仅左上、右上有圆角效果
imageView.cornerRadii = floatArrayOf(8f, 8f, 8f, 8f, 0f, 0f, 0f, 0f)
```
