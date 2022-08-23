//
//  TDDebugViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/5/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDDebugViewController.h"

@interface TDDebugViewController ()

@end

@implementation TDDebugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Log([NSString tmui_isEmpty:@""]);
    Log(tmui_isNullString(@""));
    
    UILabel *l1 = Label;
    
    UILabel *l2 = Label;
    
    UILabel *l3 = Label;
    
    [self.view addSubview:l1];
    [self.view addSubview:l2];
    [self.view addSubview:l3];
    
    l1.numberOfLines = 0;
    l1.frame = CGRectMake(100, 100, 100, 40);

//    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(NavigationContentTop+20);
//        make.left.mas_equalTo(20);
//    }];
//
//    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(l1.mas_bottom).offset(20);
//        make.left.mas_equalTo(20);
//    }];
//
//    [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(l2.mas_bottom).offset(20);
//        make.left.mas_equalTo(20);
//    }];
    
    CGFloat lineSpacing = 20;
//    NSAttributedString *str = [NSAttributedString tmui_attributedStringWithString:@"fdsjfhsdkjfhds" lineSpacing:lineSpacing];
//    l1.attributedText = str;
    
    [l1 tmui_setAttributesString:@"xxxxxhhahdsdasdasdsadsadsadsahf" lineSpacing:lineSpacing];
    [l2 tmui_setAttributesString:@"xxxxxhhahah\njsadkfdskfdsfds" lineSpacing:lineSpacing];
    [l3 tmui_setAttributesString:@"xxxxxhhahah\njsadkfdskfdsfds\nfhdslkfdslfsd" lineSpacing:lineSpacing];
//    [l1 tmui_setAttributeslineSpacing:5];
    VerStack(l1,l2,l3,CUISpring).gap(40).embedIn(self.view, NavigationContentTop+20, 20, 0);
    
    
//    NSString *nilStr = nil;
//    NSString *nilStr2 = nil;
//    NSDictionary *dict = @{@"xxx":nilStr,
//                           @"xaaa":@"123123"
//    };
//    NSLog(@"%@",dict);
    
//    NSMutableDictionary *mDict = dict.mutableCopy;
//    mDict[@"dsa"] = nilStr2;
//    [mDict setValue:nilStr2 forKey:@"asdaa"];
//    NSLog(@"%@",mDict);
//    mDict[@"dsa1"] = @"fdfsf";
//    [mDict setValue:@"fdsfdsfds" forKey:@"as11daa"];
//    NSLog(@"%@",mDict);
    
//    UIView *view = mDict[@"dsa"];
//    view.backgroundColor = UIColor.redColor;
//    Log(view);
    
    /// 直接在self添加渐变视图会遮盖子视图 所有转换为图片 添加为背景图
    
//    UIImage *img = [UIImage convertViewToImage:[[HPNavigationBar alloc]initWithFrame:CGRectMake(0, -STATUS_BAR_HEIGHT, MN_WIDTH, NAVIGATION_HRIGHT)]];
//    UIImage *img =
//    UIView *view = [[UIView alloc] init];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UIImage *backImg = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBackgroundImage:Img(@"angel") forBarMetrics:UIBarMetricsDefault];
//    NSLog(@"%@",backImg);
//    UIImageView *imgv1 = ImageView.img(img).addTo(self.view);
//        .makeCons(^{
//        make.left.top.constants(0,200);
//    });
//    CGSize customSize = self.navigationController.navigationBar.frame.size;
//    imgv1.frame = CGRectMake(0, -StatusBarHeight, customSize.width, customSize.height + 20);
//    imgv1.userInteractionEnabled = NO;
//    [self.navigationController.navigationBar insertSubview:imgv1 atIndex:0];
//    self.navigationController.navigationBa
    
//    img = [UIImage imageNamed:@"angel"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *img = [UIImage tmui_imageWithGradientColors:@[UIColorGreen,UIColorBlue] type:TMUIImageGradientTypeTopLeftToBottomRight locations:@[@0.5] size:CGSizeMake(TMUI_SCREEN_WIDTH, tmui_navigationBarHeight()) cornerRadiusArray:nil];
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
        [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar layoutIfNeeded];
        
        [UINavigationBar.appearance setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        
    });
    
    
}



@end
