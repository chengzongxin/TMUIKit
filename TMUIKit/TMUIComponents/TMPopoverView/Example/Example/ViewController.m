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


@end
