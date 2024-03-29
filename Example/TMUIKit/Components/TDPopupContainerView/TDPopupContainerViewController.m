//
//  TDPopupContainerViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/4/24.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDPopupContainerViewController.h"


@interface TDPopupContainerView : TMUIPopupContainerView

//@property(nonatomic, strong) TMUIEmotionInputManager *emotionInputManager;
@end

@implementation TDPopupContainerView

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.contentEdgeInsets = UIEdgeInsetsZero;
//        self.emotionInputManager = [[TMUIEmotionInputManager alloc] init];
//        self.emotionInputManager.emotionView.emotions = [TDUIHelper tmuiEmotions];
//        self.emotionInputManager.emotionView.sendButton.hidden = YES;
//        [self.contentView addSubview:self.emotionInputManager.emotionView];
//    }
//    return self;
//}

- (CGSize)sizeThatFitsInContentView:(CGSize)size {
    return CGSizeMake(300, 232);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 所有布局都参照 contentView
//    self.emotionInputManager.emotionView.frame = self.contentView.bounds;
}

@end

@interface TDPopupContainerViewController ()

@property(nonatomic, strong) TMUIButton *button1;
@property(nonatomic, strong) TMUIPopupContainerView *popupByAddSubview;
@property(nonatomic, strong) TMUIButton *button2;
@property(nonatomic, strong) TMUIButton *button3;
@property(nonatomic, strong) TMUIPopupContainerView *popupHorizontal;
@property(nonatomic, strong) TMUIButton *button4;
@property(nonatomic, strong) TMUIPopupMenuView *popupByWindow;
@property(nonatomic, strong) TMUIButton *button5;
@property(nonatomic, strong) TDPopupContainerView *popupWithCustomView;
@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) TMUIPopupMenuView *popupAtBarButtonItem;
@end

@implementation TDPopupContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    
    self.separatorLayer1 = [CALayer layer];
    [self.separatorLayer1 tmui_removeDefaultAnimations];
    self.separatorLayer1.backgroundColor = UIColorSeparator.CGColor;
    [self.view.layer addSublayer:self.separatorLayer1];
    
    self.separatorLayer2 = [CALayer layer];
    [self.separatorLayer2 tmui_removeDefaultAnimations];
    self.separatorLayer2.backgroundColor = UIColorSeparator.CGColor;
    [self.view.layer addSublayer:self.separatorLayer2];
    
    self.button1 = [TDUIHelper generateLightBorderedButton];
    [self.button1 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button1];
    
    self.button2 = [TDUIHelper generateLightBorderedButton];
    [self.button2 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setImage:TableViewCellDisclosureIndicatorImage forState:UIControlStateNormal];
    [self.button2 setTitle:@"右边" forState:UIControlStateNormal];
    self.button2.imagePosition = TMUIButtonImagePositionRight;
    self.button2.spacingBetweenImageAndTitle = 4;
    [self.view addSubview:self.button2];
    
    self.button3 = [TDUIHelper generateLightBorderedButton];
    [self.button3 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 setImage:[TableViewCellDisclosureIndicatorImage tmui_imageWithOrientation:UIImageOrientationRightMirrored] forState:UIControlStateNormal];
    [self.button3 setTitle:@"左边" forState:UIControlStateNormal];
    self.button3.imagePosition = TMUIButtonImagePositionLeft;
    self.button3.spacingBetweenImageAndTitle = 4;
    [self.view addSubview:self.button3];
    
    self.button4 = [TDUIHelper generateLightBorderedButton];
    [self.button4 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button4 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button4];
    
    self.button5 = [TDUIHelper generateLightBorderedButton];
    [self.button5 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button5 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
    [self.view addSubview:self.button5];
    
    
    
    
    
    // 使用方法 1，以 addSubview: 的形式显示到界面上
    self.popupByAddSubview = [[TMUIPopupContainerView alloc] init];
    self.popupByAddSubview.imageView.image = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<TDThemeProtocol> * _Nullable theme) {
        return [[UIImageMake(@"icon_emotion") tmui_imageResizedInLimitedSize:CGSizeMake(24, 24) resizingMode:TMUIImageResizingModeScaleToFill] tmui_imageWithTintColor:theme.themeTintColor];
    }];
    self.popupByAddSubview.textLabel.text = @"默认自带 imageView、textLabel，可展示简单的内容";
    self.popupByAddSubview.textLabel.textColor = UIColor.td_mainTextColor;
    self.popupByAddSubview.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.popupByAddSubview.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
    };
    self.popupByAddSubview.sourceView = self.button1;// 相对于 button1 布局
    // 使用方法 1 时，显示浮层前需要先手动隐藏浮层，并自行添加到目标 UIView 上
    self.popupByAddSubview.hidden = YES;
    [self.view addSubview:self.popupByAddSubview];
    
    self.popupHorizontal = [[TMUIPopupContainerView alloc] init];
    self.popupHorizontal.imageView.image = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<TDThemeProtocol> * _Nullable theme) {
        return [[UIImageMake(@"icon_emotion") tmui_imageResizedInLimitedSize:CGSizeMake(24, 24) resizingMode:TMUIImageResizingModeScaleToFill] tmui_imageWithTintColor:theme.themeTintColor];
    }];
    self.popupHorizontal.textLabel.text = @"可通过 contentMode 调整内容的布局。\n这样在文字比较长的时候就能看到区别。\n不够长再换几次行。\n不够长再换几次行。\n不够长再换几次行。";
    self.popupHorizontal.textLabel.textColor = UIColor.td_mainTextColor;
    self.popupHorizontal.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    self.popupHorizontal.hidden = YES;
    [self.view addSubview:self.popupHorizontal];
    
    
    // 使用方法 2，以 UIWindow 的形式显示到界面上，这种无需默认隐藏，也无需 add 到某个 UIView 上
    self.popupByWindow = [[TMUIPopupMenuView alloc] init];
    self.popupByWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupByWindow.tintColor = UIColor.td_tintColor;
    self.popupByWindow.maskViewBackgroundColor = [UIColor.td_tintColor colorWithAlphaComponent:.15];// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
    self.popupByWindow.shouldShowItemSeparator = YES;
    self.popupByWindow.itemConfigurationHandler = ^(TMUIPopupMenuView *aMenuView, TMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
        // 利用 itemConfigurationHandler 批量设置所有 item 的样式
        aItem.button.highlightedBackgroundColor = [UIColor.td_tintColor colorWithAlphaComponent:.2];
    };
    self.popupByWindow.items = @[[TMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"TMUIKit" handler:^(TMUIPopupMenuButtonItem *aItem) {
        [aItem.menuView hideWithAnimated:YES];
    }],
                                 [TMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Components" handler:^(TMUIPopupMenuButtonItem *aItem) {
                                     [aItem.menuView hideWithAnimated:YES];
                                 }],
                                 [TMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Lab" handler:^(TMUIPopupMenuButtonItem *aItem) {
                                     [aItem.menuView hideWithAnimated:YES];
                                 }]];
    self.popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button4 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
    };
    self.popupByWindow.sourceView = self.button4;// 相对于 button4 布局

    
    self.popupWithCustomView = [[TDPopupContainerView alloc] init];
    self.popupWithCustomView.preferLayoutDirection = TMUIPopupContainerViewLayoutDirectionBelow;// 默认在目标的下方，如果目标下方空间不够，会尝试放到目标上方。若上方空间也不够，则缩小自身的高度。
    self.popupWithCustomView.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button5 setTitle:@"显示自定义浮层" forState:UIControlStateNormal];
    };
    
    // 在 UIBarButtonItem 上显示
    self.popupAtBarButtonItem = [[TMUIPopupMenuView alloc] init];
    self.popupAtBarButtonItem.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupAtBarButtonItem.contentView.userInteractionEnabled = YES;
    self.popupAtBarButtonItem.maximumWidth = 180;
    self.popupAtBarButtonItem.shouldShowItemSeparator = YES;
    self.popupAtBarButtonItem.tintColor = UIColor.td_tintColor;
    self.popupAtBarButtonItem.items = @[[TMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"TMUIKit" handler:^(TMUIPopupMenuButtonItem * _Nonnull aItem) {
        [aItem.menuView hideWithAnimated:YES];
    }],
                              [TMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Components" handler:^(TMUIPopupMenuButtonItem * _Nonnull aItem) {
                                  [aItem.menuView hideWithAnimated:YES];
                              }],
                              [TMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Lab" handler:^(TMUIPopupMenuButtonItem * _Nonnull aItem) {
                                  [aItem.menuView hideWithAnimated:YES];
                              }]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleRightBarButtonItemEvent)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // popupView3 使用方法 2 显示，并且没有打开 automaticallyHidesWhenUserTap，则需要手动隐藏
    if (self.popupWithCustomView.isShowing) {
        [self.popupWithCustomView hideWithAnimated:animated];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat minY = tmui_navigationBarHeight();
    CGFloat viewportHeight = CGRectGetHeight(self.view.bounds) - minY;
    CGFloat sectionHeight = viewportHeight / 3.0;
    
    CGFloat buttonMargin = 8;
    CGFloat sectionContentHeight = CGRectGetHeight(self.button1.frame) * 2 + buttonMargin;
    self.button1.frame = CGRectSetXY(self.button1.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.button1.frame)), minY + CGFloatGetCenter(sectionHeight, sectionContentHeight));
    self.button2.frame = CGRectMake(CGRectGetMinX(self.button1.frame), CGRectGetMaxY(self.button1.frame) + buttonMargin, (CGRectGetWidth(self.button1.frame) - buttonMargin) / 2, CGRectGetHeight(self.button2.frame));
    self.button3.frame = CGRectSetX(self.button2.frame, CGRectGetMaxX(self.button2.frame) + buttonMargin);
    
    self.separatorLayer1.frame = CGRectFlatMake(0, minY + sectionHeight, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.button4.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.button1.frame) + sectionHeight - CGRectGetHeight(self.button4.frame));
    
    self.separatorLayer2.frame = CGRectSetY(self.separatorLayer1.frame, minY + sectionHeight * 2.0);
    
    self.button5.frame = CGRectSetY(self.button1.frame, CGRectGetMaxY(self.button4.frame) + sectionHeight - CGRectGetHeight(self.button5.frame));
    self.popupWithCustomView.sourceRect = [self.button5 convertRect:self.button5.bounds toView:nil];// 将 button3 的坐标转换到相对于 UIWindow 的坐标系里，然后再传给浮层布局
}

- (void)handleButtonEvent:(TMUIButton *)button {
    if (button == self.button1) {
        if (self.popupByAddSubview.isShowing) {
            [self.popupByAddSubview hideWithAnimated:YES];
            [self.button1 setTitle:@"显示默认浮层" forState:UIControlStateNormal];
        } else {
            [self.popupByAddSubview showWithAnimated:YES];
            [self.button1 setTitle:@"隐藏默认浮层" forState:UIControlStateNormal];
        }
        return;
    }
    
    if (button == self.button2) {
        if (self.popupHorizontal.isShowing) {
            [self.popupHorizontal hideWithAnimated:YES];
        } else {
            self.popupHorizontal.sourceView = button;
            self.popupHorizontal.preferLayoutDirection = TMUIPopupContainerViewLayoutDirectionRight;
            self.popupHorizontal.contentMode = UIViewContentModeTop;
            [self.popupHorizontal showWithAnimated:YES];
        }
        return;
    }
    
    if (button == self.button3) {
        if (self.popupHorizontal.isShowing) {
            [self.popupHorizontal hideWithAnimated:YES];
        } else {
            self.popupHorizontal.sourceView = button;
            self.popupHorizontal.preferLayoutDirection = TMUIPopupContainerViewLayoutDirectionLeft;
            self.popupHorizontal.contentMode = UIViewContentModeBottom;
            [self.popupHorizontal showWithAnimated:YES];
        }
        return;
    }
    
    if (button == self.button4) {
        [self.popupByWindow showWithAnimated:YES];
        [self.button4 setTitle:@"隐藏菜单浮层" forState:UIControlStateNormal];
        return;
    }
    
    if (button == self.button5) {
        if (self.popupWithCustomView.isShowing) {
            [self.popupWithCustomView hideWithAnimated:YES];
        } else {
            [self.popupWithCustomView showWithAnimated:YES];
            [self.button5 setTitle:@"隐藏自定义浮层" forState:UIControlStateNormal];
        }
        return;
    }
}

- (void)handleRightBarButtonItemEvent {
    if (self.popupAtBarButtonItem.isShowing) {
        [self.popupAtBarButtonItem hideWithAnimated:YES];
    } else {
        // 相对于右上角的按钮布局
        self.popupAtBarButtonItem.sourceBarItem = self.navigationItem.rightBarButtonItem;
        [self.popupAtBarButtonItem showWithAnimated:YES];
    }
}

@end
