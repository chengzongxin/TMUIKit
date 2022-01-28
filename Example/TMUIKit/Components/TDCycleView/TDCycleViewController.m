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
        @"https://pic.to8to.com/case/1911/15/20191115_450bfe88c8d2c4aa0ec53gxciyvxsl7q_750.jpg",
        @"http://5b0988e595225.cdn.sohucs.com/images/20180520/38493510af9542649fa2eb833cc1f009.jpeg",
        @"https://pic.to8to.com/case/1911/15/20191115_d68a978f2231db9f3389po6zlgyfl8a0.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_92a20b4c5c8272fa8a6amyfem969hih4.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_b8d7424774c4369ad70fo0f3cv90dq4i.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_aea986df16a399bbe63f1uff3xqbg47p.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_5d3d8d9197b3a77ebe5cuzcq0phcrvyx.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_bb9cdae40a5b1cd4c93cb3copxf0u4ze.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_8e9e1f7dda46f2b94d64b4r83oc23et5.jpg"
    ];
    
    _cycleView = [[TMUICycleView alloc] init];
    [self.view addSubview:_cycleView];
    
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop+20);
        make.left.right.mas_equalTo(self.view).insets(20);
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
