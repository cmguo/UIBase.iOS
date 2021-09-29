# 开关
开关控件

# 开关的使用
``` swift
let button = ZSwitchButton()
button.isOn = state as! Bool
button.addTarget(self, action: #selector(changed(_:)), for: .valueChanged)
```
