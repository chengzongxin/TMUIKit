//
//  TDFloatLayoutImagesViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/1/21.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDFloatImagesViewController.h"
#import "TMUIFloatImagesView.h"
#import "YYWebImage.h"

@interface TDFloatImagesViewController ()

@property (nonatomic, strong) TMUIFloatImagesView *imgsView1;
@property (nonatomic, strong) TMUIFloatImagesView *imgsView2;

@end

@implementation TDFloatImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self demo1];
    
    [self demo2];
}

- (void)demo1{
    
    UILabel *label = Label.styles(h1).addTo(self.view).makeCons(^{
        make.top.left.constants(NavigationContentTop+20,20);
    }).str(@"只显示3行");
    
    TMUIFloatImagesView *imgsView  = [[TMUIFloatImagesView alloc] initWithMaxWidth:TMUI_SCREEN_WIDTH-40];
    [self.view addSubview:imgsView];
    [imgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(@20);
    }];
    
    NSArray *imgs = @[
        @"https://pic.to8to.com/case/1911/15/20191115_450bfe88c8d2c4aa0ec53gxciyvxsl7q_750.jpg",
        @"http://5b0988e595225.cdn.sohucs.com/images/20180520/38493510af9542649fa2eb833cc1f009.jpeg",
        @"https://pic.to8to.com/case/1911/15/20191115_d68a978f2231db9f3389po6zlgyfl8a0.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_92a20b4c5c8272fa8a6amyfem969hih4.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_b8d7424774c4369ad70fo0f3cv90dq4i.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_aea986df16a399bbe63f1uff3xqbg47p.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_5d3d8d9197b3a77ebe5cuzcq0phcrvyx.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_bb9cdae40a5b1cd4c93cb3copxf0u4ze.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_8e9e1f7dda46f2b94d64b4r83oc23et5.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_450bfe88c8d2c4aa0ec53gxciyvxsl7q_750.jpg",
        @"http://5b0988e595225.cdn.sohucs.com/images/20180520/38493510af9542649fa2eb833cc1f009.jpeg",
        @"https://pic.to8to.com/case/1911/15/20191115_d68a978f2231db9f3389po6zlgyfl8a0.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_92a20b4c5c8272fa8a6amyfem969hih4.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_b8d7424774c4369ad70fo0f3cv90dq4i.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_aea986df16a399bbe63f1uff3xqbg47p.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_5d3d8d9197b3a77ebe5cuzcq0phcrvyx.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_bb9cdae40a5b1cd4c93cb3copxf0u4ze.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_8e9e1f7dda46f2b94d64b4r83oc23et5.jpg",
    ];
    
    NSMutableArray <THKFloatImageModel *> *models = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        THKFloatImageModel *model = [[THKFloatImageModel alloc] init];
        model.thumbnailUrl = imgs[i];
        [models addObject:model];
    }
    
    TMUIFloatImagesViewModel *vm = [[TMUIFloatImagesViewModel alloc] initWithModel:models];
    vm.maxShowNum = 3;
    [imgsView bindViewModel:vm];
    
    
    imgsView.loadImage = ^(UIImageView * _Nonnull imageView, THKFloatImageModel * _Nonnull model) {
        NSLog(@"%@",model.thumbnailUrl);
//        imageView
        [imageView yy_setImageWithURL:[NSURL URLWithString:model.thumbnailUrl] options:0];
    };
    imgsView.clickImage = ^(NSInteger index) {
        NSLog(@"%zd",index);
    };
    _imgsView1 = imgsView;
}


- (void)demo2{
    UILabel *label = Label.styles(h1).addTo(self.view).makeCons(^{
        make.top.equal.view(_imgsView1).bottom.constants(20);
        make.left.constants(20);
    }).str(@"显示9行");
    
    TMUIFloatImagesView *imgsView  = [[TMUIFloatImagesView alloc] initWithMaxWidth:TMUI_SCREEN_WIDTH-40];
    [self.view addSubview:imgsView];
    [imgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(@20);
    }];
    
    NSArray *imgs = @[
        @"https://pic.to8to.com/case/1911/15/20191115_450bfe88c8d2c4aa0ec53gxciyvxsl7q_750.jpg",
        @"http://5b0988e595225.cdn.sohucs.com/images/20180520/38493510af9542649fa2eb833cc1f009.jpeg",
        @"https://pic.to8to.com/case/1911/15/20191115_d68a978f2231db9f3389po6zlgyfl8a0.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_92a20b4c5c8272fa8a6amyfem969hih4.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_b8d7424774c4369ad70fo0f3cv90dq4i.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_aea986df16a399bbe63f1uff3xqbg47p.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_5d3d8d9197b3a77ebe5cuzcq0phcrvyx.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_bb9cdae40a5b1cd4c93cb3copxf0u4ze.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_8e9e1f7dda46f2b94d64b4r83oc23et5.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_450bfe88c8d2c4aa0ec53gxciyvxsl7q_750.jpg",
        @"http://5b0988e595225.cdn.sohucs.com/images/20180520/38493510af9542649fa2eb833cc1f009.jpeg",
        @"https://pic.to8to.com/case/1911/15/20191115_d68a978f2231db9f3389po6zlgyfl8a0.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_92a20b4c5c8272fa8a6amyfem969hih4.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_b8d7424774c4369ad70fo0f3cv90dq4i.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_aea986df16a399bbe63f1uff3xqbg47p.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_5d3d8d9197b3a77ebe5cuzcq0phcrvyx.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_bb9cdae40a5b1cd4c93cb3copxf0u4ze.jpg",
        @"https://pic.to8to.com/case/1911/15/20191115_8e9e1f7dda46f2b94d64b4r83oc23et5.jpg",
    ];
    
    NSMutableArray <THKFloatImageModel *> *models = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        THKFloatImageModel *model = [[THKFloatImageModel alloc] init];
        model.thumbnailUrl = imgs[i];
        [models addObject:model];
    }
    
    TMUIFloatImagesViewModel *vm = [[TMUIFloatImagesViewModel alloc] initWithModel:models];
    [imgsView bindViewModel:vm];
    
    
    imgsView.loadImage = ^(UIImageView * _Nonnull imageView, THKFloatImageModel * _Nonnull model) {
        NSLog(@"%@",model.thumbnailUrl);
//        imageView
        [imageView yy_setImageWithURL:[NSURL URLWithString:model.thumbnailUrl] options:0];
    };
    imgsView.clickImage = ^(NSInteger index) {
        NSLog(@"%zd",index);
    };
    _imgsView2 = imgsView;
}



@end
