//
//  TMButtonViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/20.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIButtonViewController.h"

@interface TMUIButtonViewController ()

@property (nonatomic, strong) TMUIButton *btn;

@end

@implementation TMUIButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id l1 = Label.str(self.demoInstructions).styles(h1).fixWidth(self.view.width);
    
//    id str1 = Str( @" *  1. 支持让文字和图片自动跟随 tintColor 变化（系统的 UIButton 默认是不响应 tintColor 的）\n*  2. highlighted、disabled 状态均通过改变整个按钮的alpha来表现，无需分别设置不同 state 下的 titleColor、image。\n*  3. 支持点击时改变背景色颜色（highlightedBackgroundColor）\n*  4. 支持点击时改变边框颜色（highlightedBorderColor）\n*  5. 支持设置图片相对于 titleLabel 的位置（imagePosition）\n*  6. 支持设置图片和 titleLabel 之间的间距，无需自行调整 titleEdgeInests、imageEdgeInsets（spacingBetweenImageAndTitle）)"
//                );
//
//    id l0 = Label.str(str1).styles(body).lineGap(5);
    
    id l2 = Label.str(@"\n\n系统按钮").styles(h2);
    
    UIButton *b1 = Button.styles(button).str(@"UIButton").fixWH(300,100);
    id l3 = Label.str(@"TMUI按钮").styles(h2);
    b1.tmui_image = UIImageMake(@"icon_moreOperation_shareWeibo");
    
    TMUIButton *b2 = (TMUIButton *)[TMUIButton new].styles(button).str(@"TMUIButton").fixWH(300,100);
    b2.highlightedBorderColor = UIColor.tmui_randomColor;
    b2.highlightedBackgroundColor = UIColor.tmui_randomColor;
    b2.tmui_image = UIImageMake(@"icon_moreOperation_shareWeibo");
//    b2.enabled = NO;
    
    
    VerStack(l1,l2,b1,l3,b2,CUISpring).embedIn(self.view, NavigationContentTop+20,20,0).gap(20).centerAlignment;
    
    [self addSegmentedWithTop:750 labelText:@"图文位置" titles:@[@"top",@"left",@"bottom",@"right"] click:^(NSInteger index) {
        b2.imagePosition = index;
    }];
    
    [self addSliderWithTop:800 labelText:@"图文间距" slide:^(float padding) {
        b2.spacingBetweenImageAndTitle = padding;
    }];
    
}


- (void)demo1{
    
    TMUIButton *systemBtn = [[TMUIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    systemBtn.backgroundColor = UIColor.orangeColor;
    [self.view addSubview: systemBtn];
    [systemBtn setImage:[UIImage imageNamed:@"icon_moreOperation_shareWeibo"] forState:UIControlStateNormal];
    [systemBtn setTitle:@"文字" forState:UIControlStateNormal];
    
    
    TMUIButton *btn = [[TMUIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    btn.backgroundColor = UIColor.orangeColor;
    [self.view addSubview: btn];
    [btn setImage:[UIImage imageNamed:@"icon_moreOperation_shareWeibo"] forState:UIControlStateNormal];
    [btn setTitle:@"文字" forState:UIControlStateNormal];
    _btn = btn;
    
    
    [self addSegmentedWithTop:700 labelText:@"图文位置" titles:@[@"top",@"left",@"bottom",@"right"] click:^(NSInteger index) {
        btn.imagePosition = index;
    }];
    
    [self addSliderWithTop:750 labelText:@"图文间距" slide:^(float padding) {
        btn.spacingBetweenImageAndTitle = padding;
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSInteger type = _btn.imagePosition;
//    CGFloat interval = _btn.spacingBetweenImageAndTitle;
//    type ++;
//    if (type > 3) {
//        type = 0;
//    }
//    interval += 10;
//    if (interval > 100) {
//        interval = 0;
//    }
//    _btn.imagePosition = type;
//    _btn.spacingBetweenImageAndTitle = interval;
//}


@end
