//
//  TDFloatLayoutImagesViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/1/21.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDFloatImagesViewController.h"
#import "TMUIFloatImagesView.h"

@interface TDFloatImagesViewController ()

@end

@implementation TDFloatImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TMUIFloatImagesView *imgsView  = [[TMUIFloatImagesView alloc] initWithMaxWidth:TMUI_SCREEN_WIDTH-40];
    [self.view addSubview:imgsView];
    [imgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop);
        make.left.equalTo(@20);
    }];
    imgsView.loadImage = ^(UIImageView * _Nonnull imageView, THKFloatImageModel * _Nonnull model) {
        NSLog(@"%@",model.thumbnailUrl);
    };
    imgsView.clickImage = ^(NSInteger index) {
        NSLog(@"%zd",index);
    };
    
    NSArray *imgs = @[
        @"https://pic.to8to.com/social/day_211223/20211223_9d9379afa8d891a011e1LP7DO9V1X70Y.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242H6VHCV3TK4O1.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242QL7THQ64W2SY.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242VT63TV6F2YFK.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242ONX0565HIX4D.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_9d9379afa8d891a011e1LP7DO9V1X70Y.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242H6VHCV3TK4O1.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242QL7THQ64W2SY.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242VT63TV6F2YFK.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242ONX0565HIX4D.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_9d9379afa8d891a011e1LP7DO9V1X70Y.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242H6VHCV3TK4O1.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242QL7THQ64W2SY.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242VT63TV6F2YFK.jpg",
        @"https://pic.to8to.com/social/day_211223/20211223_f0625040bd98b08bc242ONX0565HIX4D.jpg"
    ];
    
    NSMutableArray <THKFloatImageModel *> *models = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        THKFloatImageModel *model = [[THKFloatImageModel alloc] init];
        model.thumbnailUrl = imgs[i];
        [models addObject:model];
    }
    
    TMUIFloatImagesViewModel *vm = [[TMUIFloatImagesViewModel alloc] initWithModel:models];
    [imgsView bindViewModel:vm];
}


@end
