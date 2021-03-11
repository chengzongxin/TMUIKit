## TMUI Widgets

#### TMUIButton

- 设置图片、文字位置、图文间距

#### TMUILabel

- 设置Label内容inset、设置复制

#### TMUITextField

- 设置TextField内容Inset、clearButton位置、限制文本长度

#### TMUITextView

- TextView设置placeholder、内容长度限制、inset、高度自适应

#### TMUISlider

- 修改背后导轨的高度、修改圆点的大小、修改圆点的阴影样式





## TMUI EXtensions

#### UIView+TMUI

- 设置圆角、阴影、渐变、边框
- 快速添加各种手势事件
- 创建动画

#### UILable+TMUI

- 设置富文本属性、计算文本size、富文本超链接

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

#### TMUIKitDefines

- 主题：颜色、字体、图片的创建UIKit库里基础对象的便捷宏

#### TMCoreGraphicsDefines

- 布局相关的函数，例如浮点数的像素取整计算、CGPoint、CGRect、UIEdgeIntents 的便捷操作等。
- 结构体操作（CGPoint、CGSize、CGRect、UIEdgeInset）、安全检查、isNan，isInfi等，以免出现crash。

#### TMInitMacro

- 初始化宏

#### TMUIHelper

- 私有类，内部具体实现设备信息获取方法，给外部提供宏访问通道接口

#### TMUIRuntime

- 运行时相关的函数，例如 swizzle 方法替换、动态添加方法等
- 获取类的某个属性信息
- 判断是否重写父类方法
- 交换两个类的方法
- 用 block 重写某个 class 的指定方法
- 判断Ivar 是哪种类型、获取Ivar的值

#### TMUIWeakObjectContainer

- 弱持有对象容器，避免强引用的同时，也避免野指针crash。

#### TMUIMultipleDelegates

- 让对象支持多个delegate、支持自定义的delegate





