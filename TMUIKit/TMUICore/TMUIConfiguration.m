//
//  TMUIConfiguration.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import "TMUIConfiguration.h"
#import "TMUICore.h"
#import "TMUIConfigurationMacros.h"
#import "TMUIKitDefines.h"
#import "TMUICommonDefines.h"

@implementation UITabBarAppearance (QMUI)

- (void)tmui_applyItemAppearanceWithBlock:(void (^)(UITabBarItemAppearance * _Nonnull))block {
    block(self.stackedLayoutAppearance);
    block(self.inlineLayoutAppearance);
    block(self.compactInlineLayoutAppearance);
}


@end


// 在 iOS 8 - 11 上实际测量得到
// Measured on iOS 8 - 11
const CGSize kUINavigationBarBackIndicatorImageSize = {13, 21};

@interface TMUIConfiguration ()

@property(nonatomic, strong) UITabBarAppearance *tabBarAppearance API_AVAILABLE(ios(13.0));
@property(nonatomic, strong) UINavigationBarAppearance *navBarAppearance API_AVAILABLE(ios(13.0));
@end

@implementation UIViewController (TMUIConfiguration)

- (NSArray <UIViewController *>*)tmui_existingViewControllersOfClasses:(NSArray<Class<UIAppearanceContainer>> *)classes {
    NSMutableSet *viewControllers = [NSMutableSet set];
    if (self.presentedViewController) {
        [viewControllers addObjectsFromArray:[self.presentedViewController tmui_existingViewControllersOfClasses:classes]];
    }
    if ([self isKindOfClass:UINavigationController.class]) {
        [viewControllers addObjectsFromArray:[((UINavigationController *)self).visibleViewController tmui_existingViewControllersOfClasses:classes]];
    }
    if ([self isKindOfClass:UITabBarController.class]) {
        [viewControllers addObjectsFromArray:[((UITabBarController *)self).selectedViewController tmui_existingViewControllersOfClasses:classes]];
    }
    for (Class class in classes) {
        if ([self isKindOfClass:class]) {
            [viewControllers addObject:self];
            break;
        }
    }
    return viewControllers.allObjects;
}

@end

@implementation TMUIConfiguration

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static TMUIConfiguration *sharedInstance;
    dispatch_once(&pred, ^{
        sharedInstance = [[TMUIConfiguration alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultConfiguration];
    }
    return self;
}

static BOOL TMUI_hasAppliedInitialTemplate;
- (void)applyInitialTemplate {
    if (TMUI_hasAppliedInitialTemplate) {
        return;
    }
    
    // 自动寻找并应用模板
    // Automatically look for templates and apply them
    // @see https://github.com/Tencent/TMUI_iOS/issues/264
    Protocol *protocol = @protocol(TMUIConfigurationTemplateProtocol);
    classref_t *classesref = nil;
    Class *classes = nil;
    int numberOfClasses = tmui_getProjectClassList(&classesref);
    if (numberOfClasses <= 0) {
        numberOfClasses = objc_getClassList(NULL, 0);
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
        objc_getClassList(classes, numberOfClasses);
    }
    for (NSInteger i = 0; i < numberOfClasses; i++) {
        Class class = classesref ? (__bridge Class)classesref[i] : classes[i];
        // 这里用 containsString 是考虑到 Swift 里 className 由“项目前缀+class 名”组成，如果用 hasPrefix 就无法判断了
        // Use `containsString` instead of `hasPrefix` because class names in Swift have project prefix prepended
        if ([NSStringFromClass(class) containsString:@"TMUIConfigurationTemplate"] && [class conformsToProtocol:protocol]) {
            if ([class instancesRespondToSelector:@selector(shouldApplyTemplateAutomatically)]) {
                id<TMUIConfigurationTemplateProtocol> template = [[class alloc] init];
                if ([template shouldApplyTemplateAutomatically]) {
                    TMUI_hasAppliedInitialTemplate = YES;
                    _active = YES;// 标志配置表已生效
                    [template applyConfigurationTemplate];
                    // 只应用第一个 shouldApplyTemplateAutomatically 的主题
                    // Only apply the first template returned
                    break;
                }
            }
        }
    }
    
    if (IS_DEBUG && self.sendAnalyticsToTMUITeam) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue new] usingBlock:^(NSNotification * _Nonnull note) {
            // 这里根据是否能成功获取到 classesref 来统计信息，以供后续确认对 classesref 为 nil 的保护是否真的必要
            [self sendAnalyticsWithQuery:classes ? @"findByObjc=true" : nil];
        }];
    }
    
    if (classes) free(classes);
    
    TMUI_hasAppliedInitialTemplate = YES;
}

- (void)sendAnalyticsWithQuery:(NSString *)query {
//    NSString *identifier = [NSBundle mainBundle].bundleIdentifier.tmui_stringByEncodingUserInputQuery;
//    NSString *displayName = ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] ?: [NSBundle mainBundle].infoDictionary[@"CFBundleName"])).tmui_stringByEncodingUserInputQuery;
//    NSString *TMUIVersion = @"1.1.0".tmui_stringByEncodingUserInputQuery;// 如果不以 framework 方式引入 TMUI 的话，是无法通过 CFBundleShortVersionString 获取到 TMUI 所在的 bundle 的版本号的，所以这里改为用脚本生成的变量来获取
//    NSString *queryString = [NSString stringWithFormat:@"appId=%@&appName=%@&version=%@&platform=iOS", identifier, displayName, TMUIVersion];
//    if (query.length > 0) queryString = [NSString stringWithFormat:@"%@&%@", queryString, query];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://tmuiteam.com/analytics/usageReport"]];
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [queryString dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithRequest:request] resume];
}

#pragma mark - Initialize default values

- (void)initDefaultConfiguration {
    
    #pragma mark - Global Color
    
    self.clearColor = UIColorMakeWithRGBA(255, 255, 255, 0);
    self.whiteColor = UIColorMake(255, 255, 255);
    self.blackColor = UIColorMake(0, 0, 0);
    self.grayColor = UIColorMake(179, 179, 179);
    self.grayDarkenColor = UIColorMake(163, 163, 163);
    self.grayLightenColor = UIColorMake(198, 198, 198);
    
    #pragma mark - Main Color
    
    self.redColor = TMUIColorHex(0xFD6343);
    self.greenColor = TMUIColorHex(0x22C787);
    self.blueColor = TMUIColorHex(0x3A8EF0);
    self.yellowColor = TMUIColorHex(0xFFC63F);
    self.cyanColor = TMUIColorHex(0x1BD6DD);
    self.orangeColor = TMUIColorHex(0xFF832B);
    self.darkGreenColor = TMUIColorHex(0x23AD78);
    
    #pragma mark - Content Color

    self.darkColor = TMUIColorHex(0x1A1C1A);
    self.primaryColor = TMUIColorHex(0x333533);
    self.secondaryColor = TMUIColorHex(0x4C4E4C);
    self.regularColor = TMUIColorHex(0x656866);
    self.weakColor = TMUIColorHex(0x7E807E);
    self.placeholderColor = TMUIColorHex(0x979997);
    self.borderColor = TMUIColorHex(0xC9CBC9);
    self.separatorColor = TMUIColorHex(0xE2E4E2);
    self.backgroundGrayColor = TMUIColorHex(0xECEEEC);
    self.backgroundLightColor = TMUIColorHex(0xF6F8F6);
    
    #pragma mark - Function Color
    self.backgroundColor = self.whiteColor;
    self.linkColor = UIColorMake(56, 116, 171);
    self.disabledColor = self.grayColor;
    self.maskDarkColor = UIColorMakeWithRGBA(0, 0, 0, .35f);
    self.maskLightColor = UIColorMakeWithRGBA(255, 255, 255, .5f);
    self.separatorDashedColor = UIColorMake(17, 17, 17);
    
    self.testColorRed = UIColorMakeWithRGBA(255, 0, 0, .3);
    self.testColorGreen = UIColorMakeWithRGBA(0, 255, 0, .3);
    self.testColorBlue = UIColorMakeWithRGBA(0, 0, 255, .3);
    
    #pragma mark - UILabel
    
    self.textGreen = self.greenColor;
    self.textImportantColor = self.darkColor;
    self.textRegularColor = self.primaryColor;
    self.textWeakColor = self.weakColor;
    self.textPlaceholderColor = self.placeholderColor;
    
    #pragma mark - UIControl
    
    self.controlHighlightedAlpha = 0.5f;
    self.controlDisabledAlpha = 0.5f;
    
    #pragma mark - UIButton
    
    self.buttonHighlightedAlpha = self.controlHighlightedAlpha;
    self.buttonDisabledAlpha = self.controlDisabledAlpha;
    self.buttonTintColor = self.blueColor;
    
//    self.ghostButtonColorBlue = self.blueColor;
//    self.ghostButtonColorRed = self.redColor;
//    self.ghostButtonColorGreen = self.greenColor;
//    self.ghostButtonColorGray = self.grayColor;
//    self.ghostButtonColorWhite = self.whiteColor;
//
//    self.fillButtonColorBlue = self.blueColor;
//    self.fillButtonColorRed = self.redColor;
//    self.fillButtonColorGreen = self.greenColor;
//    self.fillButtonColorGray = self.grayColor;
//    self.fillButtonColorWhite = self.whiteColor;
    
    #pragma mark - UITextField & UITextView
    
    self.textFieldTextInsets = UIEdgeInsetsMake(0, 7, 0, 7);
    
    #pragma mark - NavigationBar
    self.navBarItemLightColor = self.whiteColor;
    self.navBarItemThemeColor = self.greenColor;
    self.navBarItemDarkColor = TMUIColorHex(333333);
    self.navBarItemFont = UIFontMake(16);
    self.navBarHighlightedAlpha = 0.2f;
    self.navBarDisabledAlpha = 0.2f;
    self.sizeNavBarBackIndicatorImageAutomatically = YES;
//    self.navBarCloseButtonImage = [UIImage tmui_imageWithShape:TMUIImageShapeNavClose size:CGSizeMake(16, 16) tintColor:self.navBarTintColor];
    
    self.navBarLoadingMarginRight = 3;
    self.navBarAccessoryViewMarginLeft = 5;
    self.navBarActivityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    self.navBarAccessoryViewTypeDisclosureIndicatorImage = [[UIImage tmui_imageWithShape:TMUIImageShapeTriangle size:CGSizeMake(8, 5) tintColor:self.navBarTitleColor] tmui_imageWithOrientation:UIImageOrientationDown];
    
    
    #pragma mark - Toolbar
    
    self.toolBarHighlightedAlpha = 0.4f;
    self.toolBarDisabledAlpha = 0.4f;
    
    #pragma mark - SearchBar
    
    self.searchBarCornerRadius = 8.0;
    self.searchBarPlaceholderColor = self.placeholderColor;
    self.searchBarTextFieldCornerRadius = 2.0;
    
    #pragma mark - TableView / TableViewCell
    
    self.tableViewEstimatedHeightEnabled = YES;
    
    self.tableViewSeparatorColor = self.separatorColor;
    
    self.tableViewCellNormalHeight = UITableViewAutomaticDimension;
    self.tableViewCellSelectedBackgroundColor = UIColorMake(238, 239, 241);
    self.tableViewCellWarningBackgroundColor = self.yellowColor;
    self.tableViewCellSpacingBetweenDetailButtonAndDisclosureIndicator = 12;
    
    self.tableViewSectionHeaderBackgroundColor = UIColorMake(244, 244, 244);
    self.tableViewSectionFooterBackgroundColor = UIColorMake(244, 244, 244);
    self.tableViewSectionHeaderFont = UIFontBoldMake(12);
    self.tableViewSectionFooterFont = UIFontBoldMake(12);
    self.tableViewSectionHeaderTextColor = self.grayDarkenColor;
    self.tableViewSectionFooterTextColor = self.grayColor;
    self.tableViewSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewSectionHeaderContentInset = UIEdgeInsetsMake(4, 15, 4, 15);
    self.tableViewSectionFooterContentInset = UIEdgeInsetsMake(4, 15, 4, 15);
    
    self.tableViewGroupedSeparatorColor = self.tableViewSeparatorColor;
    self.tableViewGroupedSectionHeaderFont = UIFontMake(12);
    self.tableViewGroupedSectionFooterFont = UIFontMake(12);
    self.tableViewGroupedSectionHeaderTextColor = self.grayDarkenColor;
    self.tableViewGroupedSectionFooterTextColor = self.grayColor;
    self.tableViewGroupedSectionHeaderAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewGroupedSectionFooterAccessoryMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableViewGroupedSectionHeaderDefaultHeight = UITableViewAutomaticDimension;
    self.tableViewGroupedSectionFooterDefaultHeight = UITableViewAutomaticDimension;
    self.tableViewGroupedSectionHeaderContentInset = UIEdgeInsetsMake(16, 15, 8, 15);
    self.tableViewGroupedSectionFooterContentInset = UIEdgeInsetsMake(8, 15, 2, 15);
    
    self.tableViewInsetGroupedCornerRadius = 10;
    self.tableViewInsetGroupedHorizontalInset = PreferredValueForVisualDevice(20, 15);
    self.tableViewInsetGroupedSeparatorColor = self.tableViewSeparatorColor;
    self.tableViewInsetGroupedSectionHeaderFont = self.tableViewGroupedSectionHeaderFont;
    self.tableViewInsetGroupedSectionFooterFont = self.tableViewGroupedSectionFooterFont;
    self.tableViewInsetGroupedSectionHeaderTextColor = self.tableViewSectionHeaderTextColor;
    self.tableViewInsetGroupedSectionFooterTextColor = self.tableViewGroupedSectionFooterTextColor;
    self.tableViewInsetGroupedSectionHeaderAccessoryMargins = self.tableViewGroupedSectionHeaderAccessoryMargins;
    self.tableViewInsetGroupedSectionFooterAccessoryMargins = self.tableViewGroupedSectionFooterAccessoryMargins;
    self.tableViewInsetGroupedSectionHeaderDefaultHeight = self.tableViewGroupedSectionHeaderDefaultHeight;
    self.tableViewInsetGroupedSectionFooterDefaultHeight = self.tableViewGroupedSectionFooterDefaultHeight;
    self.tableViewInsetGroupedSectionHeaderContentInset = self.tableViewGroupedSectionHeaderContentInset;
    self.tableViewInsetGroupedSectionFooterContentInset = self.tableViewGroupedSectionFooterContentInset;
    
    #pragma mark - UIWindowLevel
    self.windowLevelTMUIAlertView = UIWindowLevelAlert - 4.0;
    self.windowLevelTMUIConsole = 1;
    
    #pragma mark - TMUILog
    self.shouldPrintDefaultLog = YES;
    self.shouldPrintInfoLog = YES;
    self.shouldPrintWarnLog = YES;
    self.shouldPrintTMUIWarnLogToConsole = IS_DEBUG;
    
    #pragma mark - TMUIBadge
//    self.badgeOffset = TMUIBadgeInvalidateOffset;
//    self.badgeOffsetLandscape = TMUIBadgeInvalidateOffset;
//    self.updatesIndicatorOffset = TMUIBadgeInvalidateOffset;
//    self.updatesIndicatorOffsetLandscape = TMUIBadgeInvalidateOffset;
    self.badgeGradientBackgroundColors = @[TMUIColorHex(FE9770),self.redColor];
    self.badgeGradientType = 0;
    self.badgeBackgroundColor = self.redColor;                                  // BadgeBackgroundColor : TMUIBadge 上的未读数的背景色
    self.badgeTextColor = self.whiteColor;                                      // BadgeTextColor : TMUIBadge 上的未读数的文字颜色
    self.badgeFont = UIFontDINAlt(10);                                       // BadgeFont : TMUIBadge 上的未读数的字体
    self.badgeContentEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 4);              // BadgeContentEdgeInsets : TMUIBadge 上的未读数与圆圈之间的 padding
    self.badgeOffset = CGPointMake(-9, 11);                                  // BadgeOffset : TMUIBadge 上的未读数相对于目标 view 右上角的偏移
    self.badgeOffsetLandscape = CGPointMake(-9, 6);                          // BadgeOffsetLandscape : TMUIBadge 上的未读数在横屏下相对于目标 view 右上角的偏移
    BeginIgnoreDeprecatedWarning
    self.badgeCenterOffset = CGPointMake(14, -10);                           // BadgeCenterOffset : TMUIBadge 未读数相对于目标 view 中心的偏移
    self.badgeCenterOffsetLandscape = CGPointMake(16, -7);                   // BadgeCenterOffsetLandscape : TMUIBadge 未读数在横屏下相对于目标 view 中心的偏移
    EndIgnoreDeprecatedWarning
    
    self.updatesIndicatorColor = self.redColor;                                 // UpdatesIndicatorColor : TMUIBadge 上的未读红点的颜色
    self.updatesIndicatorSize = CGSizeMake(7, 7);                            // UpdatesIndicatorSize : TMUIBadge 上的未读红点的大小
    self.updatesIndicatorOffset = CGPointMake(4, self.updatesIndicatorSize.height);// UpdatesIndicatorOffset : TMUIBadge 未读红点相对于目标 view 右上角的偏移
    self.updatesIndicatorOffsetLandscape = self.updatesIndicatorOffset;           // UpdatesIndicatorOffsetLandscape : TMUIBadge 未读红点在横屏下相对于目标 view 右上角的偏移
    BeginIgnoreDeprecatedWarning
    self.updatesIndicatorCenterOffset = CGPointMake(14, -10);                // UpdatesIndicatorCenterOffset : TMUIBadge 未读红点相对于目标 view 中心的偏移
    self.updatesIndicatorCenterOffsetLandscape = CGPointMake(14, -10);       // UpdatesIndicatorCenterOffsetLandscape : TMUIBadge 未读红点在横屏下相对于目标 view 中心点的偏移
    self.badgeLocation = 0;
    EndIgnoreDeprecatedWarning
    
    #pragma mark - Others
    
    self.supportedOrientationMask = UIInterfaceOrientationMaskAll;
    self.needsBackBarButtonItemTitle = YES;
    self.preventConcurrentNavigationControllerTransitions = YES;
    self.shouldFixTabBarSafeAreaInsetsBug = YES;
    self.sendAnalyticsToTMUITeam = NO;
}

#pragma mark - Switch Setter

- (void)setSwitchOnTintColor:(UIColor *)switchOnTintColor {
    _switchOnTintColor = switchOnTintColor;
    [UISwitch appearance].onTintColor = switchOnTintColor;
}

- (void)setSwitchThumbTintColor:(UIColor *)switchThumbTintColor {
    _switchThumbTintColor = switchThumbTintColor;
    [UISwitch appearance].thumbTintColor = switchThumbTintColor;
}

#pragma mark - NavigationBar Setter

- (UINavigationBarAppearance *)navBarAppearance{
    if (!_navBarAppearance) {
        _navBarAppearance = [[UINavigationBarAppearance alloc] init];
        [_navBarAppearance configureWithDefaultBackground];
    }
    return _navBarAppearance;
}

- (void)updateNavBarAppearance{
    if (@available(iOS 13.0, *)) {
        UINavigationBar.tmui_appearanceConfigured.standardAppearance = self.navBarAppearance;
        UINavigationBar.tmui_appearanceConfigured.scrollEdgeAppearance = self.navBarAppearance;
        [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
            navigationController.navigationBar.standardAppearance = self.navBarAppearance;
            navigationController.navigationBar.scrollEdgeAppearance = self.navBarAppearance;
            [navigationController.navigationBar setNeedsLayout];
        }];
    }
}

- (void)setNavBarButtonFont:(UIFont *)navBarButtonFont {
    _navBarButtonFont = navBarButtonFont;
    // by molice 2017-08-04 只要用 appearence 的方式修改 UIBarButtonItem 的 font，就会导致界面切换时 UIBarButtonItem 抖动，系统的问题，所以暂时不修改 appearance。
    // by molice 2018-06-14 iOS 11 观察貌似又没抖动了，先试试看
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]];
    NSDictionary<NSAttributedStringKey,id> *attributes = navBarButtonFont ? @{NSFontAttributeName: navBarButtonFont} : nil;
    [barButtonItemAppearance setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [barButtonItemAppearance setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    [barButtonItemAppearance setTitleTextAttributes:attributes forState:UIControlStateDisabled];
}

- (void)setNavBarTintColor:(UIColor *)navBarTintColor {
    _navBarTintColor = navBarTintColor;
    
    if (@available(iOS 13.0, *)) {
        UIFont *font = self.navBarButtonFont;
        
        UIBarButtonItemAppearance *buttonAppearance = [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStylePlain];
        buttonAppearance.normal.titleTextAttributes = @{NSFontAttributeName: font,NSForegroundColorAttributeName:_navBarTintColor};
        
        UIBarButtonItemAppearance *doneButtonAppearance = [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStylePlain];
        doneButtonAppearance.normal.titleTextAttributes = @{NSFontAttributeName: font,NSForegroundColorAttributeName:_navBarTintColor};
        
        UIBarButtonItemAppearance *backButtonAppearance = [[UIBarButtonItemAppearance alloc] initWithStyle:UIBarButtonItemStylePlain];
        backButtonAppearance.normal.titleTextAttributes = @{NSFontAttributeName: font,NSForegroundColorAttributeName:_navBarTintColor};
        
        self.navBarAppearance.buttonAppearance = buttonAppearance;
        self.navBarAppearance.doneButtonAppearance = doneButtonAppearance;
        self.navBarAppearance.backButtonAppearance = backButtonAppearance;
        [self updateNavBarAppearance];
    }else{
        UINavigationBar.tmui_appearanceConfigured.tintColor = _navBarTintColor;
    }
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.tintColor = _navBarTintColor;
    }];
}

- (void)setNavBarBarTintColor:(UIColor *)navBarBarTintColor {
    _navBarBarTintColor = navBarBarTintColor;
    
    if (@available(iOS 13.0, *)) {
        self.navBarAppearance.backgroundColor = _navBarBarTintColor;
        [self updateNavBarAppearance];
    }else{
        UINavigationBar.tmui_appearanceConfigured.barTintColor = _navBarBarTintColor;
    }
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.barTintColor = _navBarBarTintColor;
    }];
}

- (void)setNavBarShadowImage:(UIImage *)navBarShadowImage {
    _navBarShadowImage = navBarShadowImage;
    [self configureNavBarShadowImage];
}

- (void)setNavBarShadowImageColor:(UIColor *)navBarShadowImageColor {
    _navBarShadowImageColor = navBarShadowImageColor;
    [self configureNavBarShadowImage];
}

- (void)configureNavBarShadowImage {
    UIImage *shadowImage = self.navBarShadowImage;
    if (shadowImage || self.navBarShadowImageColor) {
        if (shadowImage) {
            if (self.navBarShadowImageColor && shadowImage.renderingMode != UIImageRenderingModeAlwaysOriginal) {
                shadowImage = [shadowImage tmuihelp_imageWithTintColor:self.navBarShadowImageColor];
            }
        } else {
            shadowImage = [UIImage tmuihelp_imageWithColor:self.navBarShadowImageColor size:CGSizeMake(4, PixelOne) cornerRadius:0];
        }
        
        // 反向更新 NavBarShadowImage，以保证业务代码直接使用 NavBarShadowImage 宏能得到正确的图片
        _navBarShadowImage = shadowImage;
    }
    
    if (@available(iOS 13.0, *)) {
        self.navBarAppearance.shadowImage = shadowImage;
        [self updateNavBarAppearance];
    }else{
        UINavigationBar.tmui_appearanceConfigured.shadowImage = shadowImage;
    }
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.shadowImage = shadowImage;
    }];
}

- (void)setNavBarStyle:(UIBarStyle)navBarStyle {
    _navBarStyle = navBarStyle;
    
    if (@available(iOS 13.0, *)) {
        self.navBarAppearance.backgroundEffect = [UIBlurEffect effectWithStyle:navBarStyle == UIBarStyleDefault ? UIBlurEffectStyleSystemChromeMaterialLight : UIBlurEffectStyleSystemChromeMaterialDark];
        [self updateNavBarAppearance];
    }else{
        UINavigationBar.tmui_appearanceConfigured.barStyle = navBarStyle;
    }
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.barStyle = navBarStyle;
        [navigationController.navigationBar setNeedsLayout];
    }];
}

- (void)setNavBarBackgroundImage:(UIImage *)navBarBackgroundImage {
    _navBarBackgroundImage = navBarBackgroundImage;
    
    if (@available(iOS 13.0, *)) {
        self.navBarAppearance.backgroundImage = _navBarBackgroundImage;
        [self updateNavBarAppearance];
    }else{
        [UINavigationBar.tmui_appearanceConfigured setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        [navigationController.navigationBar setBackgroundImage:_navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }];
}

- (void)setNavBarTitleFont:(UIFont *)navBarTitleFont {
    _navBarTitleFont = navBarTitleFont;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)setNavBarTitleColor:(UIColor *)navBarTitleColor {
    _navBarTitleColor = navBarTitleColor;
    [self updateNavigationBarTitleAttributesIfNeeded];
}

- (void)updateNavigationBarTitleAttributesIfNeeded {
    NSMutableDictionary<NSAttributedStringKey, id> *titleTextAttributes = UINavigationBar.tmui_appearanceConfigured.titleTextAttributes.mutableCopy;
    if (!titleTextAttributes) {
        titleTextAttributes = [[NSMutableDictionary alloc] init];
    }
    if (self.navBarTitleFont) {
        titleTextAttributes[NSFontAttributeName] = self.navBarTitleFont;
    }
    if (self.navBarTitleColor) {
        titleTextAttributes[NSForegroundColorAttributeName] = self.navBarTitleColor;
    }
    
    if (@available(iOS 13.0, *)) {
        self.navBarAppearance.titleTextAttributes = titleTextAttributes;
        [self updateNavBarAppearance];
    }else{
        UINavigationBar.tmui_appearanceConfigured.titleTextAttributes = titleTextAttributes;
    }
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    }];
}

- (void)setNavBarLargeTitleFont:(UIFont *)navBarLargeTitleFont {
    _navBarLargeTitleFont = navBarLargeTitleFont;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)setNavBarLargeTitleColor:(UIColor *)navBarLargeTitleColor {
    _navBarLargeTitleColor = navBarLargeTitleColor;
    [self updateNavigationBarLargeTitleTextAttributesIfNeeded];
}

- (void)updateNavigationBarLargeTitleTextAttributesIfNeeded {
    if (@available(iOS 11, *)) {
        NSMutableDictionary<NSString *, id> *largeTitleTextAttributes = [[NSMutableDictionary alloc] init];
        if (self.navBarLargeTitleFont) {
            largeTitleTextAttributes[NSFontAttributeName] = self.navBarLargeTitleFont;
        }
        if (self.navBarLargeTitleColor) {
            largeTitleTextAttributes[NSForegroundColorAttributeName] = self.navBarLargeTitleColor;
        }
        
        if (@available(iOS 13.0, *)) {
            self.navBarAppearance.largeTitleTextAttributes = largeTitleTextAttributes;
            [self updateNavBarAppearance];
        }else{
            UINavigationBar.tmui_appearanceConfigured.largeTitleTextAttributes = largeTitleTextAttributes;
        }
        
        [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
            navigationController.navigationBar.largeTitleTextAttributes = largeTitleTextAttributes;
        }];
    }
}

- (void)setSizeNavBarBackIndicatorImageAutomatically:(BOOL)sizeNavBarBackIndicatorImageAutomatically {
    _sizeNavBarBackIndicatorImageAutomatically = sizeNavBarBackIndicatorImageAutomatically;
    if (sizeNavBarBackIndicatorImageAutomatically && self.navBarBackIndicatorImage && !CGSizeEqualToSize(self.navBarBackIndicatorImage.size, kUINavigationBarBackIndicatorImageSize)) {
        self.navBarBackIndicatorImage = self.navBarBackIndicatorImage;// 重新设置一次，以触发自动调整大小
    }
}

- (void)setNavBarBackIndicatorImage:(UIImage *)navBarBackIndicatorImage {
    _navBarBackIndicatorImage = navBarBackIndicatorImage;
    
    // 返回按钮的图片frame是和系统默认的返回图片的大小一致的（13, 21），所以用自定义返回箭头时要保证图片大小与系统的箭头大小一样，否则无法对齐
    // Make sure custom back button image is the same size as the system's back button image, i.e. (13, 21), due to the same frame size they share.
    if (navBarBackIndicatorImage && self.sizeNavBarBackIndicatorImageAutomatically) {
        CGSize systemBackIndicatorImageSize = kUINavigationBarBackIndicatorImageSize;
        CGSize customBackIndicatorImageSize = _navBarBackIndicatorImage.size;
        if (!CGSizeEqualToSize(customBackIndicatorImageSize, systemBackIndicatorImageSize)) {
            CGFloat imageExtensionVerticalFloat = CGFloatGetCenter(systemBackIndicatorImageSize.height, customBackIndicatorImageSize.height);
            _navBarBackIndicatorImage = [[_navBarBackIndicatorImage tmuihelp_imageWithSpacingExtensionInsets:UIEdgeInsetsMake(imageExtensionVerticalFloat,
                                                                                                                          0,
                                                                                                                          imageExtensionVerticalFloat,
                                                                                                                          systemBackIndicatorImageSize.width - customBackIndicatorImageSize.width)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];// UIImageRenderingModeAlwaysOriginal 这里要设置为原始渲染，修复iOS15，会变成蓝色图标
        }
    }
    
    if (@available(iOS 13.0, *)) {
        [self.navBarAppearance setBackIndicatorImage:_navBarBackIndicatorImage transitionMaskImage:_navBarBackIndicatorImage];
        [self updateNavBarAppearance];
    }else{
        UINavigationBar *navBarAppearance = UINavigationBar.tmui_appearanceConfigured;
        navBarAppearance.backIndicatorImage = _navBarBackIndicatorImage;
        navBarAppearance.backIndicatorTransitionMaskImage = _navBarBackIndicatorImage;
    }
    
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController,NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.navigationBar.backIndicatorImage = _navBarBackIndicatorImage;
        navigationController.navigationBar.backIndicatorTransitionMaskImage = _navBarBackIndicatorImage;
    }];

}

- (void)setNavBarBackButtonTitlePositionAdjustment:(UIOffset)navBarBackButtonTitlePositionAdjustment {
    _navBarBackButtonTitlePositionAdjustment = navBarBackButtonTitlePositionAdjustment;
    
    if (@available(iOS 13.0, *)) {
        [self.navBarAppearance setTitlePositionAdjustment:navBarBackButtonTitlePositionAdjustment];
        [self updateNavBarAppearance];
    }else{
        UIBarButtonItem *backBarButtonItem = [UIBarButtonItem appearance];
        [backBarButtonItem setBackButtonTitlePositionAdjustment:_navBarBackButtonTitlePositionAdjustment forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
        [navigationController.navigationItem.backBarButtonItem setBackButtonTitlePositionAdjustment:_navBarBackButtonTitlePositionAdjustment forBarMetrics:UIBarMetricsDefault];
    }];
}

#pragma mark - ToolBar Setter

- (void)setToolBarTintColor:(UIColor *)toolBarTintColor {
    _toolBarTintColor = toolBarTintColor;
    // tintColor 并没有声明 UI_APPEARANCE_SELECTOR，所以暂不使用 appearance 的方式去修改（虽然 appearance 方式实测是生效的）
    [self.appearanceUpdatingNavigationControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.toolbar.tintColor = _toolBarTintColor;
    }];
}

- (void)setToolBarStyle:(UIBarStyle)toolBarStyle {
    _toolBarStyle = toolBarStyle;
    UIToolbar.tmui_appearanceConfigured.barStyle = toolBarStyle;
    [self.appearanceUpdatingToolbarControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.toolbar.barStyle = toolBarStyle;
    }];
}

- (void)setToolBarBarTintColor:(UIColor *)toolBarBarTintColor {
    _toolBarBarTintColor = toolBarBarTintColor;
    UIToolbar.tmui_appearanceConfigured.barTintColor = _toolBarBarTintColor;
    [self.appearanceUpdatingToolbarControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
        navigationController.toolbar.barTintColor = _toolBarBarTintColor;
    }];
}

- (void)setToolBarBackgroundImage:(UIImage *)toolBarBackgroundImage {
    _toolBarBackgroundImage = toolBarBackgroundImage;
    [UIToolbar.tmui_appearanceConfigured setBackgroundImage:_toolBarBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.appearanceUpdatingToolbarControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
        [navigationController.toolbar setBackgroundImage:_toolBarBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }];
}

- (void)setToolBarShadowImageColor:(UIColor *)toolBarShadowImageColor {
    _toolBarShadowImageColor = toolBarShadowImageColor;
    UIImage *shadowImage = toolBarShadowImageColor ? [UIImage tmuihelp_imageWithColor:_toolBarShadowImageColor size:CGSizeMake(1, PixelOne) cornerRadius:0] : nil;
    [UIToolbar.tmui_appearanceConfigured setShadowImage:shadowImage forToolbarPosition:UIBarPositionAny];
    [self.appearanceUpdatingToolbarControllers enumerateObjectsUsingBlock:^(UINavigationController * _Nonnull navigationController, NSUInteger idx, BOOL * _Nonnull stop) {
        [navigationController.toolbar setShadowImage:shadowImage forToolbarPosition:UIBarPositionAny];
    }];
}

#pragma mark - TabBar Setter

- (UITabBarAppearance *)tabBarAppearance {
    if (!_tabBarAppearance) {
        _tabBarAppearance = [[UITabBarAppearance alloc] init];
        [_tabBarAppearance configureWithDefaultBackground];
    }
    return _tabBarAppearance;
}

- (void)updateTabBarAppearance {
    if (@available(iOS 13.0, *)) {
        UITabBar.tmui_appearanceConfigured.standardAppearance = self.tabBarAppearance;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.standardAppearance = self.tabBarAppearance;
            [tabBarController.tabBar setNeedsLayout];
        }];
    }
}

- (void)setTabBarBarTintColor:(UIColor *)tabBarBarTintColor {
    _tabBarBarTintColor = tabBarBarTintColor;
    
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.backgroundColor = tabBarBarTintColor;
        [self updateTabBarAppearance];
    } else {
        UITabBar.tmui_appearanceConfigured.barTintColor = _tabBarBarTintColor;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.barTintColor = _tabBarBarTintColor;
        }];
    }
}

- (void)setTabBarStyle:(UIBarStyle)tabBarStyle {
    _tabBarStyle = tabBarStyle;
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.backgroundEffect = [UIBlurEffect effectWithStyle:tabBarStyle == UIBarStyleDefault ? UIBlurEffectStyleSystemChromeMaterialLight : UIBlurEffectStyleSystemChromeMaterialDark];
        [self updateTabBarAppearance];
    } else {
        UITabBar.tmui_appearanceConfigured.barStyle = tabBarStyle;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.barStyle = tabBarStyle;
        }];
    }
}

- (void)setTabBarBackgroundImage:(UIImage *)tabBarBackgroundImage {
    _tabBarBackgroundImage = tabBarBackgroundImage;
    
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.backgroundImage = tabBarBackgroundImage;
        [self updateTabBarAppearance];
    } else {
        UITabBar.tmui_appearanceConfigured.backgroundImage = tabBarBackgroundImage;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.backgroundImage = tabBarBackgroundImage;
        }];
    }
}

- (void)setTabBarShadowImageColor:(UIColor *)tabBarShadowImageColor {
    _tabBarShadowImageColor = tabBarShadowImageColor;
    
    if (@available(iOS 13.0, *)) {
        self.tabBarAppearance.shadowColor = tabBarShadowImageColor;
        [self updateTabBarAppearance];
    } else {
        UIImage *shadowImage = [UIImage tmuihelp_imageWithColor:_tabBarShadowImageColor size:CGSizeMake(1, PixelOne) cornerRadius:0];
        [UITabBar.tmui_appearanceConfigured setShadowImage:shadowImage];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.shadowImage = shadowImage;
        }];
    }
}

- (void)setTabBarItemTitleFont:(UIFont *)tabBarItemTitleFont {
    _tabBarItemTitleFont = tabBarItemTitleFont;
    
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance tmui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
            attributes[NSFontAttributeName] = tabBarItemTitleFont;
            itemAppearance.normal.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[UITabBarItem.tmui_appearanceConfigured titleTextAttributesForState:UIControlStateNormal]];
        if (_tabBarItemTitleFont) {
            textAttributes[NSFontAttributeName] = _tabBarItemTitleFont;
        }
        [UITabBarItem.tmui_appearanceConfigured setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
            }];
        }];
    }
}

- (void)setTabBarItemTitleFontSelected:(UIFont *)tabBarItemTitleFontSelected {
    _tabBarItemTitleFontSelected = tabBarItemTitleFontSelected;
    
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance tmui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.selected.titleTextAttributes.mutableCopy;
            attributes[NSFontAttributeName] = tabBarItemTitleFontSelected;
            itemAppearance.selected.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[UITabBarItem.tmui_appearanceConfigured titleTextAttributesForState:UIControlStateSelected]];
        if (tabBarItemTitleFontSelected) {
            textAttributes[NSFontAttributeName] = tabBarItemTitleFontSelected;
        }
        [UITabBarItem.tmui_appearanceConfigured setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
            }];
        }];
    }
}

- (void)setTabBarItemTitleColor:(UIColor *)tabBarItemTitleColor {
    _tabBarItemTitleColor = tabBarItemTitleColor;
    
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance tmui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
            attributes[NSForegroundColorAttributeName] = tabBarItemTitleColor;
            itemAppearance.normal.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[UITabBarItem.tmui_appearanceConfigured titleTextAttributesForState:UIControlStateNormal]];
        textAttributes[NSForegroundColorAttributeName] = _tabBarItemTitleColor;
        [UITabBarItem.tmui_appearanceConfigured setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
            }];
        }];
    }
}

- (void)setTabBarItemTitleColorSelected:(UIColor *)tabBarItemTitleColorSelected {
    _tabBarItemTitleColorSelected = tabBarItemTitleColorSelected;

    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance tmui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.selected.titleTextAttributes.mutableCopy;
            attributes[NSForegroundColorAttributeName] = tabBarItemTitleColorSelected;
            itemAppearance.selected.titleTextAttributes = attributes.copy;
        }];
        [self updateTabBarAppearance];
    } else {
        NSMutableDictionary<NSString *, id> *textAttributes = [[NSMutableDictionary alloc] initWithDictionary:[UITabBarItem.tmui_appearanceConfigured titleTextAttributesForState:UIControlStateSelected]];
        textAttributes[NSForegroundColorAttributeName] = _tabBarItemTitleColorSelected;
        [UITabBarItem.tmui_appearanceConfigured setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            [tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
            }];
        }];
    }
}

- (void)setTabBarItemImageColor:(UIColor *)tabBarItemImageColor {
    _tabBarItemImageColor = tabBarItemImageColor;
    
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance tmui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            itemAppearance.normal.iconColor = tabBarItemImageColor;
        }];
        [self updateTabBarAppearance];
    } else {
        UITabBar.tmui_appearanceConfigured.unselectedItemTintColor = tabBarItemImageColor;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.unselectedItemTintColor = tabBarItemImageColor;
        }];
    }
}

- (void)setTabBarItemImageColorSelected:(UIColor *)tabBarItemImageColorSelected {
    _tabBarItemImageColorSelected = tabBarItemImageColorSelected;
    
    if (@available(iOS 13.0, *)) {
        [self.tabBarAppearance tmui_applyItemAppearanceWithBlock:^(UITabBarItemAppearance * _Nonnull itemAppearance) {
            itemAppearance.selected.iconColor = tabBarItemImageColorSelected;
        }];
        [self updateTabBarAppearance];
    } else {
        // iOS 12 及以下使用 tintColor 实现，但 tintColor 并没有声明 UI_APPEARANCE_SELECTOR，所以暂不使用 appearance 的方式去修改（虽然 appearance 方式实测是生效的）
//        UITabBar.tmui_appearanceConfigured.tintColor = tabBarItemImageColorSelected;
        [self.appearanceUpdatingTabBarControllers enumerateObjectsUsingBlock:^(UITabBarController * _Nonnull tabBarController, NSUInteger idx, BOOL * _Nonnull stop) {
            tabBarController.tabBar.tintColor = tabBarItemImageColorSelected;
        }];
    }
}

- (void)setStatusbarStyleLightInitially:(BOOL)statusbarStyleLightInitially {
    _statusbarStyleLightInitially = statusbarStyleLightInitially;
    [TMUIHelper.topViewController setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Appearance Updating Views

// 解决某些场景下更新配置表无法覆盖样式的问题 https://github.com/Tencent/TMUI_iOS/issues/700

- (NSArray <UITabBarController *>*)appearanceUpdatingTabBarControllers {
    NSArray<Class<UIAppearanceContainer>> *classes = nil;
    if (self.tabBarContainerClasses.count > 0) {
        classes = self.tabBarContainerClasses;
    } else {
        classes = @[UITabBarController.class];
    }
    // tabBarContainerClasses 里可能会设置非 UITabBarController 的 class，由于这里只需要关注 UITabBarController 的，所以做一次过滤
    classes = [classes tmuihelp_filter:^BOOL(Class<UIAppearanceContainer>  _Nonnull item) {
        return [item.class isSubclassOfClass:UITabBarController.class];
    }];
    return (NSArray <UITabBarController *>*)[self appearanceUpdatingViewControllersOfClasses:classes];
}

- (NSArray <UINavigationController *>*)appearanceUpdatingNavigationControllers {
    NSArray<Class<UIAppearanceContainer>> *classes = nil;
    if (self.navBarContainerClasses.count > 0) {
        classes = self.navBarContainerClasses;
    } else {
        classes = @[UINavigationController.class];
    }
    // navBarContainerClasses 里可能会设置非 UINavigationController 的 class，由于这里只需要关注 UINavigationController 的，所以做一次过滤
    classes = [classes tmuihelp_filter:^BOOL(Class<UIAppearanceContainer>  _Nonnull item) {
        return [item.class isSubclassOfClass:UINavigationController.class];
    }];
    return (NSArray <UINavigationController *>*)[self appearanceUpdatingViewControllersOfClasses:classes];
}

- (NSArray <UINavigationController *>*)appearanceUpdatingToolbarControllers {
    NSArray<Class<UIAppearanceContainer>> *classes = nil;
    if (self.toolBarContainerClasses.count > 0) {
        classes = self.toolBarContainerClasses;
    } else {
        classes = @[UINavigationController.class];
    }
    // toolBarContainerClasses 里可能会设置非 UINavigationController 的 class，由于这里只需要关注 UINavigationController 的，所以做一次过滤
    classes = [classes tmuihelp_filter:^BOOL(Class<UIAppearanceContainer>  _Nonnull item) {
        return [item.class isSubclassOfClass:UINavigationController.class];
    }];
    return (NSArray <UINavigationController *>*)[self appearanceUpdatingViewControllersOfClasses:classes];
}

- (NSArray <UIViewController *>*)appearanceUpdatingViewControllersOfClasses:(NSArray<Class<UIAppearanceContainer>> *)classes {
    if (!classes.count) return nil;
    NSMutableArray *viewControllers = [NSMutableArray array];
    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (window.rootViewController) {
            [viewControllers addObjectsFromArray:[window.rootViewController tmui_existingViewControllersOfClasses:classes]];
        }
    }];
    return viewControllers;
}

@end

@implementation UINavigationBar (TMUIConfiguration)

+ (instancetype)tmui_appearanceConfigured {
    if (TMUICMIActivated && NavBarContainerClasses) {
        return [self appearanceWhenContainedInInstancesOfClasses:NavBarContainerClasses];
    }
    return [self appearance];
}

@end

@implementation UITabBar (TMUIConfiguration)

+ (instancetype)tmui_appearanceConfigured {
    if (TMUICMIActivated && TabBarContainerClasses) {
        return [self appearanceWhenContainedInInstancesOfClasses:TabBarContainerClasses];
    }
    return [self appearance];
}

@end

@implementation UIToolbar (TMUIConfiguration)

+ (instancetype)tmui_appearanceConfigured {
    if (TMUICMIActivated && ToolBarContainerClasses) {
        return [self appearanceWhenContainedInInstancesOfClasses:ToolBarContainerClasses];
    }
    return [self appearance];
}

@end

@implementation UITabBarItem (TMUIConfiguration)

+ (instancetype)tmui_appearanceConfigured {
    if (TMUICMIActivated && TabBarContainerClasses) {
        return [self appearanceWhenContainedInInstancesOfClasses:TabBarContainerClasses];
    }
    return [self appearance];
}

@end
