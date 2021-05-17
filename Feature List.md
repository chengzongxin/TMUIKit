[TOC]



# TMUICore
<!-- TMUIKit核心模块，提供基础的设备宏、工具类、全局配置等 -->
#### TMUIAssociatedPropertyDefines

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

#### TMUIConfiguration（主题组件）

- 维护项目全局 UI 配置的单例，通过业务项目自己的 `TMUIConfigurationTemplate` 来为这个单例赋值，而业务代码里则通过 `TMUIConfigurationMacros.h` 文件里的宏来使用这些值。
- `TMUIConfigurationTemplate`实现`TMUIConfigurationTemplateProtocol`，实现相关协议`applyConfigurationTemplate`应用配置，`shouldApplyTemplateAutomatically`指定某个具体配置文件

>  逻辑实现：第一次使用TMUICMI(基本在启动时)，TMUIConfiguration遍历所有（TMUIConfigurationTemplate）模板配置文件，通过`shouldApplyTemplateAutomatically`找到指定的配置文件（一般结合用户偏好存储上次使用的主题），之后调用（applyConfigurationTemplate）应用配置，在这个方法内为全局单例TMUIConfiguration每个属性赋值，并且这个过程只执行一次，之后就会应用这个配置表来为全局app的定制模板样式


#### TMUIConfigurationMacros（主题组件）

- 作为`TMUIConfiguration`的单例接口，提供一系列方便书写的宏，以便在代码里读取配置表的各种属性。


#### TMUIConfigurationTemplate（主题组件）
- 提供一份模板用于为 `TMUIConfiguration` 单例赋值，业务项目应该将 `TMUIConfigurationTemplate` 文件复制到业务项目里或继承该类，修改赋值后调用 `applyConfigurationTemplate` 方法以生效。


#### TMUICoreGraphicsDefines

- 屏幕适配相关的内联函数，例如数获取状态栏、导航栏的高度等
- 布局相关的函数，例如浮点数的像素取整计算、CGPoint、CGRect、UIEdgeIntents 的便捷操作等。
- 结构体操作（CGPoint、CGSize、CGRect、UIEdgeInset）、安全检查、isNan，isInfi等，以免出现crash。

#### TMUIHelper

- 私有类，内部具体实现设备信息获取方法，给外部提供宏访问通道接口
- 用一个 identifier 标记某一段 block，使其对应该 identifier 只会被运行一次
- 对设备键盘的管理，包括获取全局键盘显示状态、记录最后一次键盘的高度、从键盘事件的 `NSNotification` 对象中快速获取相关的信息。
- 对设备的听筒/扬声器的管理。
- 获取设备信息，包括设备类型、屏幕尺寸等。
- 管理设备的状态栏及当前 window 的 `dimmend` 状态(置灰)。

#### TMUIInitMacro

- UIView及NSObject的子类实现相关init方法时提取相关重复代码定义宏

#### TMUIKitDefines

- 主题元素相关：颜色、字体、图片的创建UIKit库里基础对象的便捷宏

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

# TMUIWidgets
<!-- TMUIKit基础模块，主要继承UIKit，扩展组件的自定义实现，实现更加强大的功能 -->
#### TMUIButton

- 支持让文字和图片自动跟随 tintColor 变化（系统的 UIButton 默认是不响应 tintColor 的）
- highlighted、disabled 状态均通过改变整个按钮的alpha来表现，无需分别设置不同 state 下的 titleColor、image。
- 支持点击时改变背景色颜色（highlightedBackgroundColor）
- 支持点击时改变边框颜色（highlightedBorderColor）
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

#### TMUISegmentedControl

- TMUISegmentedControl，继承自 UISegmentedControl

- 如果需要更大程度地修改样式，比如说字体大小，选中的 segment 的文字颜色等等

- TMUISegmentedControl 也同样支持使用图片来做样式。



# TMUIExtensions
<!-- TMUIKit主要部分，提供便捷、高效的分类,为TMUIComponent组件库和项目工程使用 -->
## UIKit

#### UIView+TMUI

- Frame 属性快速访问
- 提供View 状态、尺寸的改变回调
- 设置圆角、阴影、渐变、边框等外观
- 快速添加各种手势事件、扩大响应范围
- 坐标系转换
- 创建各种简单的动画效果
- 截屏
- xib便捷创建

#### UIView+TMUIBorder
- UIView (TMUIBorder) 为 UIView 方便地显示某几个方向上的边框

#### UILable+TMUI

- 快捷设置富文本属性
- 计算文本size
- 支持部分文字点击效果、点击回调、扩大点击区域

#### UIButton+TMUI

- 便捷的通用设置方法
- 设置图片位置、图文间距
- 扩大点击区域

#### UIViewController+TMUI

- 获取最上层vc、全局设置导航栏显示隐藏、导航控制器中上一个viewcontroller、导航控制器中下一个viewcontroller
- 提供可自定义个数的Alert、sheet弹窗

#### UITextField+TMUI

- 设置 placeHolder 颜色和字体
- 设置最大文本输入长度
- 文本输入回调、超出限制回调

#### UIImage+TMUI

- 从bundle获取图片、提供几种常用图片、颜色创建图片等
- 以block回调形式，给定上下文绘制图片
- 设置图片外观、置灰、转向、透明度
- 图片压缩、裁剪尺寸、修复方向等

#### CALayer+TMUI

- frame、tranform属性快速访问、修改
- 移除默认动画、不带动画修改layer属性
- 判断是否为自带layer、暂停，恢复动画
- 生成虚线、添加阴影效果
- 截屏

#### CAAnimation+TMUI

- 支持用 block 的形式添加对 animationDidStart 和 animationDidStop 的监听，无需自行设置 delegate

#### UIBarButtonItem+TMUI

- UIBarButtonItem便捷构造文本、图文、高亮、禁用等状态

#### UICollectionView+TMUI

- 便捷注册类或者NIB的Cell，header

#### UIColor+TMUI

- 根据十六进制生成颜色
- 获取指定色值（r、g、b、a）
- 将颜色A变化到颜色B，可通过progress控制变化的程度
- 产生一个随机色

#### UITableView+TMUI

- 便捷注册类或者NIB的Cell
- 便捷获取Cell



## Foundation

#### NSArray+TMUI

- 处理了```__NSArray0、__NSSingleObjectArrayI、__NSArrayI、__NSArrayM```几种情况的数组越界访问
- map、filter、reduce等高阶函数
- 不可变数组增删改操作
- 打乱，逆置

#### NSAttributedString

- 快速创建文字、图片、占位富文本
- 获取富文本尺寸

#### NSBundle+TMUI

- 获取Bundle文件、快捷获取bundle图片

#### NSDate+TMUI

- 根据指定日期获取年、月、日
- 日期判断（今天、明天。。。）
- NSString和NSDate互转等

#### NSDictionary+TMUI

- 不可变字典增、删

#### NSMutableParagraphStyle+TMUI

- 段落便捷构造

#### NSObject+TMUI

- 判断指定的类是否有重写某个父类的指定方法
- 对 super 发送消息
- performSelector方法调用
- 遍历指定 class 的所有成员变量、属性
- 遍历指定的某个类的实例方法、
- 遍历某个 protocol 里的所有方法
- KVC安全访问
- 给对象绑定上另一个对象以供后续取出使用（关联对象另一种形式）
- 对象调试、打印所有属性、方法、变量列表

#### NSString+TMUI

- 字符串转数组
- 字符串截取空白字符
- 字符串转md5
- URL转码
- 中文、emoji长度处理
- 针对单个字符处理、部分字符正则操作
- 字符串拼接、int、float转NSString
- 字符串尺寸计算

#### NSURL+TMUI

- 获取当前 query 的参数列表
- 获取query中key对应value

#### ALAssetsLibrary
- 保存图片到指定相册


# TMUIComponents

#### TMUITheme

- 主题管理组件，可添加自定义的主题对象，并为每个对象指定一个专门的 identifier，当主题发生变化时，会遍历 UIViewController 和 UIView，调用每个 viewController 和每个可视 view 的 tmui_themeDidChangeByManager:identifier:theme: 方法，在里面由业务去自行根据当前主题设置不同的外观（color、image 等）

#### TMUIAppearance

- UIKit 仅提供了对 UIView 默认的 UIAppearance 支持，如果你是一个继承自 NSObject 的对象，想要使用 UIAppearance 能力，按 UIKit 公开的 API 是无法实现的，而 TMUIAppearance 对这种场景提供了支持。

#### TMUIModalPresentationViewController

- 一个提供通用的弹出浮层功能的控件，可以将任意`UIView`或`UIViewController`以浮层的形式显示出来并自动布局。
- 支持 3 种方式显示浮层、3种显示动画、appearance全局配置
- 新起一个 `UIWindow` 盖在当前界面上（推荐）
- 使用系统 `presentViewController` 接口来显示，支持界面切换
- 将浮层作为一个 subview 添加到 `superview` 上

#### TMUITableView

- UITableView 简单自定义,基于系统的UITableViewCell，可自由控制ImageView，TextLabel，DetailLabel，AccessorImageView基本元素，以及分割线缩进
- 包含3种TableView样式，plain，group，insetGroup,兼容各个系统版本，简单自定义的TMUITableViewHeaderFooterView
- 缓存行高，优化性能，只需要在cell内部计算一次（实现`sizeThatFits`方法计算高度），外部自动调用缓存，无须再使用类方法计算高度，支持动态更新cell高度

#### TMUICellHeightCache
- 使用行高缓存组件，提高列表性能，组件提供自动缓存行高，在一个方法内部计算cell高度
- 这套方式的好处是 tableView 能直接操作 cell 的实例，cell 无需增加额外的专门用于获取 cell 高度的方法。并且这套方式支持基本的高度缓存（可按 key 缓存或按 indexPath 缓存），若使用了缓存，请注意在适当的时机去更新缓存（例如某个 cell 的内容发生变化，可能 cell 的高度也会变化，则需要更新这个 cell 已被缓存起来的高度)

#### TMUIMultipleDelegates
- 让所有 NSObject 都支持多个 delegate，默认只支持属性名为 delegate 的 delegate（特别地，UITableView 和 UICollectionView 额外默认支持 dataSource）。

#### TMUIBadge

- 用于在`View`、`UIBarButtonItem`、`UITabBarItem` 上显示未读数（badge）和未读红点（updatesIndicator），且对设置的时机无要求，不用担心 `valueForKey:@"view"` 返回 nil 的情况。
- 支持通过 `contentMode` 属性修改子 View 的对齐方式，目前仅支持 `UIViewContentModeLeft` 和 `UIViewContentModeRight`，默认为 `UIViewContentModeLeft`

#### TMUIFloatLayoutView

- 流式布局容器组件，相较于`UICollectionView`更加简便易用，结合`TMUISelfSizeing`可自适应高度，内部添加任意`View`，可以自动适应尺寸，如果要自定义每个`child`的尺寸，需要实现`sizeThatFit:`方法

#### TMUIMultiDelegates

- 对于系统的协议一般只能设置一个代理，这个组件支持同时设置多个代理回调，并且支持自定义的协议实现多代理

#### TMUIPageViewController

- 数据源驱动代理设计模式
- 内部支持滑动吸顶header
- 支持自定义tabs
- 支持动态tabs刷新子VC和header

#### TMShowBigImageViewController
- 大图浏览组件，提供基础的转场动画和大图切换功能

#### TMContentPicker

- 包含多种业务场景下选择器
- 单列选择器`TMNormalPicker`
- 多列选择器`TMMultiDataPicker`
- 多种格式的时间选择器`TMDatePicker`
- 自定义数据选择器`TMCityPicker`

#### TMPopoverView

- 提供类似系统UIPopoverController的显示效果的视图类


#### ChainUI

- 链式UI、一切对象都可以用''`.`语法''一直'"`.`"'下去，点到你停不下来
- 清晰、明了的语法、简洁的API
- 三大核心组件，Styles，CUIStack、GroupTV，进一步提升开发效率
- 丰富的宏定义，为后期拓展保驾护航


#### TMActionSheet
- 封装actionSheet样式的自定义控件
- 包含可自定义的title\message\actions

#### TMContentAlert
- 用于辅助一些内容视图的弹框视图进行展示的工具类

#### TMContentPicker
- 内容picker视图的基类，此基类提供通用最全的相关设置和回调

#### TMCityPicker
- 城市选择器

#### TMDatePicker
- 日期选择器

#### TMMultiDataPicker
- 多列数据选择器

#### TMNormalPicker
- 普通单一项的选择器，一般只有一列数据供选择

#### TMEmptyView
- 空态提示视图

#### TMPopoverView
- 提供类似系统UIPopoverController的显示效果的视图类

#### TMSearchController
- 模拟的假的导航条视图,高度及位置与真实导航条一致，用于在搜索状态时承载searchBar的显示，显示时search高度会自动调整为44高且底部对齐，左右会撑满

#### TMToast
- Toast组件