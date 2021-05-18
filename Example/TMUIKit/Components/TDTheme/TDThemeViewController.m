//
//  TDThemeViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/4/8.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDThemeViewController.h"
#import "TMUIConfigurationTemplate.h"
#import "TMUIConfigurationTemplateGrapefruit.h"
#import "TMUIConfigurationTemplateGrass.h"
#import "TMUIConfigurationTemplatePinkRose.h"
#import "TMUIConfigurationTemplateDark.h"
#import "TDThemeExampleView.h"
#import "TMUIFloatLayoutView.h"
#import "TDThemeManager.h"
#import "TDTestViewController.h"
@interface TDThemeButton : TMUIButton
- (instancetype)initWithFillColor:(UIColor *)fillColor titleTextColor:(UIColor *)textColor;
- (instancetype)initWithFillColor:(UIColor *)fillColor titleTextColor:(UIColor *)textColor frame:(CGRect)frame;

@property(nonatomic, strong) UIColor *themeColor;
@property(nonatomic, copy) NSString *themeName;
@end



@interface TDThemeViewController ()

@property(nonatomic, strong) NSArray<Class> *classes;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) TMUIFloatLayoutView *buttonContainers;
@property(nonatomic, strong) NSMutableArray<TDThemeButton *> *themeButtons;
@property(nonatomic, strong) UISwitch *respondsSystemStyleSwitch;
@property(nonatomic, strong) UILabel *respondsSystemStyleLabel;
@property(nonatomic, strong) CALayer *separatorLayer;
@property(nonatomic, strong) TDThemeExampleView *exampleView;
//@property(nonatomic, strong) TMUIKeyboardManager *keyboardManager;
@end

@implementation TDThemeViewController

- (void)test{
    [self.navigationController pushViewController:TDTestViewController.new animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithTitle:@"TEST" titleColorStyle:UIBarButtonItem_TMUIColorStyleWhite target:self action:@selector(test)];
    
    self.classes = @[
                     TMUIConfigurationTemplate.class,
                     TMUIConfigurationTemplateGrapefruit.class,
                     TMUIConfigurationTemplateGrass.class,
                     TMUIConfigurationTemplatePinkRose.class,
                     TMUIConfigurationTemplateDark.class];
    [self.classes enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL hasInstance = NO;
        for (NSObject<TDThemeProtocol> *theme in TMUIThemeManagerCenter.defaultThemeManager.themes) {
            if ([theme isMemberOfClass:class]) {
                hasInstance = YES;
                break;
            }
        }
        if (!hasInstance) {
            NSObject<TDThemeProtocol> *theme = [class new];
            [TMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:theme.themeName theme:theme];
        }
    }];
    
    self.themeButtons = [[NSMutableArray alloc] init];
    
//    self.keyboardManager = [[TMUIKeyboardManager alloc] initWithDelegate:self];
    [self initSubviews];
}

- (void)initSubviews {
//    [super initSubviews];
    self.view.tag = 999;
    
    UIColor *bgColor = self.view.backgroundColor;
    NSLog(@"%@",bgColor);
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.buttonContainers = [[TMUIFloatLayoutView alloc] init];
    [self.scrollView addSubview:self.buttonContainers];
    
    [self.classes enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSObject<TDThemeProtocol> *theme in TMUIThemeManagerCenter.defaultThemeManager.themes) {
            if ([NSStringFromClass(theme.class) isEqualToString:NSStringFromClass(class)]) {
                NSString *identifier = [TMUIThemeManagerCenter.defaultThemeManager identifierForTheme:theme];
                BOOL isCurrentTheme = [TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:identifier];
                TDThemeButton *themeButton = [[TDThemeButton alloc] initWithFillColor:[theme.themeName isEqualToString:TDThemeIdentifierDark] ? UIColorBlack : theme.themeTintColor titleTextColor:UIColorWhite];
                themeButton.cornerRadius = 4;
                themeButton.titleLabel.font = UIFontMake(12);
                [themeButton setTitle:theme.themeName forState:UIControlStateNormal];
//                themeButton.tmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
                themeButton.selected = isCurrentTheme;
                [themeButton addTarget:self action:@selector(handleThemeButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
                [self.buttonContainers addSubview:themeButton];
                [self.themeButtons addObject:themeButton];
                break;
            }
        }
    }];
    
    self.respondsSystemStyleSwitch = [[UISwitch alloc] init];
    if (@available(iOS 13.0, *)) {
        self.respondsSystemStyleSwitch.on = TMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically;
        [self.respondsSystemStyleSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
    } else {
        self.respondsSystemStyleSwitch.enabled = NO;
    }
    [self.scrollView addSubview:self.respondsSystemStyleSwitch];
    
    self.respondsSystemStyleLabel = [[UILabel alloc] tmui_initWithFont:UIFontMake(14) textColor:UIColor.td_mainTextColor];
    self.respondsSystemStyleLabel.tag = 999;
    self.respondsSystemStyleLabel.text = @"自动响应 iOS 13 系统样式(Dark Mode)";
    [self.respondsSystemStyleLabel sizeToFit];
    [self.scrollView addSubview:self.respondsSystemStyleLabel];
    
    self.separatorLayer = [CALayer layer];
    self.separatorLayer.backgroundColor = UIColor.td_tintColor.CGColor;
    [self.scrollView.layer addSublayer:self.separatorLayer];
    
    self.exampleView = [[TDThemeExampleView alloc] init];
    [self.scrollView addSubview:self.exampleView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    UIEdgeInsets paddings = UIEdgeInsetsMake(24, 24 + self.scrollView.tmui_safeAreaInsets.left, 24 + self.scrollView.tmui_safeAreaInsets.bottom, 24 + self.scrollView.tmui_safeAreaInsets.right);
    self.buttonContainers.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
    // 窄屏幕一行两个，宽屏幕单行展示完整
    CGFloat buttonWidth = CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(paddings);
    if (buttonWidth > [TMUIHelper screenSizeFor65Inch].width) {
        buttonWidth = ((buttonWidth + self.buttonContainers.itemMargins.right) / self.buttonContainers.subviews.count) - self.buttonContainers.itemMargins.right;
    } else {
        buttonWidth = (buttonWidth - self.buttonContainers.itemMargins.right) / 2;
    }
    buttonWidth = floor(buttonWidth);
    [self.themeButtons enumerateObjectsUsingBlock:^(TDThemeButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.frame = CGRectSetSize(button.frame, CGSizeMake(buttonWidth, 32));
    }];
    self.buttonContainers.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), TMUIViewSelfSizingHeight);
    
    self.respondsSystemStyleSwitch.tmui_left = self.buttonContainers.tmui_left;
    self.respondsSystemStyleSwitch.tmui_top = self.buttonContainers.tmui_bottom + 18;
    self.respondsSystemStyleLabel.tmui_left = self.respondsSystemStyleSwitch.tmui_right + 12;
    self.respondsSystemStyleLabel.tmui_top = self.respondsSystemStyleSwitch.tmui_top + CGFloatGetCenter(self.respondsSystemStyleSwitch.tmui_height, self.respondsSystemStyleLabel.tmui_height);
    
    self.separatorLayer.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.respondsSystemStyleSwitch.frame) + 18, CGRectGetWidth(self.scrollView.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), PixelOne);
    
    self.exampleView.frame = CGRectMake(paddings.left, CGRectGetMaxY(self.separatorLayer.frame) + 24, CGRectGetWidth(self.separatorLayer.frame), TMUIViewSelfSizingHeight);
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.exampleView.frame) + paddings.bottom);
}

- (void)handleSwitchEvent:(UISwitch *)switchControl {
    if (@available(iOS 13.0, *)) {
        TMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically = switchControl.on;
    }
}

- (void)handleThemeButtonEvent:(TDThemeButton *)themeButton {
    TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier = themeButton.currentTitle;
}

- (void)tmui_themeDidChangeByManager:(TMUIThemeManager *)manager identifier:(NSString *)identifier theme:(__kindof NSObject *)theme {
    [super tmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self.themeButtons enumerateObjectsUsingBlock:^(TDThemeButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.selected = [button.currentTitle isEqualToString:identifier];
    }];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    return YES;
}

#pragma mark - <TMUIKeyboardManagerDelegate>

//- (void)keyboardWillChangeFrameWithUserInfo:(TMUIKeyboardUserInfo *)keyboardUserInfo {
//    CGFloat marginToKeyboard = 16;
//    UIView *view = (UIView *)keyboardUserInfo.targetResponder;
//    CGRect rectInView = [view convertRect:view.bounds toView:self.view];
//    CGFloat keyboardHeight = [keyboardUserInfo heightInView:self.view];
//    if (keyboardHeight <= 0) {
//        // hide
//        if (self.scrollView.contentOffset.y + CGRectGetHeight(self.scrollView.bounds) > self.scrollView.contentSize.height) {
//            [UIView animateWithDuration:keyboardUserInfo.animationDuration delay:0 options:keyboardUserInfo.animationOptions animations:^{
//                [self.scrollView tmui_scrollToBottom];
//            } completion:nil];
//        }
//    } else {
//        // show
//        CGFloat delta = CGRectGetHeight(self.view.bounds) - keyboardHeight - marginToKeyboard - CGRectGetMaxY(rectInView);
//        if (delta < 0) {
//            [UIView animateWithDuration:keyboardUserInfo.animationDuration delay:0 options:keyboardUserInfo.animationOptions animations:^{
//                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - delta)];
//            } completion:nil];
//        }
//    }
//
//    self.scrollView.contentInset = UIEdgeInsetsSetBottom(self.scrollView.contentInset, keyboardHeight);
//    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
//}

@end

@implementation TDThemeButton

- (instancetype)initWithFillColor:(UIColor *)fillColor titleTextColor:(UIColor *)textColor {
    return [self initWithFillColor:fillColor titleTextColor:textColor frame:CGRectZero];
}

- (instancetype)initWithFillColor:(UIColor *)fillColor titleTextColor:(UIColor *)textColor frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = fillColor;
        [self setTitleColor:textColor forState:UIControlStateNormal];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    if (selected) {
//        self.backgroundColor = self.fillColor;
//        self.layer.borderWidth = 0;
//        [self setTitleColor:UIColorWhite forState:UIControlStateNormal];
//        self.titleLabel.font = UIFontBoldMake(self.titleLabel.font.pointSize);
//    } else {
//        self.backgroundColor = nil;
//        self.layer.borderColor = self.fillColor.CGColor;
//        self.layer.borderWidth = 1;
//        [self setTitleColor:self.fillColor forState:UIControlStateNormal];
//        self.titleLabel.font = UIFontMake(self.titleLabel.font.pointSize);
//    }
//    
//    if ([self.currentTitle isEqualToString:TDThemeIdentifierDark] && selected) {
//        self.backgroundColor = [UIColorWhite colorWithAlphaComponent:.7];
//    }
//}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.frame.size;
}


@end
