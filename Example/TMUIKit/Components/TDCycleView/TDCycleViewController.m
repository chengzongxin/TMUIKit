//
//  TDCycleViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/1/28.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDCycleViewController.h"
#import "YYWebImage.h"
@interface TDCycleViewController ()


@property (nonatomic, strong) TMUICycleView *cycleView;

@end

@implementation TDCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imgs = @[
        @"https://pic50.t8tcdn.com/to8to/css/brand/ec64e054417aed4b771cf5cc9f747c70.jpg!500.webp",
        @"https://pic50.t8tcdn.com/to8to/css/brand/a6ce746fe271ac8916b2f7373811124b.png!500.webp",
        @"https://pic.to8to.com/public/20220104/3a0b7787128f511eb6849690140693e1.png!500.webp"
    ];
    
    _cycleView = [[TMUICycleView alloc] init];
    _cycleView.pageControlPaddingBottom = 10;
    [self.view addSubview:_cycleView];
    
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop+20);
        make.left.right.mas_equalTo(self.view).inset(20);
        make.height.mas_equalTo(300);
    }];
    _cycleView.configCell = ^(TMUICycleViewCell * _Nonnull cell, id  _Nonnull model) {
        [cell.imageView yy_setImageWithURL:[NSURL URLWithString:model] placeholder:nil];
    };
    
    _cycleView.selectCell = ^(TMUICycleViewCell * _Nonnull cell, id  _Nonnull model) {
        NSLog(@"%@",cell);
    };
    
    _cycleView.datas = imgs;
}



@end
