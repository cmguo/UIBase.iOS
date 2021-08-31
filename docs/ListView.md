# 列表视图

提供下列功能：
- 数据封装：RecyclerList，树形数据：RecyclerTreeList，支持数据编辑、变化通知
- 数据视图绑定机制 ItemBinding；单一视图类型：UnitItemBinding，多样视图类型 BaseItemBinding
- 通用列表适配器：支持托管点击回调、空视图、数据更新
- 各种列表装饰器：填充，分割线，支持快速扩展，支持树形数据
- 简单列表：ZListView，封装 RecylcerView，提供标准化视图


# 普通列表使用
```xml
<androidx.recyclerview.widget.RecyclerView
        android:id="@+id/listView"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:data="@{model.colors}" // 任意类型的列表数据
        app:layoutManager="@{LayoutManagers.linear(0, false)}" // 上下线性布局
        app:itemBinding="@{@layout/view_item}" // Item 的布局，也可以绑定 ItemBinding 类型的对象
        app:emptyItemBinding="@{layout/list_empty_view}" // 列表数据为空时，显示的布局视图
        app:itemDecoration="@{ItemDecorations.divider(1)}" // 分割线装饰，底部 1dp
        app:itemClicked="@{fragment.itemClicked}" // Item 点击处理
        />
```

# 视图数据绑定
* 参考视图布局
``` xml
<?xml version="1.0" encoding="utf-8"?>
<layout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools">
    <data>
        <variable
            name="data"
            type="String" />
        <variable
            name="viewModel"
            type="Object" />
    </data>
    <TextView
        android:id="@+id/title"
        android:layout_width="200dp"
        android:layout_height="wrap_content"
        android:text="@{data}"
        android:onClick=@{v -> viewModel.onClick()}
        />
</layout>
```
* 单一视图类型 UnitItemBinding
``` kotlin
// 动态绑定，数据绑定到 data 变量，交互逻辑绑定到 viewModel 变量
val itemBinding = object : UnitItemBinding(R.layout.item) {
    @Override
    public Object createViewModel(Object item) {
        return ViewModel(item);
    }
}
// 自定义动态绑定 Id
itemBinding.setBindVariable(BR.item, BR.vm)
// 通过 app:itemBinding="@{itemBinding}" 绑定到列表
```
* 多样视图类型 BaseItemBinding
``` kotlin
val itemBinding = object : BaseItemBinding() {
    @Override
    public int getItemViewType(Object item) {
        if (item is A) {
            return R.layout.item_a
        } else {
            return R.layout.item_b
        }
    }
    @Override
    public void bindView(ViewDataBinding binding, Object item, int position) {
        super.bindView(binding, item, position);
        // 自定义绑定行为
        binding.setVariable(BR.styles, styles);
    }
}
```
* 退化为 ViewHolder（与 ViewHolder 不同在与，整个列表只对应一个实例）
``` kotlin
// item2.xml 不是 layout 动态绑定
val itemBinding = object : UnitItemBinding(R.layout.item2) {
    @Override
    protected void bindView(View view, Object item, int position) {
        val textView = view.findItemById(R.id.textView) as TextView
        textView.text = item.toString()
    }
}
```

# 列表装饰器
* 在代码中使用
``` kotlin
val decoration = ItemDecorations.divider(1f,
        ContextCompat.getColor(context, R.color.blue_100)).build(this)
recylerView.addItemDecoration(decoration)
```
* 在 databinding 中使用
``` xml
<androidx.recyclerview.widget.RecyclerView
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:itemDecoration="@{ItemDecorations.dividerPx(@dimen/activity_view_item_padding)}"
    />
```
* 自定义装饰器
``` java
public class MyDecoration extends BaseDecoration {
    @Override
    protected void getItemOffsets(Rect outRect, int type) {
        outRect.set(10, 0, 10, 0); // 上下各填充 10 px
    }
    @Override
    protected void drawChildDecoration(@NotNull Canvas c, @NotNull View child, int type) {
        // Item 背景图片，包括填充区域
        mBackground.setBounds(childRect);
        mBackground.draw(c);
    }
}
```

# 简单列表 ZListView
* 标准列表项目视觉

![listView.png](images/listView.png)
* 列表数据定义
``` kotlin
class ResourceColorItem(private val key: String, private val value: Resources.ResourceValue) : ZListItemView.Data {
    override val title: String
        get() = key
    override val subTitle: String?
        get() = if (key.contains("600")) null else Colors.text(value.value)
    override val icon: Any
        get() = ColorDrawable(value.value)
    override val contentType: ZListItemView.ContentType?
        get() = when (key) {
            "blue_100" -> ZListItemView.ContentType.Button
            "bluegrey_100", "bluegrey_300"-> ZListItemView.ContentType.CheckBox
            "bluegrey_800", "bluegrey_900" -> ZListItemView.ContentType.RadioButton
            "brand_600" -> ZListItemView.ContentType.TextField
            "red_600" -> ZListItemView.ContentType.SwitchButton
            else -> null
        }
    override val content: Any?
        get() = when (key) {
            "blue_100" -> R.array.button_icon_text
            "bluegrey_800" -> true
            "brand_600" -> "请输入"
            else -> null
        }
    override val badge: Any?
        get() = null

}
// 使用数据
listView.data = colors.map { ResourceColorItem(Colors.simpleName(it.key), it.value) }
```

# 树形数据展示
* 树形数据绑定 RecyclerTreeList
``` kotlin
val data : List<T>
val treeList = object : RecyclerTreeList<T>(data) {
    // 只要实现这个就可用了
    override fun getChildren(T item) : Iterator<T> {
        return item.children.iterator()
    }
}
// 也可以在 xml 通过 app:data="@{treeList}" 绑定
(recylerView.adpater as RecylerViewAdpater).setItems(treeList)
```
* 树形列表装饰器
``` kotlin
val decoration = ItemDecorations.Builder {
    object : BackgroundDecoration(10f, Color.GRAY, true) {
        val paint = Paint()
        val colors = intArrayOf(Color.RED, Color.GREEN, Color.BLUE)
        override fun drawTreeDecoration(c: Canvas, position: IntArray?, level: Int) {
            // 不同层级，画不同的背景颜色
            paint.color = colors[level]
            val rect = RectF(outRect)
            rect.inset(10f, 20f)
            c.drawRoundRect(rect, 20f, 20f, paint)
        }
        override fun getTreeOffsets(treeRect: Rect, position: IntArray?, level: Int) {
            treeRect[20, 40, 20] = 40 // 设置树视图填充尺寸
        }
    }
}
```

# 数据编辑
* 普通列表数据 RecyclerList
``` kotlin
// RecylerViewAdpater 默认就是通过 RecyclerList 实现数据管理
val recyclerList = (recylerView.adpater as RecylerViewAdpater).getItems()
// 操作数据，列表会自动更新
recyclerList.clear()
recyclerList.add(Item())
recyclerList.move(1, 0) // 移动 Item 1 到位置 0
```

* 树形数据 RecyclerTreeList
``` kotlin
val treeList = object : RecyclerTreeList<T>() {
    // 只要实现这个就可用了
    override fun getChildren(T item) : Iterator<T> {
        return item.children.iterator()
    }
}
(recylerView.adpater as RecylerViewAdpater).setItems(treeList)
// ...
// 操作数据，列表会自动更新
val item: T
treeList.add(item)
treeList.remove(0) // 删除第一的子树
treeList.getSubTree(1).move(1, 0) // 移动第二个子树的子节点，第二个子节点移动到所在树的最前面
```
