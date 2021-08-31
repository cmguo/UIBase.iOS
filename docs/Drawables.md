# 图标资源

图标资源概况：
- 矢量图标：Vector（SVG）格式
- 位图图标：PNG 格式
- 圆角图标：RoundDrawable 通过 style 描述
- 视图图标：ViewDrawable（通过视图布局 layout 描述图标）

# 使用矢量图标

兼容性：在 SDK 21 ～ 24，使用 Vector，需要做下列工作：
- 每个library需要分别配置开关：vectorDrawables.useSupportLibrary = true
``` gradle
android {
    defaultConfig {
        vectorDrawables.useSupportLibrary = true
    }
}
```
- 通过代码加载，AppCompatResources.getDrawable
``` java
public class Drawables {
    @Nullable
    public static Drawable getDrawable(@NonNull Context context, @DrawableRes int resId) {
        return AppCompatResources.getDrawable(context, resId);
    }
}
```
- 在 layout 中使用 AppCompatImageView，否则用下面第2种方法兼容
``` xml
<AppCompatImageView
    android:id="@+id/image"
    android:layout_width="100dp"
    android:layout_height="100dp"
    android:layout_gravity="center_horizontal"
    android:src="@drawable/icon_weblink" />
```
- 使用 app:srcCompat、app:drawableLeftCompat 等间接使用 AppCompatResources
``` xml
<ImageView
    android:id="@+id/image"
    android:layout_width="100dp"
    android:layout_height="100dp"
    android:layout_gravity="center_horizontal"
    app:srcCompat="@drawable/icon_weblink" />
```

# 使用圆角图标
* 自定义圆角图标（通过 style），可以减少 drawables 文件，并可以利用 style 继承特性批量定义
``` xml
<style name="RoundDrawable.ZNumberView_Background">
    <item name="fillColor">@color/number_view_background_color</item>
    <item name="cornerRadius">@dimen/number_view_radius</item>
</style>
```
* 引用圆角图标
``` xml
<!-- 注意：仅部分基础控件支持 RoundDrawable -->
<style name="ZDialog">
    <item name="background">@style/RoundDrawable.Dialog</item>
</style>
```
``` kotlin
background = RoundDrawable(context, R.style.RoundDrawable_ZNumberView_Background)
```

# 使用视图图标
``` kotlin
val drawable = ViewDrawable(fragment.requireContext(), R.layout.avatar_text)
```

# 夜间模式
- 矢量图标中使用动态颜色，不需要处理夜间模式
- 位图图标在 drawbles-night-xxx 目录存在夜间模式图标
