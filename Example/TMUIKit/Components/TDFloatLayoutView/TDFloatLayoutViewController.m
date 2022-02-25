//
//  TDFloatLayoutViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/1/20.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDFloatLayoutViewController.h"

@interface TDFloatLayoutViewController ()
@property(nonatomic, strong) TMUIFloatLayoutView *floatLayoutView;
@property(nonatomic, strong) TMUIFloatLayoutView *floatLayoutView2;
@end

@implementation TDFloatLayoutViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self addView1];
    
    [self addView2];
}

- (void)addView1{
    self.floatLayoutView = [[TMUIFloatLayoutView alloc] init];
    self.floatLayoutView.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    self.floatLayoutView.itemMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
    self.floatLayoutView.layer.borderWidth = PixelOne;
    self.floatLayoutView.layer.borderColor = UIColorSeparator.CGColor;
    [self.view addSubview:self.floatLayoutView];
    
    NSArray<NSString *> *suggestions = @[@"东野圭吾", @"三体", @"爱", @"红楼梦", @"理智与情感", @"读书热榜", @"免费榜"];
    for (NSInteger i = 0; i < suggestions.count; i++) {
        TMUIButton *button = [self generateGhostButtonWithColor:UIColor.td_tintColor];
        [button setTitle:suggestions[i] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(14);
        button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
        [self.floatLayoutView addSubview:button];
    }
}

- (void)addView2{
    self.floatLayoutView2 = [[TMUIFloatLayoutView alloc] init];
    self.floatLayoutView2.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    self.floatLayoutView2.itemMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.floatLayoutView2.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
    self.floatLayoutView2.layer.borderWidth = PixelOne;
    self.floatLayoutView2.layer.borderColor = UIColorSeparator.CGColor;
    [self.view addSubview:self.floatLayoutView2];
    
    NSArray<NSString *> *suggestions = @[@"东野圭吾", @"三体", @"爱", @"红楼梦", @"理智与情感", @"读书热榜", @"免费榜"];
    NSArray<NSString *> *suggestionIcons = @[@"hat", @"moose", @"", @"", @"icon_emotion", @"eren", @"icon_moreOperation_shareChat"];
    for (NSInteger i = 0; i < suggestions.count; i++) {
        TMUIButton *button = [self generateGhostButtonWithColor:UIColor.td_tintColor];
        [button setTitle:suggestions[i] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(14);
        button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
        button.spacingBetweenImageAndTitle = 10;
        NSString *icon = suggestionIcons[i];
        if (tmui_isNullString(icon) == false) {
            button.tmui_image = [UIImageMake(icon) tmui_imageResizedInLimitedSize:CGSizeMake(17, 17) resizingMode:TMUIImageResizingModeScaleAspectFit];
        }
        [self.floatLayoutView2 addSubview:button];
    }
}

- (TMUIButton *)generateGhostButtonWithColor:(UIColor *)color {
    TMUIButton *button = [[TMUIButton alloc] init];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = 1;
    button.cornerRadius = -1;
    return button;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    UIEdgeInsets padding = UIEdgeInsetsMake(self.tmui_navigationBarMaxYInViewCoordinator + 36, 24 + self.view.safeAreaInsets.left, 36, 24 + self.view.safeAreaInsets.right);
    UIEdgeInsets padding = UIEdgeInsetsMake(NavigationContentTop + 36, 24, 24, 24);
    self.floatLayoutView.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), TMUIViewSelfSizingHeight);
    
    self.floatLayoutView2.frame = CGRectMake(padding.left, padding.top + self.floatLayoutView.height + 24, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), TMUIViewSelfSizingHeight);
}


@end
