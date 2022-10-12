//
//  TMUIConfigurationTemplate.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIConfigurationTemplate.h"
#import "TDCommonUI.h"
#import "TDThemeManager.h"

@implementation TMUIConfigurationTemplate

static UIImage *disclosureIndicatorImage;
static UIImage *disclosureIndicatorImageDark;

#pragma mark - <TMUIConfigurationTemplateProtocol>

- (void)applyConfigurationTemplate {
    
    if (!disclosureIndicatorImage) disclosureIndicatorImage = [UIImage tmui_imageWithShape:TMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorGray7];
    if (!disclosureIndicatorImageDark) disclosureIndicatorImageDark = [UIImage tmui_imageWithShape:TMUIImageShapeDisclosureIndicator size:CGSizeMake(6, 10) lineWidth:1 tintColor:UIColorMake(98, 100, 104)];
    
    // === 修改配置值 === //
#pragma mark - Global Color
    
//    TMUICMI.clearColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];       // UIColorClear : 透明色
//    TMUICMI.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];       // UIColorWhite : 白色（不用 [UIColor whiteColor] 是希望保持颜色空间为 RGB）
//    TMUICMI.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];       // UIColorBlack : 黑色（不用 [UIColor blackColor] 是希望保持颜色空间为 RGB）
//    TMUICMI.grayColor = UIColorGray4;                                           // UIColorGray  : 最常用的灰色
//    TMUICMI.grayDarkenColor = UIColor.td_mainTextColor;                          // UIColorGrayDarken : 深一点的灰色
//    TMUICMI.grayLightenColor = UIColorGray7;                                    // UIColorGrayLighten : 浅一点的灰色
//    TMUICMI.redColor = UIColorMake(250, 58, 58);                                // UIColorRed : 红色
//    TMUICMI.greenColor = UIColorTheme4;                                         // UIColorGreen : 绿色
//    TMUICMI.blueColor = UIColorTheme6;                                    // UIColorBlue : 蓝色
//    TMUICMI.yellowColor = UIColorTheme3;                                        // UIColorYellow : 黄色
    
    TMUICMI.linkColor = UIColorMake(56, 116, 171);                              // UIColorLink : 文字链接颜色
    TMUICMI.disabledColor = UIColorGray;                                        // UIColorDisabled : 全局 disabled 的颜色，一般用于 UIControl 等控件
    // 这里如果用动态颜色，再赋值会造成死循环
    TMUICMI.backgroundColor = UIColor.td_backgroundColor;                                     // UIColorForBackground : 界面背景色，默认用于 TMUICommonViewController.view 的背景色
    TMUICMI.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);                 // UIColorMask : 深色的背景遮罩，默认用于 QMAlertController、TMUIDialogViewController 等弹出控件的遮罩
    TMUICMI.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);           // UIColorMaskWhite : 浅色的背景遮罩，TMUIKit 里默认没用到，只是占个位
    // 这里如果用动态颜色，再赋值会造成死循环
    TMUICMI.separatorColor = UIColor.td_separatorColor;                          // UIColorSeparator : 全局默认的分割线颜色，默认用于列表分隔线颜色、UIView (TMUIBorder) 分隔线颜色
    TMUICMI.separatorDashedColor = UIColorMake(17, 17, 17);                     // UIColorSeparatorDashed : 全局默认的虚线分隔线的颜色，默认 TMUIKit 暂时没用到
    // 这里如果用动态颜色，再赋值会造成死循环
    TMUICMI.placeholderColor = UIColor.td_placeholderColor;                                    // UIColorPlaceholder，全局的输入框的 placeholder 颜色，默认用于 TMUITextField、TMUITextView，不影响系统 UIKit 的输入框
    
    // 测试用的颜色
    TMUICMI.testColorRed = UIColorMakeWithRGBA(255, 0, 0, .3);
    TMUICMI.testColorGreen = UIColorMakeWithRGBA(0, 255, 0, .3);
    TMUICMI.testColorBlue = UIColorMakeWithRGBA(0, 0, 255, .3);
    
    
#pragma mark - UIControl
    
    TMUICMI.controlHighlightedAlpha = 0.5f;                                     // UIControlHighlightedAlpha : UIControl 系列控件在 highlighted 时的 alpha，默认用于 TMUIButton、 TMUINavigationTitleView
    TMUICMI.controlDisabledAlpha = 0.5f;                                        // UIControlDisabledAlpha : UIControl 系列控件在 disabled 时的 alpha，默认用于 TMUIButton
    
#pragma mark - UIButton
    TMUICMI.buttonHighlightedAlpha = UIControlHighlightedAlpha;                 // ButtonHighlightedAlpha : TMUIButton 在 highlighted 时的 alpha，不影响系统的 UIButton
    TMUICMI.buttonDisabledAlpha = UIControlDisabledAlpha;                       // ButtonDisabledAlpha : TMUIButton 在 disabled 时的 alpha，不影响系统的 UIButton
    TMUICMI.buttonTintColor = UIColor.td_tintColor;                              // ButtonTintColor : TMUIButton 默认的 tintColor，不影响系统的 UIButton
    
//    TMUICMI.ghostButtonColorBlue = UIColorBlue;                                 // GhostButtonColorBlue : TMUIGhostButtonColorBlue 的颜色
//    TMUICMI.ghostButtonColorRed = UIColorRed;                                   // GhostButtonColorRed : TMUIGhostButtonColorRed 的颜色
//    TMUICMI.ghostButtonColorGreen = UIColorGreen;                               // GhostButtonColorGreen : TMUIGhostButtonColorGreen 的颜色
//    TMUICMI.ghostButtonColorGray = UIColorGray;                                 // GhostButtonColorGray : TMUIGhostButtonColorGray 的颜色
//    TMUICMI.ghostButtonColorWhite = UIColorWhite;                               // GhostButtonColorWhite : TMUIGhostButtonColorWhite 的颜色
//    
//    TMUICMI.fillButtonColorBlue = UIColorBlue;                                  // FillButtonColorBlue : TMUIFillButtonColorBlue 的颜色
//    TMUICMI.fillButtonColorRed = UIColorRed;                                    // FillButtonColorRed : TMUIFillButtonColorRed 的颜色
//    TMUICMI.fillButtonColorGreen = UIColorGreen;                                // FillButtonColorGreen : TMUIFillButtonColorGreen 的颜色
//    TMUICMI.fillButtonColorGray = UIColorGray;                                  // FillButtonColorGray : TMUIFillButtonColorGray 的颜色
//    TMUICMI.fillButtonColorWhite = UIColorWhite;                                // FillButtonColorWhite : TMUIFillButtonColorWhite 的颜色
    
    
#pragma mark - TextInput
    TMUICMI.textFieldTextColor = UIColor.td_titleTextColor;                     // TextFieldTextColor : TMUITextField、TMUITextView 的 textColor，不影响 UIKit 的输入框
    TMUICMI.textFieldTintColor = UIColor.td_tintColor;                          // TextFieldTintColor : TMUITextField、TMUITextView 的 tintColor，不影响 UIKit 的输入框
    TMUICMI.textFieldTextInsets = UIEdgeInsetsMake(0, 7, 0, 7);                 // TextFieldTextInsets : TMUITextField 的内边距，不影响 UITextField
    TMUICMI.keyboardAppearance = UIKeyboardAppearanceDefault;                   // KeyboardAppearance : UITextView、UITextField、UISearchBar 的 keyboardAppearance

#pragma mark - UISwitch
    TMUICMI.switchOnTintColor = UIColor.td_tintColor;                           // SwitchOnTintColor : UISwitch 打开时的背景色（除了圆点外的其他颜色）
    TMUICMI.switchOffTintColor =  UIColor.td_separatorColor;                    // SwitchOffTintColor : UISwitch 关闭时的背景色（除了圆点外的其他颜色）
    TMUICMI.switchTintColor = SwitchOnTintColor;                                // SwitchTintColor : UISwitch 关闭时的周围边框颜色
    TMUICMI.switchThumbTintColor = nil;                                         // SwitchThumbTintColor : UISwitch 中间的操控圆点的颜色
    
#pragma mark - NavigationBar
    
//    TMUICMI.navBarContainerClasses = @[TMUINavigationController.class];         // NavBarContainerClasses : NavigationBar 系列开关被用于 UIAppearance 时的生效范围（默认情况下除了用于 UIAppearance 外，还用于实现了 TMUINavigationControllerAppearanceDelegate 的 UIViewController），默认为 nil。当赋值为 nil 或者空数组时等效于 @[UINavigationController.class]，也即对所有 UINavigationBar 生效，包括系统的通讯录（ContactsUI.framework)、打印等。当值不为空时，获取 UINavigationBar 的 appearance 请使用 UINavigationBar.tmui_appearanceConfigured 方法代替系统的 UINavigationBar.appearance。请保证这个配置项先于其他任意 NavBar 配置项执行。
    TMUICMI.navBarHighlightedAlpha = 0.2f;                                      // NavBarHighlightedAlpha : TMUINavigationButton 在 highlighted 时的 alpha
    TMUICMI.navBarDisabledAlpha = 0.2f;                                         // NavBarDisabledAlpha : TMUINavigationButton 在 disabled 时的 alpha
    TMUICMI.navBarButtonFont = UIFontMake(17);                                  // NavBarButtonFont : TMUINavigationButtonTypeNormal 的字体（由于系统存在一些 bug，这个属性默认不对 UIBarButtonItem 生效）
    TMUICMI.navBarButtonFontBold = UIFontBoldMake(17);                          // NavBarButtonFontBold : TMUINavigationButtonTypeBold 的字体
    TMUICMI.navBarBackgroundImage = [TDUIHelper navigationBarBackgroundImageWithThemeColor:UIColor.td_tintColor];   // NavBarBackgroundImage : UINavigationBar 的背景图，注意 navigationBar 的高度会受多个因素（是否全面屏、是否使用了 navigationItem.prompt、是否将 UISearchBar 作为 titleView）的影响，要检查各种情况是否都显示正常。
    TMUICMI.navBarShadowImage = nil;                                            // NavBarShadowImage : UINavigationBar.shadowImage，也即导航栏底部那条分隔线，配合 NavBarShadowImageColor 使用。
    TMUICMI.navBarShadowImageColor = UIColorClear;                              // NavBarShadowImageColor : UINavigationBar.shadowImage 的颜色，如果为 nil，则使用 NavBarShadowImage 的值，如果 NavBarShadowImage 也为 nil，则使用系统默认的分隔线。如果不为 nil，而 NavBarShadowImage 为 nil，则自动创建一张 1px 高的图并将其设置为 NavBarShadowImageColor 的颜色然后设置上去，如果 NavBarShadowImage 不为 nil 且 renderingMode 不为 UIImageRenderingModeAlwaysOriginal，则将 NavBarShadowImage 设置为 NavBarShadowImageColor 的颜色然后设置上去。
    TMUICMI.navBarBarTintColor = nil;                                           // NavBarBarTintColor : UINavigationBar.barTintColor，也即背景色
    TMUICMI.navBarStyle = UIBarStyleDefault;                                    // NavBarStyle : UINavigationBar 的 barStyle
    TMUICMI.navBarTintColor = UIColorWhite;                                     // NavBarTintColor : NavBarContainerClasses 里的 UINavigationBar 的 tintColor，也即导航栏上面的按钮颜色
    TMUICMI.navBarTitleColor = NavBarTintColor;                                 // NavBarTitleColor : UINavigationBar 的标题颜色，以及 TMUINavigationTitleView 的默认文字颜色
    TMUICMI.navBarTitleFont = UIFontBoldMake(17);                               // NavBarTitleFont : UINavigationBar 的标题字体，以及 TMUINavigationTitleView 的默认字体
    TMUICMI.navBarLargeTitleColor = nil;                                        // NavBarLargeTitleColor : UINavigationBar 在大标题模式下的标题颜色，仅在 iOS 11 之后才有效
    TMUICMI.navBarLargeTitleFont = nil;                                         // NavBarLargeTitleFont : UINavigationBar 在大标题模式下的标题字体，仅在 iOS 11 之后才有效
    TMUICMI.navBarBackButtonTitlePositionAdjustment = UIOffsetZero;             // NavBarBarBackButtonTitlePositionAdjustment : 导航栏返回按钮的文字偏移
    TMUICMI.sizeNavBarBackIndicatorImageAutomatically = YES;                    // SizeNavBarBackIndicatorImageAutomatically : 是否要自动调整 NavBarBackIndicatorImage 的 size 为 (13, 21)
    TMUICMI.navBarBackIndicatorImage = [UIImage tmui_imageWithShape:TMUIImageShapeNavBack size:CGSizeMake(12, 20) tintColor:NavBarTintColor];                                     // NavBarBackIndicatorImage : 导航栏的返回按钮的图片，图片尺寸建议为(13, 21)，否则最终的图片位置无法与系统原生的位置保持一致
    TMUICMI.navBarCloseButtonImage = [UIImage tmui_imageWithShape:TMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:NavBarTintColor];     // NavBarCloseButtonImage : TMUINavigationButton 用到的 × 的按钮图片
    
    TMUICMI.navBarLoadingMarginRight = 3;                                       // NavBarLoadingMarginRight : TMUINavigationTitleView 里左边 loading 的右边距
    TMUICMI.navBarAccessoryViewMarginLeft = 5;                                  // NavBarAccessoryViewMarginLeft : TMUINavigationTitleView 里右边 accessoryView 的左边距
    TMUICMI.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;// NavBarActivityIndicatorViewStyle : TMUINavigationTitleView 里左边 loading 的主题
    TMUICMI.navBarAccessoryViewTypeDisclosureIndicatorImage = [[UIImage tmui_imageWithShape:TMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];     // NavBarAccessoryViewTypeDisclosureIndicatorImage : TMUINavigationTitleView 右边箭头的图片
    
#pragma mark - TabBar
    
    TMUICMI.tabBarContainerClasses = nil;         // TabBarContainerClasses : TabBar 系列开关的生效范围，默认为 nil，当赋值为 nil 或者空数组时等效于 @[UITabBarController.class]，也即对所有 UITabBar 生效。当值不为空时，获取 UITabBar 的 appearance 请使用 UITabBar.tmui_appearanceConfigured 方法代替系统的 UITabBar.appearance。请保证这个配置项先于其他任意 TabBar 配置项执行。
    TMUICMI.tabBarBackgroundImage = [[UIImage tmui_imageWithColor:UIColorMake(249, 249, 249)] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];   // TabBarBackgroundImage : UITabBar 的背景图，建议使用 resizableImage，否则在 UITabBar (NavigationController) 的 setBackgroundImage: 里会每次都视为 image 发生了变化（isEqual: 为 NO）
    TMUICMI.tabBarBarTintColor = nil;                                           // TabBarBarTintColor : UITabBar 的 barTintColor，如果需要看到磨砂效果则应该提供半透明的色值
    TMUICMI.tabBarShadowImageColor = UIColorSeparator;                          // TabBarShadowImageColor : UITabBar 的 shadowImage 的颜色，会自动创建一张 1px 高的图片
    TMUICMI.tabBarStyle = UIBarStyleDefault;                                    // TabBarStyle : UITabBar 的 barStyle
    TMUICMI.tabBarItemTitleFont = UIFontMake(10);                               // TabBarItemTitleFont : UITabBarItem 的标题字体
    TMUICMI.tabBarItemTitleFontSelected = nil;                                  // TabBarItemTitleFontSelected : 选中的 UITabBarItem 的标题字体
    TMUICMI.tabBarItemTitleColor = UIColor.td_descriptionTextColor;             // TabBarItemTitleColor : 未选中的 UITabBarItem 的标题颜色
    TMUICMI.tabBarItemTitleColorSelected = UIColor.td_tintColor;                // TabBarItemTitleColorSelected : 选中的 UITabBarItem 的标题颜色
    TMUICMI.tabBarItemImageColor = TabBarItemTitleColor;                        // TabBarItemImageColor : UITabBarItem 未选中时的图片颜色（该配置项在 iOS 12 及以下的系统对 TMUIThemeImage 无效，请自行在 provider 内处理颜色。注意非选中状态的图片需要指定为 UIImageRenderingModeAlwaysOriginal，系统限制如此）
    TMUICMI.tabBarItemImageColorSelected = TabBarItemTitleColorSelected;        // TabBarItemImageColorSelected : UITabBarItem 选中时的图片颜色
    
#pragma mark - Toolbar
    
//    TMUICMI.toolBarContainerClasses = @[TMUINavigationController.class];        // ToolBarContainerClasses : ToolBar 系列开关的生效范围，默认为 nil，当赋值为 nil 或者空数组时等效于 @[UINavigationController.class]，也即对所有 UIToolbar 生效。当值不为空时，获取 UIToolbar 的 appearance 请使用 UIToolbar.tmui_appearanceConfigured 方法代替系统的 UIToolbar.appearance。请保证这个配置项先于其他任意 ToolBar 配置项执行。
    TMUICMI.toolBarHighlightedAlpha = 0.4f;                                     // ToolBarHighlightedAlpha : TMUIToolbarButton 在 highlighted 状态下的 alpha
    TMUICMI.toolBarDisabledAlpha = 0.4f;                                        // ToolBarDisabledAlpha : TMUIToolbarButton 在 disabled 状态下的 alpha
    TMUICMI.toolBarTintColor = UIColor.td_tintColor;                            // ToolBarTintColor : NavBarContainerClasses 里的 UIToolbar 的 tintColor，以及 TMUIToolbarButton normal 状态下的文字颜色
    TMUICMI.toolBarTintColorHighlighted = [ToolBarTintColor colorWithAlphaComponent:ToolBarHighlightedAlpha];   // ToolBarTintColorHighlighted : TMUIToolbarButton 在 highlighted 状态下的文字颜色
    TMUICMI.toolBarTintColorDisabled = [ToolBarTintColor colorWithAlphaComponent:ToolBarDisabledAlpha];         // ToolBarTintColorDisabled : TMUIToolbarButton 在 disabled 状态下的文字颜色
    TMUICMI.toolBarBackgroundImage = nil;                                       // ToolBarBackgroundImage : NavBarContainerClasses 里的 UIToolbar 的背景图
    TMUICMI.toolBarBarTintColor = nil;                                          // ToolBarBarTintColor : NavBarContainerClasses 里的 UIToolbar 的 tintColor
    TMUICMI.toolBarShadowImageColor = UIColorSeparator;                         // ToolBarShadowImageColor : NavBarContainerClasses 里的 UIToolbar 的 shadowImage 的颜色，会自动创建一张 1px 高的图片
    TMUICMI.toolBarStyle = UIBarStyleDefault;                                   // ToolBarStyle : NavBarContainerClasses 里的 UIToolbar 的 barStyle
    TMUICMI.toolBarButtonFont = UIFontMake(17);                                 // ToolBarButtonFont : TMUIToolbarButton 的字体
    
#pragma mark - SearchBar
    
    TMUICMI.searchBarTextFieldBackgroundImage = UIImage.td_searchBarTextFieldBackgroundImage;       // SearchBarTextFieldBackgroundImage : TMUISearchBar 里的文本框的背景图，图片高度会决定输入框的高度
    TMUICMI.searchBarTextFieldBorderColor = nil;                                // SearchBarTextFieldBorderColor : TMUISearchBar 里的文本框的边框颜色
    TMUICMI.searchBarTextFieldCornerRadius = 4.0;                               // SearchBarTextFieldCornerRadius : TMUISearchBar 里的文本框的圆角大小，-1 表示圆角大小为输入框高度的一半
    TMUICMI.searchBarBackgroundImage = UIImage.td_searchBarBackgroundImage;     // SearchBarBackgroundImage : 搜索框的背景图，如果需要设置底部分隔线的颜色也请绘制到图片里
    TMUICMI.searchBarTintColor = UIColor.td_tintColor;                          // SearchBarTintColor : TMUISearchBar 的 tintColor，也即上面的操作控件的主题色
    TMUICMI.searchBarTextColor = UIColor.td_titleTextColor;                                  // SearchBarTextColor : TMUISearchBar 里的文本框的文字颜色
    TMUICMI.searchBarPlaceholderColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> *theme) {
        if ([identifier isEqualToString:TDThemeIdentifierDark]) {
            return theme.themePlaceholderColor;
        }
        return UIColorMake(136, 136, 143);
    }];             // SearchBarPlaceholderColor : TMUISearchBar 里的文本框的 placeholder 颜色
    TMUICMI.searchBarFont = UIFontMake(15);                                                // SearchBarFont : TMUISearchBar 里的文本框的文字字体及 placeholder 的字体
    TMUICMI.searchBarSearchIconImage = nil;                                     // SearchBarSearchIconImage : TMUISearchBar 里的放大镜 icon
    TMUICMI.searchBarClearIconImage = nil;                                      // SearchBarClearIconImage : TMUISearchBar 里的文本框输入文字时右边的清空按钮的图片
    
#pragma mark - Plain TableView
    
    TMUICMI.tableViewEstimatedHeightEnabled = YES;                              // TableViewEstimatedHeightEnabled : 是否要开启全局 TMUITableView 和 UITableView 的 estimatedRow(Section/Footer)Height
    
    TMUICMI.tableViewBackgroundColor = UIColorForBackground;                    // TableViewBackgroundColor : Plain 类型的 TMUITableView 的背景色颜色
    TMUICMI.tableSectionIndexColor = UIColorGrayDarken;                         // TableSectionIndexColor : 列表右边的字母索引条的文字颜色
    TMUICMI.tableSectionIndexBackgroundColor = UIColorClear;                    // TableSectionIndexBackgroundColor : 列表右边的字母索引条的背景色
    TMUICMI.tableSectionIndexTrackingBackgroundColor = UIColorClear;            // TableSectionIndexTrackingBackgroundColor : 列表右边的字母索引条在选中时的背景色
    TMUICMI.tableViewSeparatorColor = UIColorSeparator;                         // TableViewSeparatorColor : 列表的分隔线颜色
    
    TMUICMI.tableViewCellNormalHeight = 56;                                     // TableViewCellNormalHeight : TMUITableView 的默认 cell 高度
    TMUICMI.tableViewCellTitleLabelColor = UIColor.td_mainTextColor;             // TableViewCellTitleLabelColor : TMUITableViewCell 的 textLabel 的文字颜色
    TMUICMI.tableViewCellDetailLabelColor = UIColor.td_descriptionTextColor;     // TableViewCellDetailLabelColor : TMUITableViewCell 的 detailTextLabel 的文字颜色
    TMUICMI.tableViewCellBackgroundColor = UIColorForBackground;                 // TableViewCellBackgroundColor : TMUITableViewCell 的背景色
    TMUICMI.tableViewCellSelectedBackgroundColor = UIColor.td_backgroundColorHighlighted;  // TableViewCellSelectedBackgroundColor : TMUITableViewCell 点击时的背景色
    TMUICMI.tableViewCellWarningBackgroundColor = UIColorYellow;                // TableViewCellWarningBackgroundColor : TMUITableViewCell 用于表示警告时的背景色，备用
    TMUICMI.tableViewCellDisclosureIndicatorImage = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
        return [identifier isEqualToString:TDThemeIdentifierDark] ? disclosureIndicatorImageDark : disclosureIndicatorImage;
    }];    // TableViewCellDisclosureIndicatorImage : TMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryDisclosureIndicator 时的箭头的图片
    TMUICMI.tableViewCellCheckmarkImage = [UIImage tmui_imageWithShape:TMUIImageShapeCheckmark size:CGSizeMake(15, 12) tintColor:UIColor.td_tintColor];  // TableViewCellCheckmarkImage : TMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryCheckmark 时的打钩的图片
    TMUICMI.tableViewCellDetailButtonImage = [UIImage tmui_imageWithShape:TMUIImageShapeDetailButtonImage size:CGSizeMake(20, 20) tintColor:UIColor.td_tintColor]; // TableViewCellDetailButtonImage : TMUITableViewCell 当 accessoryType 为 UITableViewCellAccessoryDetailButton 或 UITableViewCellAccessoryDetailDisclosureButton 时右边的 i 按钮图片
    TMUICMI.tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator = 12; // TableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator : 列表 cell 右边的 i 按钮和向右箭头之间的间距（仅当两者都使用了自定义图片并且同时显示时才生效）
    
    TMUICMI.tableViewSectionHeaderBackgroundColor = UIColor.td_separatorColor;                         // TableViewSectionHeaderBackgroundColor : Plain 类型的 TMUITableView sectionHeader 的背景色
    TMUICMI.tableViewSectionFooterBackgroundColor = UIColor.td_separatorColor;                         // TableViewSectionFooterBackgroundColor : Plain 类型的 TMUITableView sectionFooter 的背景色
    TMUICMI.tableViewSectionHeaderFont = UIFontBoldMake(12);                                            // TableViewSectionHeaderFont : Plain 类型的 TMUITableView sectionHeader 里的文字字体
    TMUICMI.tableViewSectionFooterFont = UIFontBoldMake(12);                                            // TableViewSectionFooterFont : Plain 类型的 TMUITableView sectionFooter 里的文字字体
    TMUICMI.tableViewSectionHeaderTextColor = UIColorGray5;                                             // TableViewSectionHeaderTextColor : Plain 类型的 TMUITableView sectionHeader 里的文字颜色
    TMUICMI.tableViewSectionFooterTextColor = UIColorGray;                                              // TableViewSectionFooterTextColor : Plain 类型的 TMUITableView sectionFooter 里的文字颜色
    TMUICMI.tableViewSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewSectionHeaderAccessoryMargins : Plain 类型的 TMUITableView sectionHeader accessoryView 的间距
    TMUICMI.tableViewSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);                     // TableViewSectionFooterAccessoryMargins : Plain 类型的 TMUITableView sectionFooter accessoryView 的间距
    TMUICMI.tableViewSectionHeaderContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionHeaderContentInset : Plain 类型的 TMUITableView sectionHeader 里的内容的 padding
    TMUICMI.tableViewSectionFooterContentInset = UIEdgeInsetsMake(4, 15, 4, 15);                        // TableViewSectionFooterContentInset : Plain 类型的 TMUITableView sectionFooter 里的内容的 padding
    
#pragma mark - Grouped TableView
    
    TMUICMI.tableViewGroupedBackgroundColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
        if ([identifier isEqualToString:TDThemeIdentifierDark]) {
            return TMUICMI.tableViewBackgroundColor;
        }
        return UIColorMake(246, 246, 246);
    }];       // TableViewGroupedBackgroundColor : Grouped 类型的 TMUITableView 的背景色
    TMUICMI.tableViewGroupedSeparatorColor = TableViewSeparatorColor;                                   // TableViewGroupedSeparatorColor : Grouped 类型的 TMUITableView 分隔线颜色
    TMUICMI.tableViewGroupedCellTitleLabelColor = TableViewCellTitleLabelColor;                         // TableViewGroupedCellTitleLabelColor : Grouped 类型的 TMUITableView cell 里的标题颜色
    TMUICMI.tableViewGroupedCellDetailLabelColor = TableViewCellDetailLabelColor;                       // TableViewGroupedCellDetailLabelColor : Grouped 类型的 TMUITableView cell 里的副标题颜色
    TMUICMI.tableViewGroupedCellBackgroundColor = UIColor.td_backgroundColorLighten;                    // TableViewGroupedCellBackgroundColor : Grouped 类型的 TMUITableView cell 背景色
    TMUICMI.tableViewGroupedCellSelectedBackgroundColor = TableViewCellSelectedBackgroundColor;         // TableViewGroupedCellSelectedBackgroundColor : Grouped 类型的 TMUITableView cell 点击时的背景色
    TMUICMI.tableViewGroupedCellWarningBackgroundColor = TableViewCellWarningBackgroundColor;           // tableViewGroupedCellWarningBackgroundColor : Grouped 类型的 TMUITableView cell 在提醒状态下的背景色
    TMUICMI.tableViewGroupedSectionHeaderFont = UIFontMake(12);                                         // TableViewGroupedSectionHeaderFont : Grouped 类型的 TMUITableView sectionHeader 里的文字字体
    TMUICMI.tableViewGroupedSectionFooterFont = UIFontMake(12);                                         // TableViewGroupedSectionFooterFont : Grouped 类型的 TMUITableView sectionFooter 里的文字字体
    TMUICMI.tableViewGroupedSectionHeaderTextColor = UIColorGrayDarken;                                 // TableViewGroupedSectionHeaderTextColor : Grouped 类型的 TMUITableView sectionHeader 里的文字颜色
    TMUICMI.tableViewGroupedSectionFooterTextColor = TableViewGroupedSectionHeaderTextColor;                                       // TableViewGroupedSectionFooterTextColor : Grouped 类型的 TMUITableView sectionFooter 里的文字颜色
    TMUICMI.tableViewGroupedSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);              // TableViewGroupedSectionHeaderAccessoryMargins : Grouped 类型的 TMUITableView sectionHeader accessoryView 的间距
    TMUICMI.tableViewGroupedSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);              // TableViewGroupedSectionFooterAccessoryMargins : Grouped 类型的 TMUITableView sectionFooter accessoryView 的间距
    TMUICMI.tableViewGroupedSectionHeaderDefaultHeight = 20;                 // TableViewGroupedSectionHeaderDefaultHeight : Grouped 类型的 TMUITableView sectionHeader 的默认高度（也即没使用自定义的 sectionHeaderView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    TMUICMI.tableViewGroupedSectionFooterDefaultHeight = 0;                 // TableViewGroupedSectionFooterDefaultHeight : Grouped 类型的 TMUITableView sectionFooter 的默认高度（也即没使用自定义的 sectionFooterView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    TMUICMI.tableViewGroupedSectionHeaderContentInset = UIEdgeInsetsMake(16, PreferredValueForVisualDevice(20, 15), 8, PreferredValueForVisualDevice(20, 15));    // TableViewGroupedSectionHeaderContentInset : Grouped 类型的 TMUITableView sectionHeader 里的内容的 padding
    TMUICMI.tableViewGroupedSectionFooterContentInset = UIEdgeInsetsMake(8, TableViewGroupedSectionHeaderContentInset.left, 2, TableViewGroupedSectionHeaderContentInset.right);                 // TableViewGroupedSectionFooterContentInset : Grouped 类型的 TMUITableView sectionFooter 里的内容的 padding
    
#pragma mark - InsetGrouped TableView
    TMUICMI.tableViewInsetGroupedCornerRadius = 10;                                                     // TableViewInsetGroupedCornerRadius : InsetGrouped 类型的 UITableView 内 cell 的圆角值
    TMUICMI.tableViewInsetGroupedHorizontalInset = PreferredValueForVisualDevice(20, 15);               // TableViewInsetGroupedHorizontalInset: InsetGrouped 类型的 UITableView 内的左右缩进值
    TMUICMI.tableViewInsetGroupedBackgroundColor = TableViewGroupedBackgroundColor;                                                 // TableViewInsetGroupedBackgroundColor : InsetGrouped 类型的 UITableView 的背景色
    TMUICMI.tableViewInsetGroupedSeparatorColor = TableViewGroupedSeparatorColor;                                   // TableViewInsetGroupedSeparatorColor : InsetGrouped 类型的 TMUITableView 分隔线颜色
    TMUICMI.tableViewInsetGroupedCellTitleLabelColor = TableViewGroupedCellTitleLabelColor;                         // TableViewInsetGroupedCellTitleLabelColor : InsetGrouped 类型的 TMUITableView cell 里的标题颜色
    TMUICMI.tableViewInsetGroupedCellDetailLabelColor = TableViewGroupedCellDetailLabelColor;                       // TableViewInsetGroupedCellDetailLabelColor : InsetGrouped 类型的 TMUITableView cell 里的副标题颜色
    TMUICMI.tableViewInsetGroupedCellBackgroundColor = TableViewGroupedCellBackgroundColor;                         // TableViewInsetGroupedCellBackgroundColor : InsetGrouped 类型的 TMUITableView cell 背景色
    TMUICMI.tableViewInsetGroupedCellSelectedBackgroundColor = TableViewGroupedCellSelectedBackgroundColor;         // TableViewInsetGroupedCellSelectedBackgroundColor : InsetGrouped 类型的 TMUITableView cell 点击时的背景色
    TMUICMI.tableViewInsetGroupedCellWarningBackgroundColor = TableViewGroupedCellWarningBackgroundColor;           // TableViewInsetGroupedCellWarningBackgroundColor : InsetGrouped 类型的 TMUITableView cell 在提醒状态下的背景色
    TMUICMI.tableViewInsetGroupedSectionHeaderFont = TableViewGroupedSectionHeaderFont;                                         // TableViewInsetGroupedSectionHeaderFont : InsetGrouped 类型的 TMUITableView sectionHeader 里的文字字体
    TMUICMI.tableViewInsetGroupedSectionFooterFont = TableViewGroupedSectionFooterFont;                                         // TableViewInsetGroupedSectionFooterFont : InsetGrouped 类型的 TMUITableView sectionFooter 里的文字字体
    TMUICMI.tableViewInsetGroupedSectionHeaderTextColor = TableViewGroupedSectionHeaderTextColor;                                 // TableViewInsetGroupedSectionHeaderTextColor : InsetGrouped 类型的 TMUITableView sectionHeader 里的文字颜色
    TMUICMI.tableViewInsetGroupedSectionFooterTextColor = TableViewGroupedSectionFooterTextColor;                                       // TableViewInsetGroupedSectionFooterTextColor : InsetGrouped 类型的 TMUITableView sectionFooter 里的文字颜色
    TMUICMI.tableViewInsetGroupedSectionHeaderAccessoryMargins = TableViewGroupedSectionHeaderAccessoryMargins;                     // TableViewInsetGroupedSectionHeaderAccessoryMargins : InsetGrouped 类型的 TMUITableView sectionHeader accessoryView 的间距
    TMUICMI.tableViewInsetGroupedSectionFooterAccessoryMargins = TableViewGroupedSectionFooterAccessoryMargins;                     // TableViewInsetGroupedSectionFooterAccessoryMargins : InsetGrouped 类型的 TMUITableView sectionFooter accessoryView 的间距
    TMUICMI.tableViewInsetGroupedSectionHeaderDefaultHeight = TableViewGroupedSectionHeaderDefaultHeight;                 // TableViewInsetGroupedSectionHeaderDefaultHeight : InsetGrouped 类型的 TMUITableView sectionHeader 的默认高度（也即没使用自定义的 sectionHeaderView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    TMUICMI.tableViewInsetGroupedSectionFooterDefaultHeight = TableViewGroupedSectionFooterDefaultHeight;                 // TableViewInsetGroupedSectionFooterDefaultHeight : InsetGrouped 类型的 TMUITableView sectionFooter 的默认高度（也即没使用自定义的 sectionFooterView 时的高度），注意如果不需要间距，请用 CGFLOAT_MIN
    TMUICMI.tableViewInsetGroupedSectionHeaderContentInset = TableViewGroupedSectionHeaderContentInset;                // TableViewInsetGroupedSectionHeaderContentInset : InsetGrouped 类型的 TMUITableView sectionHeader 里的内容的 padding
    TMUICMI.tableViewInsetGroupedSectionFooterContentInset = TableViewGroupedSectionFooterContentInset;                 // TableViewInsetGroupedSectionFooterContentInset : InsetGrouped 类型的 TMUITableView sectionFooter 里的内容的 padding
    
#pragma mark - UIWindowLevel
    TMUICMI.windowLevelTMUIAlertView = UIWindowLevelAlert - 4.0;                // UIWindowLevelTMUIAlertView : TMUIModalPresentationViewController、TMUIPopupContainerView 里使用的 UIWindow 的 windowLevel
    TMUICMI.windowLevelTMUIConsole = 1;                                         // UIWindowLevelTMUIConsole : TMUIConsole 内部的 UIWindow 的 windowLevel
    
#pragma mark - TMUILog
    TMUICMI.shouldPrintDefaultLog = YES;                                        // ShouldPrintDefaultLog : 是否允许输出 TMUILogLevelDefault 级别的 log
    TMUICMI.shouldPrintInfoLog = YES;                                           // ShouldPrintInfoLog : 是否允许输出 TMUILogLevelInfo 级别的 log
    TMUICMI.shouldPrintWarnLog = YES;                                           // ShouldPrintInfoLog : 是否允许输出 TMUILogLevelWarn 级别的 log
    TMUICMI.shouldPrintTMUIWarnLogToConsole = YES;                              // ShouldPrintTMUIWarnLogToConsole : 是否在出现 TMUILogWarn 时自动把这些 log 以 TMUIConsole 的方式显示到设备屏幕上
    
#pragma mark - TMUIBadge
    // 继承 TMUIConfiguration
    
//    TMUICMI.badgeBackgroundColor = UIColorRed;                                  // BadgeBackgroundColor : TMUIBadge 上的未读数的背景色
//    TMUICMI.badgeTextColor = UIColorWhite;                                      // BadgeTextColor : TMUIBadge 上的未读数的文字颜色
//    TMUICMI.badgeFont = UIFontBoldMake(11);                                     // BadgeFont : TMUIBadge 上的未读数的字体
//    TMUICMI.badgeContentEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);              // BadgeContentEdgeInsets : TMUIBadge 上的未读数与圆圈之间的 padding
//    TMUICMI.badgeOffset = CGPointMake(-9, 11);                                  // BadgeOffset : TMUIBadge 上的未读数相对于目标 view 右上角的偏移
//    TMUICMI.badgeOffsetLandscape = CGPointMake(-9, 6);                          // BadgeOffsetLandscape : TMUIBadge 上的未读数在横屏下相对于目标 view 右上角的偏移
//    BeginIgnoreDeprecatedWarning
//    TMUICMI.badgeCenterOffset = CGPointMake(14, -10);                           // BadgeCenterOffset : TMUIBadge 未读数相对于目标 view 中心的偏移
//    TMUICMI.badgeCenterOffsetLandscape = CGPointMake(16, -7);                   // BadgeCenterOffsetLandscape : TMUIBadge 未读数在横屏下相对于目标 view 中心的偏移
//    EndIgnoreDeprecatedWarning
//
//    TMUICMI.updatesIndicatorColor = UIColorRed;                                 // UpdatesIndicatorColor : TMUIBadge 上的未读红点的颜色
//    TMUICMI.updatesIndicatorSize = CGSizeMake(7, 7);                            // UpdatesIndicatorSize : TMUIBadge 上的未读红点的大小
//    TMUICMI.updatesIndicatorOffset = CGPointMake(4, UpdatesIndicatorSize.height);// UpdatesIndicatorOffset : TMUIBadge 未读红点相对于目标 view 右上角的偏移
//    TMUICMI.updatesIndicatorOffsetLandscape = UpdatesIndicatorOffset;           // UpdatesIndicatorOffsetLandscape : TMUIBadge 未读红点在横屏下相对于目标 view 右上角的偏移
//    BeginIgnoreDeprecatedWarning
//    TMUICMI.updatesIndicatorCenterOffset = CGPointMake(14, -10);                // UpdatesIndicatorCenterOffset : TMUIBadge 未读红点相对于目标 view 中心的偏移
//    TMUICMI.updatesIndicatorCenterOffsetLandscape = CGPointMake(14, -10);       // UpdatesIndicatorCenterOffsetLandscape : TMUIBadge 未读红点在横屏下相对于目标 view 中心点的偏移
//    EndIgnoreDeprecatedWarning
    
#pragma mark - Others
    
    TMUICMI.automaticCustomNavigationBarTransitionStyle = NO;                   // AutomaticCustomNavigationBarTransitionStyle : 界面 push/pop 时是否要自动根据两个界面的 barTintColor/backgroundImage/shadowImage 的样式差异来决定是否使用自定义的导航栏效果
    TMUICMI.supportedOrientationMask = UIInterfaceOrientationMaskAll;           // SupportedOrientationMask : 默认支持的横竖屏方向
    TMUICMI.automaticallyRotateDeviceOrientation = YES;                         // AutomaticallyRotateDeviceOrientation : 是否在界面切换或 viewController.supportedOrientationMask 发生变化时自动旋转屏幕
    TMUICMI.statusbarStyleLightInitially = YES;                                 // StatusbarStyleLightInitially : 默认的状态栏内容是否使用白色，默认为 NO，在 iOS 13 下会自动根据是否 Dark Mode 而切换样式，iOS 12 及以前则为黑色。生效范围：处于 TMUITabBarController 或 TMUINavigationController 内的 vc，或者 TMUICommonViewController 及其子类。
    TMUICMI.needsBackBarButtonItemTitle = NO;                                   // NeedsBackBarButtonItemTitle : 全局是否需要返回按钮的 title，不需要则只显示一个返回image
    TMUICMI.hidesBottomBarWhenPushedInitially = YES;                            // HidesBottomBarWhenPushedInitially : TMUICommonViewController.hidesBottomBarWhenPushed 的初始值，默认为 NO，以保持与系统默认值一致，但通常建议改为 YES，因为一般只有 tabBar 首页那几个界面要求为 NO
    TMUICMI.preventConcurrentNavigationControllerTransitions = YES;             // PreventConcurrentNavigationControllerTransitions : 自动保护 TMUINavigationController 在上一次 push/pop 尚未结束的时候就进行下一次 push/pop 的行为，避免产生 crash
    TMUICMI.navigationBarHiddenInitially = NO;                                  // NavigationBarHiddenInitially : TMUINavigationControllerDelegate preferredNavigationBarHidden 的初始值，默认为NO
    TMUICMI.shouldFixTabBarTransitionBugInIPhoneX = YES;                        // ShouldFixTabBarTransitionBugInIPhoneX : 是否需要自动修复 iOS 11 下，iPhone X 的设备在 push 界面时，tabBar 会瞬间往上跳的 bug
    TMUICMI.shouldFixTabBarSafeAreaInsetsBug = YES;                             // ShouldFixTabBarSafeAreaInsetsBug : 是否要对 iOS 11 及以后的版本修复当存在 UITabBar 时，UIScrollView 的 inset.bottom 可能错误的 bug（issue #218 #934），默认为 YES
    TMUICMI.shouldFixSearchBarMaskViewLayoutBug = YES;                          // ShouldFixSearchBarMaskViewLayoutBug : 是否自动修复 UISearchController.searchBar 被当作 tableHeaderView 使用时可能出现的布局 bug(issue #950)
    TMUICMI.sendAnalyticsToTMUITeam = NO;                                      // SendAnalyticsToTMUITeam : 是否允许在 DEBUG 模式下上报 Bundle Identifier 和 Display Name 给 TMUI 统计用
    TMUICMI.dynamicPreferredValueForIPad = NO;                                  // DynamicPreferredValueForIPad : 当 iPad 处于 Slide Over 或 Split View 分屏模式下，宏 `PreferredValueForXXX` 是否把 iPad 视为某种屏幕宽度近似的 iPhone 来取值。
    if (@available(iOS 13.0, *)) {
        TMUICMI.ignoreKVCAccessProhibited = NO;                                     // IgnoreKVCAccessProhibited : 是否全局忽略 iOS 13 对 KVC 访问 UIKit 私有属性的限制
        TMUICMI.adjustScrollIndicatorInsetsByContentInsetAdjustment = YES;          // AdjustScrollIndicatorInsetsByContentInsetAdjustment : 当将 UIScrollView.contentInsetAdjustmentBehavior 设为 UIScrollViewContentInsetAdjustmentNever 时，是否自动将 UIScrollView.automaticallyAdjustsScrollIndicatorInsets 设为 NO，以保证原本在 iOS 12 下的代码不用修改就能在 iOS 13 下正常控制滚动条的位置。
    }
}

// TMUI 2.3.0 版本里，配置表新增这个方法，返回 YES 表示在 App 启动时要自动应用这份配置表。仅当你的 App 里存在多份配置表时，才需要把除默认配置表之外的其他配置表的返回值改为 NO。
- (BOOL)shouldApplyTemplateAutomatically {
    [TMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:self.themeName theme:self];

    NSString *selectedThemeIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:TDSelectedThemeIdentifier];
    BOOL result = [selectedThemeIdentifier isEqualToString:self.themeName] || (!selectedThemeIdentifier && !TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier);
    if (result) {
        TMUIThemeManagerCenter.defaultThemeManager.currentTheme = self;
    }
    return result;
}

#pragma mark - <TDThemeProtocol>

- (UIColor *)themeBackgroundColor {
    return UIColorWhite;
}

- (UIColor *)themeBackgroundColorLighten {
    return self.themeBackgroundColor;
}

- (UIColor *)themeBackgroundColorHighlighted {
    return UIColorMake(238, 239, 241);
}

- (UIColor *)themeTintColor {
    return UIColorTheme0;
}

- (UIColor *)themeTitleTextColor {
    return UIColorGray1;
}

- (UIColor *)themeMainTextColor {
    return UIColorGray3;
}

- (UIColor *)themeDescriptionTextColor {
    return UIColorGray6;
}

- (UIColor *)themePlaceholderColor {
//    return UIColorGray8;
//    return UIColorPlaceholder; // 使用这个宏会造成循环引用
    return TMUIColorHex(0x979997);
}

- (UIColor *)themeCodeColor {
    return self.themeTintColor;
}

- (UIColor *)themeSeparatorColor {
//    return UIColorMake(222, 224, 226);
//    return UIColorSeparator; // 使用这个宏会造成循环引用
    return TMUIColorHex(0xE2E4E2);
}

- (UIColor *)themeGridItemTintColor {
    return self.themeTintColor;
}

- (NSString *)themeName {
    return TDThemeIdentifierDefault;
}

@end
