//
//  TMUIBadgeViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIBadgeViewController.h"

@interface TMUIBadgeViewController ()

@property (nonatomic, strong) UIView *v1;
@property (nonatomic, strong) UIView *v2;
@end

@implementation TMUIBadgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    UIView *v1 = View;
    
    v1.bgColor(@"random").addTo(self.view).makeCons(^{
        make.top.left.width.height.constants(200,100,100,100);
    }).onClick(^{
        
    });
    
    
    _v1 = v1;
    
    
    self.v1.tmui_updatesIndicatorColor = UIColor.redColor;
    self.v1.tmui_updatesIndicatorSize = CGSizeMake(5, 5);
    self.v1.tmui_shouldShowUpdatesIndicator = YES;
    
    
    
    UIView *v2 = View;
    
    v2.bgColor(@"random").addTo(self.view).makeCons(^{
        make.top.left.width.height.constants(200,250,100,100);
    }).onClick(^{
        self.v2.tmui_shouldShowUpdatesIndicator = !self.v2.tmui_shouldShowUpdatesIndicator;
        Log(self.v2.tmui_shouldShowUpdatesIndicator);
    });
    
    
    _v2 = v2;
    
    
    self.v2.tmui_badgeBackgroundColor = UIColor.redColor;
    self.v2.tmui_badgeInteger = 5;
    self.v2.tmui_badgeTextColor = UIColor.whiteColor;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithTitle:@"item" color:UIColor.tmui_randomColor font:Fnt(15) target:self action:@selector(clickRightItem:)];
}

- (void)clickRightItem:(UIBarItem *)item{
    item.tmui_shouldShowUpdatesIndicator = !item.tmui_shouldShowUpdatesIndicator;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.v1.tmui_shouldShowUpdatesIndicator = !self.v1.tmui_shouldShowUpdatesIndicator;
    Log(self.v1.tmui_shouldShowUpdatesIndicator);
    self.v2.tmui_badgeInteger = !self.v2.tmui_badgeInteger;
    Log(self.v2.tmui_shouldShowUpdatesIndicator);
}

@end
