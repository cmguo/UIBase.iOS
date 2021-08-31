# 复选框

复选框控件具有下列特性：
- 半选 HalfChecked 状态
- 状态可 DataBinding 双向绑定

# 使用复选框
``` swift
let checkBox = ZCheckBox(text: text)
checkBox.checkedState = .checked
checkBox.addTarget(self, action: #selector(changed(_:)), for: .valueChanged)
```
