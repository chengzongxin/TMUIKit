# TMUICore

#### TMAssociatedPropertyMacro

- 生成属性`@property`
- 关联对象

#### TMCoreGraphicsDefines

- `CoreGraphics`结构体安全检查
- 结构体快速设置方法
- 设备适配相关、屏幕尺寸、分辨率、结构体操作、异常处理等

#### TMInitMacro

- 初始化宏`TM_INIT_View_Override`

#### TMUICommonDefines

- 设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。

- 布局相关的宏，例如快速获取状态栏、导航栏的高度，为不同的屏幕大小使用不同的值，代表 1px 的宏等。

- 常用方法的快速调用，例如读取图片、创建字体对象、创建颜色等。

- 数学计算相关的宏，例如角度换算等。

- 布局相关的函数，例如浮点数的像素取整计算、CGPoint、CGRect、UIEdgeIntents 的便捷操作等。

- 运行时相关的函数，例如 swizzle 方法替换、动态添加方法等。

#### TMUIMultipleDelegates

- Objective-C 的 Delegate 设计模式里，一个 delegate 仅支持指向一个对象，这为接口设计带来很大的麻烦（例如你很难做到在 textField 内部自己管理可输入的最大字符的限制的同时，又支持外部设置一个自己的 delegate），因此提供了这个控件，支持同时将 delegate 指向多个 object。

