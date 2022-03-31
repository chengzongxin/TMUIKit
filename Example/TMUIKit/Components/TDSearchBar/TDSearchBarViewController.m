//
//  TDSearchBarViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/3/24.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDSearchBarViewController.h"
#import "TDSearchViewController.h"

@interface TDSearchBarViewController ()

@end

@implementation TDSearchBarViewController


// test push
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self homelist];
}

- (void)homelist{
    id b6 =
        [self createBtn]
        .str(@"🔍 滚动搜索框")
        .onClick(^{
            TDSearchViewController *vc = [TDSearchViewController new];
            vc.style = 0;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b7 =
        [self createBtn]
        .str(@"🔍 常规搜索框1")
        .onClick(^{
            TDSearchViewController *vc = [TDSearchViewController new];
            vc.style = 1;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b8 =
        [self createBtn]
        .str(@"🔍 城市搜索框2")
        .onClick(^{
            TDSearchViewController *vc = [TDSearchViewController new];
            vc.style = 2;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    id b9 =
        [self createBtn]
        .str(@"系统导航栏搜索框")
        .onClick(^{
            TDSearchViewController *vc = [TDSearchViewController new];
            vc.style = 3;
            [self.navigationController pushViewController:vc animated:YES];
        });
    
    VerStack(b6,b7,b8,b9)
    .gap(10)
    .embedIn(UIScrollView.new.embedIn(self.view), 0, 20, 80);
}



- (UIButton *)createBtn{
    return
    Button
    .color(@"white")
    .bgColor(@"random")
    .borderRadius(4)
    .fixWH(TMUI_SCREEN_WIDTH - 40,44);
}


@end
