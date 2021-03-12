## TMUI Widgets

#### TMUIButton

- 支持让文字和图片自动跟随 tintColor 变化（系统的 UIButton 默认是不响应 tintColor 的）
-  highlighted、disabled 状态均通过改变整个按钮的alpha来表现，无需分别设置不同 state 下的 titleColor、image。
- 支持点击时改变背景色颜色（highlightedBackgroundColor）
-  支持点击时改变边框颜色（highlightedBorderColor）
- 支持设置图片相对于 titleLabel 的位置（imagePosition）
- 支持设置图片和 titleLabel 之间的间距，无需自行调整 titleEdgeInests、imageEdgeInsets（spacingBetweenImageAndTitle）

#### TMUILabel

- 控制label内容的padding
- 设置是否需要长按复制的功能

#### TMUITextField

- 自定义 placeholderColor
- 支持限制输入的文字的长度、超过时回调
- 设置TextField内容Inset
- clearButton位置偏移

#### TMUITextView

- 支持 placeholder 并支持更改 placeholderColor；若使用了富文本文字，则 placeholder 的样式也会跟随文字的样式（除了 placeholder 颜色）
- 支持在文字发生变化时计算内容高度并通知 delegate
- 支持限制输入框最大高度，一般配合第 2 点使用
- 支持限制输入的文本的最大长度，默认不限制
- 修正系统 UITextView 在输入时自然换行的时候，contentOffset 的滚动位置没有考虑 textContainerInset.bottom

#### TMUISlider

- 修改背后导轨的高度
- 修改圆点的大小
- 修改圆点的阴影样式





## TMUI Extensions

#### UIView+TMUI

- Frame 属性快速访问
- 设置圆角、阴影、渐变、边框等外观
- 快速添加各种手势事件、扩大响应范围
- 创建各种简单的动画效果
- xib便捷创建

#### UILable+TMUI

- 设置富文本属性
- 计算文本size
- 富文本超链接
- 支持部分文字点击回调、扩大点击区域

#### UIButton+TMUI

- 设置图片位置、图文间距、扩大点击区域

#### UIViewController+TMUI

- 获取最上层vc、全局设置导航栏显示隐藏、导航控制器中上一个viewcontroller、导航控制器中下一个viewcontroller

#### UITextField+TMUI

- 设置最大文本输入长度、设置 placeHolder 颜色和字体、文本回调

#### UIImage+TMUI

- 设置图片外观
- 图片创建、压缩、裁剪





## TMUIComponents

#### TMPageViewController

- 简单代理实现滑动吸顶header，动态tab子VC

## ChainUI

- 链式UI







## TMUICore

#### TMAssociatedPropertyMacro

- 针对在类型里添加属性的相关便捷宏定义,提供三种方式快捷关联对象
- 方式一：需要传入var类型
- 方式二：包含各种数据类型可供选择,id,weak,copy,基本类型等。
- 方式三：TMUIWeakObjectContainer使用弱引用容器类，避免关联对象释放产生野指针crash。

#### TMUICommonDefines

- 设备相关的宏，例如区分当前设备是 iPhone、iPad 或是模拟器，获取当前设备的横竖屏状态、屏幕信息等。
- 编译相关的宏，例如判断是否处于 `DEBUG` 模式，当前编译环境使用的 SDK 版本，忽略某些常见的 warning 等。
- 布局相关的宏，例如快速获取状态栏、导航栏的高度，为不同的屏幕大小使用不同的值，代表 1px 的宏等。
- 数学计算相关的宏，例如角度换算等。
- 根据给定的 getter selector 获取对应的 setter selector、判断字符串是否为空等。
- 单例、懒加载、TMUI_weakify、TMUI_strongify

#### TMUIKitDefines

- 主题元素相关：颜色、字体、图片的创建UIKit库里基础对象的便捷宏

#### TMCoreGraphicsDefines

- 屏幕适配相关的内联函数，例如数获取状态栏、导航栏的高度等
- 布局相关的函数，例如浮点数的像素取整计算、CGPoint、CGRect、UIEdgeIntents 的便捷操作等。
- 结构体操作（CGPoint、CGSize、CGRect、UIEdgeInset）、安全检查、isNan，isInfi等，以免出现crash。

#### TMInitMacro

- UIView及NSObject的子类实现相关init方法时提取相关重复代码定义宏

#### TMUIHelper

- 私有类，内部具体实现设备信息获取方法，给外部提供宏访问通道接口
- 用一个 identifier 标记某一段 block，使其对应该 identifier 只会被运行一次
- 对设备键盘的管理，包括获取全局键盘显示状态、记录最后一次键盘的高度、从键盘事件的 `NSNotification` 对象中快速获取相关的信息。
- 对设备的听筒/扬声器的管理。
- 获取设备信息，包括设备类型、屏幕尺寸等。
- 管理设备的状态栏及当前 window 的 `dimmend` 状态(置灰)。

#### TMUIRuntime

- 运行时相关的函数，例如 swizzle 方法替换、动态添加方法等
- 获取类的某个属性信息、值
- 判断是否重写父类方法
- 交换两个类的方法、单个类的方法（会先判断原有方法是否存在，以免调用空方法crash）
- 用 block 重写某个 class 的指定方法，自定义实现细节
- 用 block 重写某个 class 的某个的方法，会自动在调用 block 之前先调用该方法原本的实现
- 判断Ivar 是哪种类型、获取Ivar的值

#### TMUIWeakObjectContainer

- 弱持有对象容器，避免强引用的同时，也避免野指针crash。
- 适用定时器、弱关联属性

#### TMUIMultipleDelegates

- 让对象支持多个delegate、支持自定义的delegate





