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

@property(nonatomic, strong) UIToolbar *toolbar;
@property(nonatomic, strong) UITabBar *tabBar;

@end

@implementation TMUIBadgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    [self viewBadge];
    
    [self barbuttonBadge];
    
    [self toolBarBadge];
    
    [self tabbarBadge];
}

- (void)viewBadge{
    UIView *v1 = View;
    
    v1.bgColor(@"random").addTo(self.view).makeCons(^{
        make.top.left.width.height.constants(200,100,100,100);
    }).onClick(^{
        
    });
    
    
    _v1 = v1;
    
    
//    self.v1.tmui_updatesIndicatorColor = UIColor.redColor;
//    self.v1.tmui_updatesIndicatorSize = CGSizeMake(5, 5);
    self.v1.tmui_shouldShowUpdatesIndicator = YES;
    
    
    
    UIView *v2 = View;
    
    v2.bgColor(@"random").addTo(self.view).makeCons(^{
        make.top.left.width.height.constants(200,250,100,100);
    }).onClick(^{
        self.v2.tmui_shouldShowUpdatesIndicator = !self.v2.tmui_shouldShowUpdatesIndicator;
        Log(self.v2.tmui_shouldShowUpdatesIndicator);
    });
    
    
    _v2 = v2;
    
    
//    self.v2.tmui_badgeBackgroundColor = UIColor.redColor;
    self.v2.tmui_badgeInteger = 5;
//    self.v2.tmui_badgeTextColor = UIColor.whiteColor;
}

- (void)barbuttonBadge{
    
    
    UIBarButtonItem *item1 = [UIBarButtonItem tmui_itemWithTitle:@"item" target:self action:@selector(clickRightItem:)];
//    item1.tmui_updatesIndicatorColor = UIColor.redColor;
//    item1.tmui_updatesIndicatorSize = CGSizeMake(5, 5);
//    item1.tmui_updatesIndicatorOffset = CGPointMake(0, 5);
    self.navigationItem.rightBarButtonItem = item1;
    
    UIBarButtonItem *item2 = [UIBarButtonItem tmui_itemWithTitle:@"item" target:self action:@selector(clickRightItem:)];
//    item2.tmui_badgeBackgroundColor = UIColor.redColor;
//    item2.tmui_badgeOffset = CGPointMake(0, 12);
//    item2.tmui_badgeFont = Fnt(10);
//    item2.tmui_badgeTextColor = UIColor.whiteColor;
    self.navigationItem.rightBarButtonItem = item2;
    
    item1.tmui_shouldShowUpdatesIndicator = YES;
    item2.tmui_badgeInteger = 666;
    
    self.navigationItem.rightBarButtonItems = @[item1,[UIBarButtonItem tmui_flexibleSpaceItem],item2];
}

- (void)toolBarBadge{
    
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.tintColor = UIColor.tmui_randomColor;
    self.toolbar.items = @[
        [UIBarButtonItem tmui_flexibleSpaceItem],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:NULL],
        [UIBarButtonItem tmui_flexibleSpaceItem],
        BeginIgnoreClangWarning(-Wnonnull)
        [UIBarButtonItem tmui_itemWithImage:UIImageMake(@"icon_tabbar_uikit") target:nil action:nil],
        [UIBarButtonItem tmui_flexibleSpaceItem],
        [UIBarButtonItem tmui_itemWithTitle:@"ToolbarItem" target:nil action:NULL],
        EndIgnoreClangWarning
        [UIBarButtonItem tmui_flexibleSpaceItem],
    ];
    [self.toolbar sizeToFit];
    self.toolbar.items[1].tmui_shouldShowUpdatesIndicator = YES;
    self.toolbar.items[3].tmui_badgeInteger = 8;
    self.toolbar.items[5].tmui_badgeString = @"99+";
    [self.view addSubview:self.toolbar];
    
    self.toolbar.makeCons(^{
        make.left.bottom.right.height.constants(0,tmui_safeAreaBottomInset() - 100,0,44);
    });
}

- (void)tabbarBadge{
    
    self.tabBar = [[UITabBar alloc] init];
    
    UITabBarItem *item1 = [self tabBarItemWithTitle:@"tmuiKit" image:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_uikit_selected") tag:0];
//    item1.tmui_updatesIndicatorSize = CGSizeMake(5, 5);
//    item1.tmui_updatesIndicatorColor = UIColor.redColor;
    item1.tmui_shouldShowUpdatesIndicator = YES;
    
    UITabBarItem *item2 = [self tabBarItemWithTitle:@"Components" image:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_component_selected") tag:1];
    item2.tmui_badgeString = @"99+";// 支持字符串
//    item2.tmui_badgeTextColor = UIColor.whiteColor;
//    item2.tmui_badgeBackgroundColor = UIColor.redColor;
//    item2.tmui_badgeFont = Fnt(10);
    
    UITabBarItem *item3 = [self tabBarItemWithTitle:@"Lab" image:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_lab_selected") tag:2];
    
    self.tabBar.items = @[item1, item2, item3];
    self.tabBar.selectedItem = item1;
    [self.tabBar sizeToFit];
    [self.view addSubview:self.tabBar];
    
    self.tabBar.makeCons(^{
        make.left.bottom.right.height.constants(0,tmui_safeAreaBottomInset(),0,88);
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.v1.tmui_shouldShowUpdatesIndicator = !self.v1.tmui_shouldShowUpdatesIndicator;
    Log(self.v1.tmui_shouldShowUpdatesIndicator);
    self.v2.tmui_badgeInteger = !self.v2.tmui_badgeInteger;
    Log(self.v2.tmui_shouldShowUpdatesIndicator);
    
    UIBarButtonItem *item1 = self.navigationItem.rightBarButtonItems.firstObject;
    UIBarButtonItem *item2 = self.navigationItem.rightBarButtonItems.lastObject;
    item1.tmui_shouldShowUpdatesIndicator = !item1.tmui_shouldShowUpdatesIndicator;
    item2.tmui_badgeInteger = !item2.tmui_badgeInteger;
}




- (void)clickRightItem:(UIBarItem *)item{
//    item.tmui_shouldShowUpdatesIndicator = !item.tmui_shouldShowUpdatesIndicator;
}



- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    tabBarItem.selectedImage = selectedImage;
    return tabBarItem;
}

@end
