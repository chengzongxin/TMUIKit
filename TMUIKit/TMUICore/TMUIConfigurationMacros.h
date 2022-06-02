//
//  TMUIConfigurationMacros.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//


#import "TMUIConfiguration.h"


/**
 *  提供一系列方便书写的宏，以便在代码里读取配置表的各种属性。
 *  @warning 请不要在 + load 方法里调用 TMUIConfigurationTemplate 或 TMUIConfigurationMacros 提供的宏，那个时机太早，可能导致 crash
 *  @waining 维护时，如果需要增加一个宏，则需要定义一个新的 TMUIConfiguration 属性。
 */


// 单例的宏

#define TMUICMI ({[[TMUIConfiguration sharedInstance] applyInitialTemplate];[TMUIConfiguration sharedInstance];})

/// 标志当前项目是否正使用配置表功能
#define TMUICMIActivated            [TMUICMI active]

#pragma mark - Global Color

// 基础颜色
#define UIColorClear                [TMUICMI clearColor]
#define UIColorWhite                [TMUICMI whiteColor]
#define UIColorBlack                [TMUICMI blackColor]
#define UIColorGray                 [TMUICMI grayColor]
#define UIColorGrayDarken           [TMUICMI grayDarkenColor]
#define UIColorGrayLighten          [TMUICMI grayLightenColor]
#define UIColorRed                  [TMUICMI redColor]
#define UIColorGreen                [TMUICMI greenColor]
#define UIColorBlue                 [TMUICMI blueColor]
#define UIColorYellow               [TMUICMI yellowColor]

// 功能颜色
#define UIColorLink                 [TMUICMI linkColor]                       // 全局统一文字链接颜色
#define UIColorDisabled             [TMUICMI disabledColor]                   // 全局统一文字disabled颜色
#define UIColorForBackground        [TMUICMI backgroundColor]                 // 全局统一的背景色
#define UIColorMask                 [TMUICMI maskDarkColor]                   // 全局统一的mask背景色
#define UIColorMaskWhite            [TMUICMI maskLightColor]                  // 全局统一的mask背景色，白色
#define UIColorSeparator            [TMUICMI separatorColor]                  // 全局分隔线颜色
#define UIColorSeparatorDashed      [TMUICMI separatorDashedColor]            // 全局分隔线颜色（虚线）
#define UIColorPlaceholder          [TMUICMI placeholderColor]                // 全局的输入框的placeholder颜色

// 测试用的颜色
#define UIColorTestRed              [TMUICMI testColorRed]
#define UIColorTestGreen            [TMUICMI testColorGreen]
#define UIColorTestBlue             [TMUICMI testColorBlue]

#pragma mark - UILabel

#define UIColorMain                 [TMUICMI mainColor]                        // 小面积使用，用于特别需要强调的文字、按钮和图标
#define UIColorTextImportant        [TMUICMI textImportantColor]               // 用于重要级文字信息，页内标题信息
#define UIColorTextRegular          [TMUICMI textRegularColor]                 // 用于一般文字信息，正文或常规文字
#define UIColorTextWeak             [TMUICMI textWeakColor]                    // 用于辅助、次要、弱提示类的文字信息
#define UIColorTextPlaceholder      [TMUICMI textPlaceholderColor]             // 用于占位文字


// 可操作的控件
#pragma mark - UIControl

#define UIControlHighlightedAlpha       [TMUICMI controlHighlightedAlpha]          // 一般control的Highlighted透明值
#define UIControlDisabledAlpha          [TMUICMI controlDisabledAlpha]             // 一般control的Disable透明值

// 按钮
#pragma mark - UIButton
#define ButtonHighlightedAlpha          [TMUICMI buttonHighlightedAlpha]           // 按钮Highlighted状态的透明度
#define ButtonDisabledAlpha             [TMUICMI buttonDisabledAlpha]              // 按钮Disabled状态的透明度
#define ButtonTintColor                 [TMUICMI buttonTintColor]                  // 普通按钮的颜色

//#define GhostButtonColorBlue            [TMUICMI ghostButtonColorBlue]              // TMUIGhostButtonColorBlue的颜色
//#define GhostButtonColorRed             [TMUICMI ghostButtonColorRed]               // TMUIGhostButtonColorRed的颜色
//#define GhostButtonColorGreen           [TMUICMI ghostButtonColorGreen]             // TMUIGhostButtonColorGreen的颜色
//#define GhostButtonColorGray            [TMUICMI ghostButtonColorGray]              // TMUIGhostButtonColorGray的颜色
//#define GhostButtonColorWhite           [TMUICMI ghostButtonColorWhite]             // TMUIGhostButtonColorWhite的颜色
//
//#define FillButtonColorBlue             [TMUICMI fillButtonColorBlue]              // TMUIFillButtonColorBlue的颜色
//#define FillButtonColorRed              [TMUICMI fillButtonColorRed]               // TMUIFillButtonColorRed的颜色
//#define FillButtonColorGreen            [TMUICMI fillButtonColorGreen]             // TMUIFillButtonColorGreen的颜色
//#define FillButtonColorGray             [TMUICMI fillButtonColorGray]              // TMUIFillButtonColorGray的颜色
//#define FillButtonColorWhite            [TMUICMI fillButtonColorWhite]             // TMUIFillButtonColorWhite的颜色

#pragma mark - TextInput
#define TextFieldTextColor              [TMUICMI textFieldTextColor]               // TMUITextField、TMUITextView 的文字颜色
#define TextFieldTintColor              [TMUICMI textFieldTintColor]               // TMUITextField、TMUITextView 的tintColor
#define TextFieldTextInsets             [TMUICMI textFieldTextInsets]              // TMUITextField 的内边距
#define KeyboardAppearance              [TMUICMI keyboardAppearance]

#pragma mark - UISwitch
#define SwitchOnTintColor               [TMUICMI switchOnTintColor]                 // UISwitch 打开时的背景色（除了圆点外的其他颜色）
#define SwitchOffTintColor              [TMUICMI switchOffTintColor]                // UISwitch 关闭时的背景色（除了圆点外的其他颜色）
#define SwitchTintColor                 [TMUICMI switchTintColor]                   // UISwitch 关闭时的周围边框颜色
#define SwitchThumbTintColor            [TMUICMI switchThumbTintColor]              // UISwitch 中间的操控圆点的颜色

#pragma mark - NavigationBar

#define NavBarContainerClasses                          [TMUICMI navBarContainerClasses]
#define NavBarItemLightColor                            [TMUICMI navBarItemLightColor]  /// item白色
#define NavBarItemThemeColor                            [TMUICMI navBarItemThemeColor]  /// item 主题色
#define NavBarItemDarkColor                             [TMUICMI navBarItemDarkColor]   /// item 黑色
#define NavBarItemFont                                  [TMUICMI navBarItemFont]        /// item 字体
#define NavBarHighlightedAlpha                          [TMUICMI navBarHighlightedAlpha]
#define NavBarDisabledAlpha                             [TMUICMI navBarDisabledAlpha]
#define NavBarButtonFont                                [TMUICMI navBarButtonFont]
#define NavBarButtonFontBold                            [TMUICMI navBarButtonFontBold]
#define NavBarBackgroundImage                           [TMUICMI navBarBackgroundImage]
#define NavBarShadowImage                               [TMUICMI navBarShadowImage]
#define NavBarShadowImageColor                          [TMUICMI navBarShadowImageColor]
#define NavBarBarTintColor                              [TMUICMI navBarBarTintColor]
#define NavBarStyle                                     [TMUICMI navBarStyle]
#define NavBarTintColor                                 [TMUICMI navBarTintColor]
#define NavBarTitleColor                                [TMUICMI navBarTitleColor]
#define NavBarTitleFont                                 [TMUICMI navBarTitleFont]
#define NavBarLargeTitleColor                           [TMUICMI navBarLargeTitleColor]
#define NavBarLargeTitleFont                            [TMUICMI navBarLargeTitleFont]
#define NavBarBarBackButtonTitlePositionAdjustment      [TMUICMI navBarBackButtonTitlePositionAdjustment]
#define NavBarBackIndicatorImage                        [TMUICMI navBarBackIndicatorImage]
#define SizeNavBarBackIndicatorImageAutomatically       [TMUICMI sizeNavBarBackIndicatorImageAutomatically]
#define NavBarCloseButtonImage                          [TMUICMI navBarCloseButtonImage]

#define NavBarLoadingMarginRight                        [TMUICMI navBarLoadingMarginRight]                          // titleView里左边的loading的右边距
#define NavBarAccessoryViewMarginLeft                   [TMUICMI navBarAccessoryViewMarginLeft]                     // titleView里的accessoryView的左边距
#define NavBarActivityIndicatorViewStyle                [TMUICMI navBarActivityIndicatorViewStyle]                  // titleView loading 的style
#define NavBarAccessoryViewTypeDisclosureIndicatorImage [TMUICMI navBarAccessoryViewTypeDisclosureIndicatorImage]   // titleView上倒三角的默认图片


#pragma mark - TabBar

#define TabBarContainerClasses                          [TMUICMI tabBarContainerClasses]
#define TabBarBackgroundImage                           [TMUICMI tabBarBackgroundImage]
#define TabBarBarTintColor                              [TMUICMI tabBarBarTintColor]
#define TabBarShadowImageColor                          [TMUICMI tabBarShadowImageColor]
#define TabBarStyle                                     [TMUICMI tabBarStyle]
#define TabBarItemTitleFont                             [TMUICMI tabBarItemTitleFont]
#define TabBarItemTitleFontSelected                     [TMUICMI tabBarItemTitleFontSelected]
#define TabBarItemTitleColor                            [TMUICMI tabBarItemTitleColor]
#define TabBarItemTitleColorSelected                    [TMUICMI tabBarItemTitleColorSelected]
#define TabBarItemImageColor                            [TMUICMI tabBarItemImageColor]
#define TabBarItemImageColorSelected                    [TMUICMI tabBarItemImageColorSelected]

#pragma mark - Toolbar

#define ToolBarContainerClasses                         [TMUICMI toolBarContainerClasses]
#define ToolBarHighlightedAlpha                         [TMUICMI toolBarHighlightedAlpha]
#define ToolBarDisabledAlpha                            [TMUICMI toolBarDisabledAlpha]
#define ToolBarTintColor                                [TMUICMI toolBarTintColor]
#define ToolBarTintColorHighlighted                     [TMUICMI toolBarTintColorHighlighted]
#define ToolBarTintColorDisabled                        [TMUICMI toolBarTintColorDisabled]
#define ToolBarBackgroundImage                          [TMUICMI toolBarBackgroundImage]
#define ToolBarBarTintColor                             [TMUICMI toolBarBarTintColor]
#define ToolBarShadowImageColor                         [TMUICMI toolBarShadowImageColor]
#define ToolBarStyle                                    [TMUICMI toolBarStyle]
#define ToolBarButtonFont                               [TMUICMI toolBarButtonFont]


#pragma mark - SearchBar

#define SearchBarTextFieldBorderColor                   [TMUICMI searchBarTextFieldBorderColor]
#define SearchBarTextFieldBackgroundImage               [TMUICMI searchBarTextFieldBackgroundImage]
#define SearchBarBackgroundImage                        [TMUICMI searchBarBackgroundImage]
#define SearchBarTintColor                              [TMUICMI searchBarTintColor]
#define SearchBarTextColor                              [TMUICMI searchBarTextColor]
#define SearchBarPlaceholderColor                       [TMUICMI searchBarPlaceholderColor]
#define SearchBarFont                                   [TMUICMI searchBarFont]
#define SearchBarSearchIconImage                        [TMUICMI searchBarSearchIconImage]
#define SearchBarClearIconImage                         [TMUICMI searchBarClearIconImage]
#define SearchBarTextFieldCornerRadius                  [TMUICMI searchBarTextFieldCornerRadius]


#pragma mark - TableView / TableViewCell

#define TableViewEstimatedHeightEnabled                 [TMUICMI tableViewEstimatedHeightEnabled]            // 是否要开启全局 UITableView 的 estimatedRow(Section/Footer)Height

#define TableViewBackgroundColor                        [TMUICMI tableViewBackgroundColor]                   // 普通列表的背景色
#define TableSectionIndexColor                          [TMUICMI tableSectionIndexColor]                     // 列表右边索引条的文字颜色
#define TableSectionIndexBackgroundColor                [TMUICMI tableSectionIndexBackgroundColor]           // 列表右边索引条的背景色
#define TableSectionIndexTrackingBackgroundColor        [TMUICMI tableSectionIndexTrackingBackgroundColor]   // 列表右边索引条按下时的背景色
#define TableViewSeparatorColor                         [TMUICMI tableViewSeparatorColor]                    // 列表分隔线颜色

#define TableViewCellNormalHeight                       [TMUICMI tableViewCellNormalHeight]                  // TMUITableView 的默认 cell 高度
#define TableViewCellTitleLabelColor                    [TMUICMI tableViewCellTitleLabelColor]               // cell的title颜色
#define TableViewCellDetailLabelColor                   [TMUICMI tableViewCellDetailLabelColor]              // cell的detailTitle颜色
#define TableViewCellBackgroundColor                    [TMUICMI tableViewCellBackgroundColor]               // 列表 cell 的背景色
#define TableViewCellSelectedBackgroundColor            [TMUICMI tableViewCellSelectedBackgroundColor]       // 列表 cell 按下时的背景色
#define TableViewCellWarningBackgroundColor             [TMUICMI tableViewCellWarningBackgroundColor]        // 列表 cell 在提醒状态下的背景色

#define TableViewCellDisclosureIndicatorImage           [TMUICMI tableViewCellDisclosureIndicatorImage]      // 列表 cell 右边的箭头图片
#define TableViewCellCheckmarkImage                     [TMUICMI tableViewCellCheckmarkImage]                // 列表 cell 右边的打钩checkmark
#define TableViewCellDetailButtonImage                  [TMUICMI tableViewCellDetailButtonImage]             // 列表 cell 右边的 i 按钮
#define TableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator [TMUICMI tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator]   // 列表 cell 右边的 i 按钮和向右箭头之间的间距（仅当两者都使用了自定义图片并且同时显示时才生效）

#define TableViewSectionHeaderBackgroundColor           [TMUICMI tableViewSectionHeaderBackgroundColor]
#define TableViewSectionFooterBackgroundColor           [TMUICMI tableViewSectionFooterBackgroundColor]
#define TableViewSectionHeaderFont                      [TMUICMI tableViewSectionHeaderFont]
#define TableViewSectionFooterFont                      [TMUICMI tableViewSectionFooterFont]
#define TableViewSectionHeaderTextColor                 [TMUICMI tableViewSectionHeaderTextColor]
#define TableViewSectionFooterTextColor                 [TMUICMI tableViewSectionFooterTextColor]
#define TableViewSectionHeaderAccessoryMargins          [TMUICMI tableViewSectionHeaderAccessoryMargins]
#define TableViewSectionFooterAccessoryMargins          [TMUICMI tableViewSectionFooterAccessoryMargins]
#define TableViewSectionHeaderContentInset              [TMUICMI tableViewSectionHeaderContentInset]
#define TableViewSectionFooterContentInset              [TMUICMI tableViewSectionFooterContentInset]

#define TableViewGroupedBackgroundColor                 [TMUICMI tableViewGroupedBackgroundColor]               // Grouped 类型的 TMUITableView 的背景色
#define TableViewGroupedSeparatorColor                  [TMUICMI tableViewGroupedSeparatorColor]                // Grouped 类型的 TMUITableView 分隔线颜色
#define TableViewGroupedCellTitleLabelColor             [TMUICMI tableViewGroupedCellTitleLabelColor]           // Grouped 类型的列表的 TMUITableViewCell 的标题颜色
#define TableViewGroupedCellDetailLabelColor            [TMUICMI tableViewGroupedCellDetailLabelColor]          // Grouped 类型的列表的 TMUITableViewCell 的副标题颜色
#define TableViewGroupedCellBackgroundColor             [TMUICMI tableViewGroupedCellBackgroundColor]           // Grouped 类型的列表的 TMUITableViewCell 的背景色
#define TableViewGroupedCellSelectedBackgroundColor     [TMUICMI tableViewGroupedCellSelectedBackgroundColor]   // Grouped 类型的列表的 TMUITableViewCell 点击时的背景色
#define TableViewGroupedCellWarningBackgroundColor      [TMUICMI tableViewGroupedCellWarningBackgroundColor]    // Grouped 类型的列表的 TMUITableViewCell 在提醒状态下的背景色
#define TableViewGroupedSectionHeaderFont               [TMUICMI tableViewGroupedSectionHeaderFont]
#define TableViewGroupedSectionFooterFont               [TMUICMI tableViewGroupedSectionFooterFont]
#define TableViewGroupedSectionHeaderTextColor          [TMUICMI tableViewGroupedSectionHeaderTextColor]
#define TableViewGroupedSectionFooterTextColor          [TMUICMI tableViewGroupedSectionFooterTextColor]
#define TableViewGroupedSectionHeaderAccessoryMargins   [TMUICMI tableViewGroupedSectionHeaderAccessoryMargins]
#define TableViewGroupedSectionFooterAccessoryMargins   [TMUICMI tableViewGroupedSectionFooterAccessoryMargins]
#define TableViewGroupedSectionHeaderDefaultHeight      [TMUICMI tableViewGroupedSectionHeaderDefaultHeight]
#define TableViewGroupedSectionFooterDefaultHeight      [TMUICMI tableViewGroupedSectionFooterDefaultHeight]
#define TableViewGroupedSectionHeaderContentInset       [TMUICMI tableViewGroupedSectionHeaderContentInset]
#define TableViewGroupedSectionFooterContentInset       [TMUICMI tableViewGroupedSectionFooterContentInset]

#define TableViewInsetGroupedCornerRadius               [TMUICMI tableViewInsetGroupedCornerRadius] // InsetGrouped 类型的 UITableView 内 cell 的圆角值
#define TableViewInsetGroupedHorizontalInset            [TMUICMI tableViewInsetGroupedHorizontalInset] // InsetGrouped 类型的 UITableView 内的左右缩进值
#define TableViewInsetGroupedBackgroundColor            [TMUICMI tableViewInsetGroupedBackgroundColor] // InsetGrouped 类型的 UITableView 的背景色
#define TableViewInsetGroupedSeparatorColor                  [TMUICMI tableViewInsetGroupedSeparatorColor]                // InsetGrouped 类型的 TMUITableView 分隔线颜色
#define TableViewInsetGroupedCellTitleLabelColor             [TMUICMI tableViewInsetGroupedCellTitleLabelColor]           // InsetGrouped 类型的列表的 TMUITableViewCell 的标题颜色
#define TableViewInsetGroupedCellDetailLabelColor            [TMUICMI tableViewInsetGroupedCellDetailLabelColor]          // InsetGrouped 类型的列表的 TMUITableViewCell 的副标题颜色
#define TableViewInsetGroupedCellBackgroundColor             [TMUICMI tableViewInsetGroupedCellBackgroundColor]           // InsetGrouped 类型的列表的 TMUITableViewCell 的背景色
#define TableViewInsetGroupedCellSelectedBackgroundColor     [TMUICMI tableViewInsetGroupedCellSelectedBackgroundColor]   // InsetGrouped 类型的列表的 TMUITableViewCell 点击时的背景色
#define TableViewInsetGroupedCellWarningBackgroundColor      [TMUICMI tableViewInsetGroupedCellWarningBackgroundColor]    // InsetGrouped 类型的列表的 TMUITableViewCell 在提醒状态下的背景色
#define TableViewInsetGroupedSectionHeaderFont               [TMUICMI tableViewInsetGroupedSectionHeaderFont]
#define TableViewInsetGroupedSectionFooterFont               [TMUICMI tableViewInsetGroupedSectionFooterFont]
#define TableViewInsetGroupedSectionHeaderTextColor          [TMUICMI tableViewInsetGroupedSectionHeaderTextColor]
#define TableViewInsetGroupedSectionFooterTextColor          [TMUICMI tableViewInsetGroupedSectionFooterTextColor]
#define TableViewInsetGroupedSectionHeaderAccessoryMargins   [TMUICMI tableViewInsetGroupedSectionHeaderAccessoryMargins]
#define TableViewInsetGroupedSectionFooterAccessoryMargins   [TMUICMI tableViewInsetGroupedSectionFooterAccessoryMargins]
#define TableViewInsetGroupedSectionHeaderDefaultHeight      [TMUICMI tableViewInsetGroupedSectionHeaderDefaultHeight]
#define TableViewInsetGroupedSectionFooterDefaultHeight      [TMUICMI tableViewInsetGroupedSectionFooterDefaultHeight]
#define TableViewInsetGroupedSectionHeaderContentInset       [TMUICMI tableViewInsetGroupedSectionHeaderContentInset]
#define TableViewInsetGroupedSectionFooterContentInset       [TMUICMI tableViewInsetGroupedSectionFooterContentInset]

#pragma mark - UIWindowLevel
#define UIWindowLevelTMUIAlertView                      [TMUICMI windowLevelTMUIAlertView]
#define UIWindowLevelTMUIConsole                        [TMUICMI windowLevelTMUIConsole]

#pragma mark - TMUILog
#define ShouldPrintDefaultLog                           [TMUICMI shouldPrintDefaultLog]
#define ShouldPrintInfoLog                              [TMUICMI shouldPrintInfoLog]
#define ShouldPrintWarnLog                              [TMUICMI shouldPrintWarnLog]
#define ShouldPrintTMUIWarnLogToConsole                 [TMUICMI shouldPrintTMUIWarnLogToConsole] // 是否在出现 TMUILogWarn 时自动把这些 log 以 TMUIConsole 的方式显示到设备屏幕上

#pragma mark - TMUIBadge
#define BadgeBackgroundColor                            [TMUICMI badgeBackgroundColor]
#define BadgeTextColor                                  [TMUICMI badgeTextColor]
#define BadgeFont                                       [TMUICMI badgeFont]
#define BadgeContentEdgeInsets                          [TMUICMI badgeContentEdgeInsets]
#define BadgeOffset                                     [TMUICMI badgeOffset]
#define BadgeOffsetLandscape                            [TMUICMI badgeOffsetLandscape]
#define BadgeCenterOffset                               [TMUICMI badgeCenterOffset]
#define BadgeCenterOffsetLandscape                      [TMUICMI badgeCenterOffsetLandscape]

#define UpdatesIndicatorColor                           [TMUICMI updatesIndicatorColor]
#define UpdatesIndicatorSize                            [TMUICMI updatesIndicatorSize]
#define UpdatesIndicatorOffset                          [TMUICMI updatesIndicatorOffset]
#define UpdatesIndicatorOffsetLandscape                 [TMUICMI updatesIndicatorOffsetLandscape]
#define UpdatesIndicatorCenterOffset                    [TMUICMI updatesIndicatorCenterOffset]
#define UpdatesIndicatorCenterOffsetLandscape           [TMUICMI updatesIndicatorCenterOffsetLandscape]

#pragma mark - Others

#define AutomaticCustomNavigationBarTransitionStyle [TMUICMI automaticCustomNavigationBarTransitionStyle] // 界面 push/pop 时是否要自动根据两个界面的 barTintColor/backgroundImage/shadowImage 的样式差异来决定是否使用自定义的导航栏效果
#define SupportedOrientationMask                        [TMUICMI supportedOrientationMask]          // 默认支持的横竖屏方向
#define AutomaticallyRotateDeviceOrientation            [TMUICMI automaticallyRotateDeviceOrientation]  // 是否在界面切换或 viewController.supportedOrientationMask 发生变化时自动旋转屏幕，默认为 NO
#define StatusbarStyleLightInitially                    [TMUICMI statusbarStyleLightInitially]      // 默认的状态栏内容是否使用白色，默认为 NO，在 iOS 13 下会自动根据是否 Dark Mode 而切换样式，iOS 12 及以前则为黑色
#define NeedsBackBarButtonItemTitle                     [TMUICMI needsBackBarButtonItemTitle]       // 全局是否需要返回按钮的title，不需要则只显示一个返回image
#define HidesBottomBarWhenPushedInitially               [TMUICMI hidesBottomBarWhenPushedInitially] // TMUICommonViewController.hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
#define PreventConcurrentNavigationControllerTransitions [TMUICMI preventConcurrentNavigationControllerTransitions] // PreventConcurrentNavigationControllerTransitions : 自动保护 TMUINavigationController 在上一次 push/pop 尚未结束的时候就进行下一次 push/pop 的行为，避免产生 crash
#define NavigationBarHiddenInitially                    [TMUICMI navigationBarHiddenInitially]      // preferredNavigationBarHidden 的初始值，默认为NO
#define ShouldFixTabBarTransitionBugInIPhoneX           [TMUICMI shouldFixTabBarTransitionBugInIPhoneX] // 是否需要自动修复 iOS 11 下，iPhone X 的设备在 push 界面时，tabBar 会瞬间往上跳的 bug
#define ShouldFixTabBarSafeAreaInsetsBug [TMUICMI shouldFixTabBarSafeAreaInsetsBug] // 是否要对 iOS 11 及以后的版本修复当存在 UITabBar 时，UIScrollView 的 inset.bottom 可能错误的 bug（issue #218 #934），默认为 YES
#define ShouldFixSearchBarMaskViewLayoutBug             [TMUICMI shouldFixSearchBarMaskViewLayoutBug] // 是否自动修复 UISearchController.searchBar 被当作 tableHeaderView 使用时可能出现的布局 bug(issue #950)
#define SendAnalyticsToTMUITeam                         [TMUICMI sendAnalyticsToTMUITeam] // 是否允许在 DEBUG 模式下上报 Bundle Identifier 和 Display Name 给 TMUI 统计用
#define DynamicPreferredValueForIPad                    [TMUICMI dynamicPreferredValueForIPad] // 当 iPad 处于 Slide Over 或 Split View 分屏模式下，宏 `PreferredValueForXXX` 是否把 iPad 视为某种屏幕宽度近似的 iPhone 来取值。
#define IgnoreKVCAccessProhibited                       [TMUICMI ignoreKVCAccessProhibited] // 是否全局忽略 iOS 13 对 KVC 访问 UIKit 私有属性的限制
#define AdjustScrollIndicatorInsetsByContentInsetAdjustment [TMUICMI adjustScrollIndicatorInsetsByContentInsetAdjustment] // 当将 UIScrollView.contentInsetAdjustmentBehavior 设为 UIScrollViewContentInsetAdjustmentNever 时，是否自动将 UIScrollView.automaticallyAdjustsScrollIndicatorInsets 设为 NO，以保证原本在 iOS 12 下的代码不用修改就能在 iOS 13 下正常控制滚动条的位置。

