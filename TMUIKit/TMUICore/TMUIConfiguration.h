//
//  TMUIConfiguration.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// https://doc.weixin.qq.com/slide/p3_AEkA6wYLALQhsAuHKZYS5KlIGOK9Q?scode=AGcAeweXAA0NtM6M1eAEkA6wYLALQ
/// 所有配置表都应该实现的 protocol
/// All configuration templates should implement this protocal
@protocol TMUIConfigurationTemplateProtocol <NSObject>

@required
/// 应用配置表的设置
/// Applies configurations
- (void)applyConfigurationTemplate;

@optional
/// 当返回 YES 时，启动 App 的时候 TMUIConfiguration 会自动应用这份配置表。但启动 App 时自动应用的配置表最多只允许一份，如果有多份则其他的会被忽略
/// TMUIConfiguration automatically applies this template on launch when set to YES. Since only one copy of configuration template is allowed when the app launches, you'll have to call `applyConfigurationTemplate` manually if you have more than one configuration templates.
- (BOOL)shouldApplyTemplateAutomatically;

@end

/**
 *  维护项目全局 UI 配置的单例，通过业务项目自己的 TMUIConfigurationTemplate 来为这个单例赋值，而业务代码里则通过 TMUIConfigurationMacros.h 文件里的宏来使用这些值。
 *  A singleton that contains various UI configurations. Use `TMUIConfigurationTemplate` to set values; Use macros in `TMUIConfigurationMacros.h` to get values.
 */
@interface TMUIConfiguration : NSObject

/// 标志当前项目是否有使用配置表功能
@property(nonatomic, assign, readonly) BOOL active;

#pragma mark - Global Color

@property(nonatomic, strong) UIColor            *clearColor;
@property(nonatomic, strong) UIColor            *whiteColor;
@property(nonatomic, strong) UIColor            *blackColor;
@property(nonatomic, strong) UIColor            *grayColor;
@property(nonatomic, strong) UIColor            *grayDarkenColor;
@property(nonatomic, strong) UIColor            *grayLightenColor;

#pragma mark - Main Color

@property(nonatomic, strong) UIColor            *redColor;
@property(nonatomic, strong) UIColor            *greenColor;
@property(nonatomic, strong) UIColor            *blueColor;
@property(nonatomic, strong) UIColor            *yellowColor;
@property(nonatomic, strong) UIColor            *cyanColor;
@property(nonatomic, strong) UIColor            *orangeColor;
@property(nonatomic, strong) UIColor            *darkGreenColor;

#pragma mark - Content Color

@property(nonatomic, strong) UIColor            *darkColor;///< 1A1C1A  ---极黑，重点突出
@property(nonatomic, strong) UIColor            *primaryColor; ///< 333533 ---主黑色
@property(nonatomic, strong) UIColor            *secondaryColor; ///< 4C4E4C ---次黑
@property(nonatomic, strong) UIColor            *regularColor; ///< 656866 ---正文
@property(nonatomic, strong) UIColor            *weakColor; ///< 7E807E   ---弱提示
@property(nonatomic, strong) UIColor            *placeholderColor; ///< 979997 ---占位
@property(nonatomic, strong) UIColor            *borderColor; ///< C9CBC9  ---边框
@property(nonatomic, strong) UIColor            *separatorColor;///< E2E4E2 --分割
@property(nonatomic, strong) UIColor            *backgroundGrayColor;///< ECEEEC --灰色背景
@property(nonatomic, strong) UIColor            *backgroundLightColor;///< F6F8F6 --偏白色背景

#pragma mark - Function Color
@property(nonatomic, strong) UIColor            *backgroundColor;///< 通常为白色
@property(nonatomic, strong) UIColor            *linkColor;
@property(nonatomic, strong) UIColor            *disabledColor;
@property(nonatomic, strong) UIColor            *maskDarkColor;
@property(nonatomic, strong) UIColor            *maskLightColor;
@property(nonatomic, strong) UIColor            *separatorDashedColor;
///
@property(nonatomic, strong) UIColor            *testColorRed;
@property(nonatomic, strong) UIColor            *testColorGreen;
@property(nonatomic, strong) UIColor            *testColorBlue;

#pragma mark - UILabel

@property(nonatomic, strong) UIColor            *textGreen;
@property(nonatomic, strong) UIColor            *textImportantColor;
@property(nonatomic, strong) UIColor            *textRegularColor;
@property(nonatomic, strong) UIColor            *textWeakColor;
@property(nonatomic, strong) UIColor            *textPlaceholderColor;

#pragma mark - UIControl

@property(nonatomic, assign) CGFloat            controlHighlightedAlpha;
@property(nonatomic, assign) CGFloat            controlDisabledAlpha;

#pragma mark - UIButton

@property(nonatomic, assign) CGFloat            buttonHighlightedAlpha;
@property(nonatomic, assign) CGFloat            buttonDisabledAlpha;
@property(nonatomic, strong, nullable)  UIColor *buttonTintColor;

#pragma mark - UITextField & UITextView

@property(nonatomic, strong, nullable) UIColor  *textFieldTextColor;
@property(nonatomic, strong, nullable) UIColor  *textFieldTintColor;
@property(nonatomic, assign) UIEdgeInsets       textFieldTextInsets;
@property(nonatomic, assign) UIKeyboardAppearance keyboardAppearance;

#pragma mark - UISwitch
@property(nonatomic, strong, nullable) UIColor  *switchOnTintColor;
@property(nonatomic, strong, nullable) UIColor  *switchOffTintColor;
@property(nonatomic, strong, nullable) UIColor  *switchTintColor;
@property(nonatomic, strong, nullable) UIColor  *switchThumbTintColor;
@property(nonatomic, strong, nullable) UIImage  *switchOnImage;
@property(nonatomic, strong, nullable) UIImage  *switchOffImage;

#pragma mark - NavigationBar

@property(nonatomic, copy, nullable) NSArray<Class<UIAppearanceContainer>> *navBarContainerClasses;
@property(nonatomic, strong, nullable) UIColor  *navBarItemLightColor;
@property(nonatomic, strong, nullable) UIColor  *navBarItemThemeColor;
@property(nonatomic, strong, nullable) UIColor  *navBarItemDarkColor;
@property(nonatomic, strong, nullable) UIFont   *navBarItemFont;
@property(nonatomic, assign) CGFloat            navBarHighlightedAlpha;
@property(nonatomic, assign) CGFloat            navBarDisabledAlpha;
@property(nonatomic, strong, nullable) UIFont   *navBarButtonFont;
@property(nonatomic, strong, nullable) UIFont   *navBarButtonFontBold;
@property(nonatomic, strong, nullable) UIImage  *navBarBackgroundImage;
@property(nonatomic, strong, nullable) UIImage  *navBarShadowImage;
@property(nonatomic, strong, nullable) UIColor  *navBarShadowImageColor;
@property(nonatomic, strong, nullable) UIColor  *navBarBarTintColor;
@property(nonatomic, assign) UIBarStyle         navBarStyle;
@property(nonatomic, strong, nullable) UIColor  *navBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *navBarTitleColor;
@property(nonatomic, strong, nullable) UIFont   *navBarTitleFont;
@property(nonatomic, strong, nullable) UIColor  *navBarLargeTitleColor;
@property(nonatomic, strong, nullable) UIFont   *navBarLargeTitleFont;
@property(nonatomic, assign) UIOffset           navBarBackButtonTitlePositionAdjustment;
@property(nonatomic, assign) BOOL               sizeNavBarBackIndicatorImageAutomatically;
@property(nonatomic, strong, nullable) UIImage  *navBarBackIndicatorImage;
@property(nonatomic, strong) UIImage            *navBarCloseButtonImage;

@property(nonatomic, assign) CGFloat            navBarLoadingMarginRight;
@property(nonatomic, assign) CGFloat            navBarAccessoryViewMarginLeft;
@property(nonatomic, assign) UIActivityIndicatorViewStyle navBarActivityIndicatorViewStyle;
@property(nonatomic, strong) UIImage            *navBarAccessoryViewTypeDisclosureIndicatorImage;

#pragma mark - TabBar

@property(nonatomic, copy, nullable) NSArray<Class<UIAppearanceContainer>> *tabBarContainerClasses;
@property(nonatomic, strong, nullable) UIImage  *tabBarBackgroundImage;
@property(nonatomic, strong, nullable) UIColor  *tabBarBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *tabBarShadowImageColor;
@property(nonatomic, assign) UIBarStyle         tabBarStyle;
@property(nonatomic, strong, nullable) UIFont   *tabBarItemTitleFont;
@property(nonatomic, strong, nullable) UIFont   *tabBarItemTitleFontSelected;
@property(nonatomic, strong, nullable) UIColor  *tabBarItemTitleColor;
@property(nonatomic, strong, nullable) UIColor  *tabBarItemTitleColorSelected;
@property(nonatomic, strong, nullable) UIColor  *tabBarItemImageColor;
@property(nonatomic, strong, nullable) UIColor  *tabBarItemImageColorSelected;

#pragma mark - Toolbar

@property(nonatomic, copy, nullable) NSArray<Class<UIAppearanceContainer>> *toolBarContainerClasses;
@property(nonatomic, assign) CGFloat            toolBarHighlightedAlpha;
@property(nonatomic, assign) CGFloat            toolBarDisabledAlpha;
@property(nonatomic, strong, nullable) UIColor  *toolBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *toolBarTintColorHighlighted;
@property(nonatomic, strong, nullable) UIColor  *toolBarTintColorDisabled;
@property(nonatomic, strong, nullable) UIImage  *toolBarBackgroundImage;
@property(nonatomic, strong, nullable) UIColor  *toolBarBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *toolBarShadowImageColor;
@property(nonatomic, assign) UIBarStyle         toolBarStyle;
@property(nonatomic, strong, nullable) UIFont   *toolBarButtonFont;

#pragma mark - SearchBar

@property(nonatomic, assign) CGFloat            searchBarCornerRadius;
@property(nonatomic, strong, nullable) UIImage  *searchBarTextFieldBackgroundImage;
@property(nonatomic, strong, nullable) UIColor  *searchBarTextFieldBorderColor;
@property(nonatomic, strong, nullable) UIImage  *searchBarBackgroundImage;
@property(nonatomic, strong, nullable) UIColor  *searchBarTintColor;
@property(nonatomic, strong, nullable) UIColor  *searchBarTextColor;
@property(nonatomic, strong, nullable) UIColor  *searchBarPlaceholderColor;
@property(nonatomic, strong, nullable) UIFont   *searchBarFont;
/// 搜索框放大镜icon的图片，大小必须为14x14pt，否则会失真（系统的限制）
/// The magnifier icon in search bar. Size must be 14 x 14pt to avoid being distorted.
@property(nonatomic, strong, nullable) UIImage  *searchBarSearchIconImage;
@property(nonatomic, strong, nullable) UIImage  *searchBarClearIconImage;
@property(nonatomic, assign) CGFloat            searchBarTextFieldCornerRadius;

#pragma mark - TableView / TableViewCell

@property(nonatomic, assign) BOOL               tableViewEstimatedHeightEnabled;

@property(nonatomic, strong, nullable) UIColor  *tableViewBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableSectionIndexColor;
@property(nonatomic, strong, nullable) UIColor  *tableSectionIndexBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableSectionIndexTrackingBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewSeparatorColor;

@property(nonatomic, assign) CGFloat            tableViewCellNormalHeight;
@property(nonatomic, strong, nullable) UIColor  *tableViewCellTitleLabelColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewCellDetailLabelColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewCellBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewCellSelectedBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewCellWarningBackgroundColor;
@property(nonatomic, strong, nullable) UIImage  *tableViewCellDisclosureIndicatorImage;
@property(nonatomic, strong, nullable) UIImage  *tableViewCellCheckmarkImage;
@property(nonatomic, strong, nullable) UIImage  *tableViewCellDetailButtonImage;
@property(nonatomic, assign) CGFloat tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator;

@property(nonatomic, strong, nullable) UIColor  *tableViewSectionHeaderBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewSectionFooterBackgroundColor;
@property(nonatomic, strong, nullable) UIFont   *tableViewSectionHeaderFont;
@property(nonatomic, strong, nullable) UIFont   *tableViewSectionFooterFont;
@property(nonatomic, strong, nullable) UIColor  *tableViewSectionHeaderTextColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewSectionFooterTextColor;
@property(nonatomic, assign) UIEdgeInsets       tableViewSectionHeaderAccessoryMargins;
@property(nonatomic, assign) UIEdgeInsets       tableViewSectionFooterAccessoryMargins;
@property(nonatomic, assign) UIEdgeInsets       tableViewSectionHeaderContentInset;
@property(nonatomic, assign) UIEdgeInsets       tableViewSectionFooterContentInset;

@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedSeparatorColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedCellTitleLabelColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedCellDetailLabelColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedCellBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedCellSelectedBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedCellWarningBackgroundColor;
@property(nonatomic, strong, nullable) UIFont   *tableViewGroupedSectionHeaderFont;
@property(nonatomic, strong, nullable) UIFont   *tableViewGroupedSectionFooterFont;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedSectionHeaderTextColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewGroupedSectionFooterTextColor;
@property(nonatomic, assign) UIEdgeInsets       tableViewGroupedSectionHeaderAccessoryMargins;
@property(nonatomic, assign) UIEdgeInsets       tableViewGroupedSectionFooterAccessoryMargins;
@property(nonatomic, assign) CGFloat            tableViewGroupedSectionHeaderDefaultHeight;
@property(nonatomic, assign) CGFloat            tableViewGroupedSectionFooterDefaultHeight;
@property(nonatomic, assign) UIEdgeInsets       tableViewGroupedSectionHeaderContentInset;
@property(nonatomic, assign) UIEdgeInsets       tableViewGroupedSectionFooterContentInset;

@property(nonatomic, assign) CGFloat            tableViewInsetGroupedCornerRadius;
@property(nonatomic, assign) CGFloat            tableViewInsetGroupedHorizontalInset;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedSeparatorColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedCellTitleLabelColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedCellDetailLabelColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedCellBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedCellSelectedBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedCellWarningBackgroundColor;
@property(nonatomic, strong, nullable) UIFont   *tableViewInsetGroupedSectionHeaderFont;
@property(nonatomic, strong, nullable) UIFont   *tableViewInsetGroupedSectionFooterFont;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedSectionHeaderTextColor;
@property(nonatomic, strong, nullable) UIColor  *tableViewInsetGroupedSectionFooterTextColor;
@property(nonatomic, assign) UIEdgeInsets       tableViewInsetGroupedSectionHeaderAccessoryMargins;
@property(nonatomic, assign) UIEdgeInsets       tableViewInsetGroupedSectionFooterAccessoryMargins;
@property(nonatomic, assign) CGFloat            tableViewInsetGroupedSectionHeaderDefaultHeight;
@property(nonatomic, assign) CGFloat            tableViewInsetGroupedSectionFooterDefaultHeight;
@property(nonatomic, assign) UIEdgeInsets       tableViewInsetGroupedSectionHeaderContentInset;
@property(nonatomic, assign) UIEdgeInsets       tableViewInsetGroupedSectionFooterContentInset;

#pragma mark - UIWindowLevel

@property(nonatomic, assign) CGFloat            windowLevelTMUIAlertView;
@property(nonatomic, assign) CGFloat            windowLevelTMUIConsole;

#pragma mark - TMUILog

@property(nonatomic, assign) BOOL               shouldPrintDefaultLog;
@property(nonatomic, assign) BOOL               shouldPrintInfoLog;
@property(nonatomic, assign) BOOL               shouldPrintWarnLog;
@property(nonatomic, assign) BOOL               shouldPrintTMUIWarnLogToConsole;

#pragma mark - TMUIBadge

@property(nonatomic, strong, nullable) NSArray <UIColor *>  *badgeGradientBackgroundColors;
@property(nonatomic, assign) NSInteger          badgeGradientType; // 0:left-right, 1:top-bottom
@property(nonatomic, strong, nullable) UIColor  *badgeBackgroundColor;
@property(nonatomic, strong, nullable) UIColor  *badgeTextColor;
@property(nonatomic, strong, nullable) UIFont   *badgeFont;
@property(nonatomic, assign) UIEdgeInsets       badgeContentEdgeInsets;
@property(nonatomic, assign) CGPoint            badgeOffset;
@property(nonatomic, assign) CGPoint            badgeOffsetLandscape;
@property(nonatomic, assign) CGPoint            badgeCenterOffset DEPRECATED_MSG_ATTRIBUTE("请改为使用 badgeOffset");
@property(nonatomic, assign) CGPoint            badgeCenterOffsetLandscape DEPRECATED_MSG_ATTRIBUTE("请改为使用 badgeOffsetLandscape");

@property(nonatomic, strong, nullable) UIColor  *updatesIndicatorColor;
@property(nonatomic, assign) CGSize             updatesIndicatorSize;
@property(nonatomic, assign) CGPoint            updatesIndicatorOffset;
@property(nonatomic, assign) CGPoint            updatesIndicatorOffsetLandscape;
@property(nonatomic, assign) CGPoint            updatesIndicatorCenterOffset DEPRECATED_MSG_ATTRIBUTE("请改为使用 updatesIndicatorOffset");
@property(nonatomic, assign) CGPoint            updatesIndicatorCenterOffsetLandscape DEPRECATED_MSG_ATTRIBUTE("请改为使用 updatesIndicatorOffsetLandscape");

@property(nonatomic, assign) NSInteger          badgeLocation;

#pragma mark - Others

@property(nonatomic, assign) BOOL               automaticCustomNavigationBarTransitionStyle;
@property(nonatomic, assign) UIInterfaceOrientationMask supportedOrientationMask;
@property(nonatomic, assign) BOOL               automaticallyRotateDeviceOrientation;
@property(nonatomic, assign) BOOL               statusbarStyleLightInitially;
@property(nonatomic, assign) BOOL               needsBackBarButtonItemTitle;
@property(nonatomic, assign) BOOL               hidesBottomBarWhenPushedInitially;
@property(nonatomic, assign) BOOL               preventConcurrentNavigationControllerTransitions;
@property(nonatomic, assign) BOOL               navigationBarHiddenInitially;
@property(nonatomic, assign) BOOL               shouldFixTabBarTransitionBugInIPhoneX;
@property(nonatomic, assign) BOOL               shouldFixTabBarSafeAreaInsetsBug;
@property(nonatomic, assign) BOOL               shouldFixSearchBarMaskViewLayoutBug;
@property(nonatomic, assign) BOOL               sendAnalyticsToTMUITeam;
@property(nonatomic, assign) BOOL               dynamicPreferredValueForIPad;
@property(nonatomic, assign) BOOL               ignoreKVCAccessProhibited API_AVAILABLE(ios(13.0));
@property(nonatomic, assign) BOOL               adjustScrollIndicatorInsetsByContentInsetAdjustment API_AVAILABLE(ios(13.0));

/// 单例对象
/// The singleton instance
+ (instancetype _Nullable )sharedInstance;
- (void)applyInitialTemplate;

@end

@interface UINavigationBar (TMUIConfiguration)

/**
 返回由配置表项 NavBarContainerClasses 配置的 UINavigationBar appearance 对象，用于代替 [UINavigationBar appearanceWhenContainedInInstancesOfClasses:NavBarContainerClasses] 的冗长写法。当配置表项 NavBarContainerClasses 为 nil 或空数组时，本方法等价于 UINavigationBar.appearance。
 */
+ (instancetype)tmui_appearanceConfigured;
@end

@interface UITabBar (TMUIConfiguration)

/**
 返回由配置表项 TabBarContainerClasses 配置的 UITabBar appearance 对象，用于代替 [UITabBar appearanceWhenContainedInInstancesOfClasses:TabBarContainerClasses] 的冗长写法。当配置表项 TabBarContainerClasses 为 nil 或空数组时，本方法等价于 UITabBar.appearance。
 */
+ (instancetype)tmui_appearanceConfigured;
@end

@interface UIToolbar (TMUIConfiguration)

/**
 返回由配置表项 ToolBarContainerClasses 配置的 UIToolbar appearance 对象，用于代替 [UIToolbar appearanceWhenContainedInInstancesOfClasses:ToolBarContainerClasses] 的冗长写法。当配置表项 ToolBarContainerClasses 为 nil 或空数组时，本方法等价于 UIToolbar.appearance。
 */
+ (instancetype)tmui_appearanceConfigured;
@end

@interface UITabBarItem (TMUIConfiguration)

+ (instancetype)tmui_appearanceConfigured;
@end

NS_ASSUME_NONNULL_END
