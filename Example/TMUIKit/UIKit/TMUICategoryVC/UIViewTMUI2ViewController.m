//
//  UIViewTMUI2ViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/2/24.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewTMUI2ViewController.h"
#import "TMUITips.h"
@interface UIViewTMUI2ViewController ()

@property (nonatomic, strong) UILabel *l1;
@property (nonatomic, strong) UILabel *l2;
@property (nonatomic, strong) UILabel *l3;
@property (nonatomic, strong) UILabel *l4;

@property (nonatomic, strong) UIView *v1;

@end

@implementation UIViewTMUI2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self demo1];
    
    Label.str(self.demoInstructions).styles(h1).addTo(self.view).makeCons(^{
        make.top.left.constants(NavigationContentTop+20,20);
    });
    
    _l1 = Label.styles(body).addTo(self.view).makeCons(^{
        make.bottom.left.constants(-160,20);
    });
    
    _l2 = Label.styles(body).addTo(self.view).makeCons(^{
        make.bottom.left.constants(-140,20);
    });
    
    _l3 = Label.styles(body).addTo(self.view).makeCons(^{
        make.bottom.left.constants(-120,20);
    });
    
    _l4 = Label.styles(body).addTo(self.view).makeCons(^{
        make.bottom.left.constants(-100,20);
    });
}


- (void)demo1{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.tmui_randomColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-100);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = UIColor.tmui_randomColor;
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.centerY.mas_equalTo(self.view).offset(-100);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    _v1 = view2;
    
    NSArray *titles = @[@"none",@"点击",@"双击",@"长按"];
    
    [self addSliderWithTop:500 labelText:@"扩大点击区域" slide:^(float padding) {
        view.tmui_outsideEdge = UIEdgeInsetsMake(-padding, -padding, -padding, -padding);
    }];
    
    // 圆角
    @TMUI_weakify(self);
    [self addSegmentedWithTop:550 labelText:@"手势类型" titles:titles click:^(NSInteger index) {
        @TMUI_strongify(self);
        for (UIGestureRecognizer *ges in view.gestureRecognizers) {
            [view removeGestureRecognizer:ges];
        }
        switch (index) {
            case 1:{
                [view tmui_addSingerTapWithBlock:^{
                    TMUITipsText(titles[index]);
                    [self tapView:view];
                }];
            }
                break;
            case 2:{
                [view tmui_addDoubleTapWithBlock:^{
                    TMUITipsText(titles[index]);
                    [self tapView:view];
                }];
            }
                break;
            case 3:{
                [view tmui_addLongPressGestureWithMinimumPressDuration:0.5 stateBegin:^{
                    TMUITipsText(titles[index]);
                    [self tapView:view];
                } stateEnd:^{
                    
                }];
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}

- (void)tapView:(UIView *)view{
    UITapGestureRecognizer *ges = view.gestureRecognizers.firstObject;
    CGPoint point = [ges locationInView:view];
    CGPoint sPoint = [view tmui_convertPoint:point toViewOrWindow:view.superview];
    
    _l1.str(@"点击坐标:".a(CGPointToFixed(point, 0)));
    _l2.str(@"对应坐标:".a(CGPointToFixed(sPoint, 0)));
//    _l3.str(@"对应frame:".a(view.frame));
//    _l4.str(@"相对右边view的frame:".a([view tmui_convertRect:_v1.frame fromViewOrWindow:_v1]));
}


@end
