//
//  UIImageTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIImageTMUIViewController1.h"

@interface UIImageTMUIViewController1 ()

@end

@implementation UIImageTMUIViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(UIColor.whiteColor);
    
    
    id s1 = Style().fnt(14).color(Color(@"black")).fixWidth(200);
    id s2 = Style().fnt(12).color(Color(@"gray")).fixWidth(200);
    id s3 = Style().fixWH(150,100);
    // origin
    id l1 = Label.str(@"origin image").styles(s1);
    id i1 = Img(@"angel");
    UIImageView *iv1 = ImageView.img(i1).aspectFit.styles(s3);
    // resize
    id l2 = Label.str(@"resize image to 100x100").styles(s2).multiline;
    id i2 = [Img(@"angel") tmui_resizedInRect:CGRectMake(0, 0, 100, 100)];
    UIImageView *iv2 = ImageView.img(i2).aspectFit.styles(s3);
    // gray
    id l3 = Label.str(@"gray image").styles(s2).multiline;
    id i3 = [Img(@"angel") tmui_grayImage];
    UIImageView *iv3 = ImageView.img(i3).aspectFit.styles(s3);
    
    id l4 = Label.str(@"image alpha 0.5").styles(s2).multiline;
    id i4 = [Img(@"angel") tmui_imageWithAlpha:0.5];
    UIImageView *iv4 = ImageView.img(i4).aspectFit.styles(s3);
    
    id l5 = Label.str(@"image orientation").styles(s2).multiline;
    id i5 = [Img(@"angel") tmui_imageWithOrientation:UIImageOrientationDown];
    UIImageView *iv5 = ImageView.img(i5).aspectFit.styles(s3);
    
    id l6 = Label.str(@"image water mark").styles(s2).multiline;
    id i6 = [Img(@"angel") tmui_imageWithWaterMarkAttributedText:AttStr(@"water mark text").color(@"red").fnt(30) textAlpha:0.9];
    UIImageView *iv6 = ImageView.img(i6).aspectFit.styles(s3);
    
    
    id scrollView = [UIScrollView new].embedIn(self.view);
    VerStack(HorStack(l1,iv1),
             HorStack(l2,iv2),
             HorStack(l3,iv3),
             HorStack(l4,iv4),
             HorStack(l5,iv5),
             HorStack(l6,iv6),
             ).embedIn(scrollView, 20, 20, 80);
    
    iv1.onClick(^{
        [TMShowBigImageViewController showBigImageWithImageView:iv1 transitionStyle:THKTransitionStylePush];
    });
    iv2.onClick(^{
        [TMShowBigImageViewController showBigImageWithImageView:iv2 transitionStyle:THKTransitionStylePush];
    });
    iv3.onClick(^{
        [TMShowBigImageViewController showBigImageWithImageView:iv3 transitionStyle:THKTransitionStylePush];
    });
    iv4.onClick(^{
        [TMShowBigImageViewController showBigImageWithImageView:iv4 transitionStyle:THKTransitionStylePush];
    });
    iv5.onClick(^{
        [TMShowBigImageViewController showBigImageWithImageView:iv5 transitionStyle:THKTransitionStylePush];
    });
    iv6.onClick(^{
        [TMShowBigImageViewController showBigImageWithImageView:iv6 transitionStyle:THKTransitionStylePush];
    });
    
}



@end
