//
//  ViewController.m
//  Example
//
//  Created by nigel.ning on 2020/4/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItems = @[
        ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(navItemClick:)];
            item;
        }),
        ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(navItemClick:)];
            item;
        }),
        ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(navItemClick:)];
            item;
        }),
    ];
    
    self.navigationItem.rightBarButtonItems = @[
        ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navItemClick:)];
            item;
        }),
        ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(navItemClick:)];
            item;
        }),
        ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(navItemClick:)];
            item;
        }),
    ];
}

- (void)navItemClick:(UIBarButtonItem *)item {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    
    TMPopoverView *popView = [TMPopoverView popoverViewWithContentView:view contentSize:CGSizeMake(120, 200)];
    [popView showFromBarButtonItem:item arrowDirection:TMPopoverArrowDirectionUp];
}

- (IBAction)bottomToolBarItemClick:(UIBarButtonItem *)item {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    
    TMPopoverView *popView = [TMPopoverView popoverViewWithContentView:view contentSize:CGSizeMake(120, 200)];
    NSInteger arc4Offset = (NSInteger)(arc4random()%120) - 60;
    TMUI_DEBUG_Code(
                    NSLog(@"arrow_offset_%@", @(arc4Offset));
                    )
    popView.arrowCenterOffset = arc4Offset;//设置箭头在居中的情况下，随机向左或右偏移一些位置显示
    [popView showFromBarButtonItem:item arrowDirection:TMPopoverArrowDirectionDown];
}

- (IBAction)leftSideButtonClick:(UIButton *)btn {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    
    TMPopoverView *popView = [TMPopoverView popoverViewWithContentView:view contentSize:CGSizeMake(120, 200)];
    [popView showFromRect:btn.frame inView:self.view arrowDirection:TMPopoverArrowDirectionLeft];
}

- (IBAction)rightSideButtonClick:(UIButton *)btn {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    
    //TMPopoverView *popView = [TMPopoverView popoverViewWithContentView:view contentSize:CGSizeMake(120, 200)];
    TMPopoverView *popView = [TMPopoverView popoverViewWithContentView:view layoutContentViewSize:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(150, 180));
    }];
    popView.arrowSize = CGSizeMake(10, 6);
    [popView showFromRect:btn.frame inView:self.view arrowDirection:TMPopoverArrowDirectionRight];
}

- (IBAction)showCustomGuideBtn:(UIButton *)btn {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-2);
        make.top.mas_equalTo(2);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    closeBtn.backgroundColor = [UIColor blueColor];
        
    TMPopoverView *popView = [TMPopoverView popoverViewWithContentView:view layoutContentViewSize:^(MASConstraintMaker * _Nonnull make) {
        make.size.mas_equalTo(CGSizeMake(100, 180));
    }];
    popView.autoDismissWhenTouchOutSideContentView = NO;
    popView.arrowSize = CGSizeMake(10, 6);
    [popView showFromRect:btn.frame inView:self.view arrowDirection:TMPopoverArrowDirectionLeft];
}

- (void)closeBtnClick:(UIButton *)btn  {
    [btn.tmui_popoverView dismissWithFinishBlock:^{
        TMUI_DEBUG_Code(
                        NSLog(@"popoverView dismissed!");
                        )
    }];
}

@end
