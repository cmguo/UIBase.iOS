# 单选框
单选框控件

# 单选框的使用
``` swift
let button = ZRadioButton(text: text)
button.checked = true
button.addTarget(self, action: #selector(changed(_:)), for: .valueChanged)
```

# 单选框分组管理
``` swift
private let radioGroup = ZRadioGroup()

radioGroup.addRadioButton(button)
```