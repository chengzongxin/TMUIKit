//
//  UIImageTMUIViewController2.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIImageTMUIViewController2.h"

@interface UIImageTMUIViewController2 ()

@end

@implementation UIImageTMUIViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    // Shape Image
    id s1 = Style().fnt(20).color(Color(@"red")).fixWidth(200);
    id s3 = Style().fixWH(50,30);
    // TMUIImageShapeOval
    id l1 = Label.str(@"shape image").styles(s1);
    id i1 = [UIImage tmui_imageWithShape:TMUIImageShapeOval size:CGSizeMake(50, 50) tintColor:UIColor.tmui_randomColor];
    UIImageView *iv1 = ImageView.img(i1).aspectFit.styles(s3);
    // TMUIImageShapeTriangle
    id i2 = [UIImage tmui_imageWithShape:TMUIImageShapeTriangle size:CGSizeMake(50, 50) tintColor:UIColor.tmui_randomColor];
    UIImageView *iv2 = ImageView.img(i2).aspectFit.styles(s3);
    // TMUIImageShapeDisclosureIndicator
    id i3 = [UIImage tmui_imageWithShape:TMUIImageShapeDisclosureIndicator size:CGSizeMake(50, 50) tintColor:UIColor.tmui_randomColor];
    UIImageView *iv3 = ImageView.img(i3).aspectFit.styles(s3);
    
    id i4 = [UIImage tmui_imageWithShape:TMUIImageShapeCheckmark size:CGSizeMake(50, 50) tintColor:UIColor.tmui_randomColor];
    UIImageView *iv4 = ImageView.img(i4).aspectFit.styles(s3);
    
    id i5 = [UIImage tmui_imageWithShape:TMUIImageShapeDetailButtonImage size:CGSizeMake(50, 50) tintColor:UIColor.tmui_randomColor];
    UIImageView *iv5 = ImageView.img(i5).aspectFit.styles(s3);
    
    id i6 = [UIImage tmui_imageWithShape:TMUIImageShapeNavBack size:CGSizeMake(50, 50) tintColor:UIColor.tmui_randomColor];
    UIImageView *iv6 = ImageView.img(i6).aspectFit.styles(s3);
    
    id i7 = [UIImage tmui_imageWithShape:TMUIImageShapeNavClose size:CGSizeMake(50, 50) tintColor:UIColor.tmui_randomColor];
    UIImageView *iv7 = ImageView.img(i7).aspectFit.styles(s3);
    
    // image with color
    id i8 = [UIImage tmui_imageWithColor:UIColor.tmui_randomColor size:CGSizeMake(50, 50) cornerRadius:10];
    UIImageView *iv8 = ImageView.img(i8).aspectFit.styles(s3);
    
    // snap scrren
    id l2 = Label.str(@"snap screen").styles(s1);
    id i9 = [UIImage tmui_imageWithView:self.view afterScreenUpdates:YES];
    UIImageView *iv9 = ImageView.img(i9).aspectFit.styles(s3);
    
    id l3 = Label.str(@"snap screen2").styles(s1);
    
    id scrollView = [UIScrollView new].embedIn(self.view);
    VerStack(l1,
             HorStack(iv1,iv2,iv3,iv4,iv5,iv6,iv7,iv8),
             l2,
             iv9,
             l3
             ).embedIn(scrollView, 20, 20, 80).gap(30);
    
    
//    UIView *vv1 = View.bgColor(@"random").embedIn(self.view).makeCons(^{
////        make.top.left.right.bottom.constants(100,100,-100,-100);
//        make.top.left.constants(100,100);
//    }).fixWH(100,100);
//
//    NSLog(@"%@",vv1.constraints);
//
//    UIView *vv2 = View.bgColor(@"random").embedIn(self.view).makeCons(^{
//        make.top.left.width.height.constants(300,100,100,100);
//    });
//
//    NSLog(@"%@",vv2.constraints);
//
//    UIView *vv3 = View.bgColor(@"random").embedIn(self.view);
//    [vv3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(100);
//        make.top.mas_equalTo(500);
//        make.size.mas_equalTo(CGSizeMake(100, 100));
//    }];
//
//    NSLog(@"%@",vv3.constraints);
//
//    NSLog(@"%@",self.view.constraints);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    id s3 = Style().fixWH(50,30);
    id i9 = [UIImage tmui_imageWithView:self.view afterScreenUpdates:YES];
    ImageView.img(i9).aspectFit.styles(s3).embedIn(self.view, 300,0,0,0);
}


@end
