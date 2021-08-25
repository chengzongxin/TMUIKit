//
//  UIImageTMUIViewController2.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIImageTMUIViewController2.h"

@interface UIImageTMUIViewController2 ()

@property (nonatomic, strong) CUIStack *stack;

@end

@implementation UIImageTMUIViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white").border(2, @"red");
    
    // embedin scrollview will not vertival huge view
    id scrollView = [UIScrollView new].embedIn(self.view);
    _stack = VerStack().gap(10).embedIn(scrollView, 20, 20, 80);
    
    [self section1];
    
    [self section2];
}

- (void)section1{
    // MARK: Secion1 Shape Image
    CGSize imgSize = CGSizeMake(30, 30);
    Style(@"img_small").fixWH(imgSize);
    
    id l1 = Label.str(@"Shape image").styles(h1);
    CUIStack *horStack = HorStack().gap(20);
    for (int i = 0; i < 7; i++) {
        id i1 = [UIImage tmui_imageWithShape:i size:imgSize tintColor:UIColor.tmui_randomColor];
        UIImageView *iv1 = ImageView.img(i1).aspectFit.styles(@"img_small");
        horStack.addChild(iv1);
    }
    
    // image with color
    id i8 = [UIImage tmui_imageWithColor:UIColor.tmui_randomColor size:imgSize cornerRadius:5];
    UIImageView *iv8 = ImageView.img(i8).aspectFit.styles(@"img_small");
    horStack.addChild(iv8);
    
    _stack.addChild(l1,horStack);
}

- (void)section2{
    // MARK: Secion2 compress Image
    // calculate img
    
    Style(@"img_demo").fixWH(150,100).aspectFit;
    
    UIImage *img = Img(@"angel");
    
    id a1 = AttStr(AttStr(@"Origin img\n").styles(h1),
           AttStr(Str(@"data length %zd",img.tmui_dataLength)).styles(body));
    id l1 = Label.str(a1).multiline;
    
    id iv1 = ImageView.img(img).styles(@"img_demo");
    // compress to max data len 100000 image
    NSData *maxData = [img tmui_resizedToMaxDataLen:100000];
    UIImage *maxImg = [UIImage imageWithData:maxData];
    id a3 = AttStr(AttStr(@"Resized to max date length < 100000 bytes \n").styles(h1),
           AttStr(Str(@"data length %zd",maxData.length)).styles(body));
    id l3 = Label.str(a3).multiline;
    id iv3 = ImageView.img(maxImg).styles(@"img_demo");
    
    // sub image
    CGRect subRect = CGRectMake(img.size.width / 2 - 200, img.size.height / 2 - 200, 800, 800);
    UIImage *subImg = [img tmui_getSubImage:subRect]; // or img.subImg(subRect);
    id a4 = AttStr(AttStr(@"get sub img\n").styles(h1),
           AttStr(Str(@"sub img rect %@",Str(subRect))).styles(body));
    id l4 = Label.str(a4).multiline;
    id iv4 = ImageView.img(subImg).styles(@"img_demo");
    
    id a5 = AttStr(AttStr(@"image in bundle").styles(h1));
    id l5 = Label.str(a5).multiline;
    UIImage *bundleImg = [UIImage tmui_imageInBundleWithName:@"xueUIwang"];
    id iv5 = ImageView.img(bundleImg).styles(@"img_demo");
    
    _stack.addChild(l1,iv1,l3,iv3,l4,iv4,l5,iv5);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // MARK: Secion3 compress Image
    id a2 = AttStr(AttStr(@"snap screen\n").styles(h1),
           AttStr(@"Note: Screenshots can only be taken after display").styles(body));
    id l2 = Label.str(a2).multiline;

    id i9 = [UIImage tmui_imageWithView:self.view afterScreenUpdates:YES];
    id iv9 = ImageView.img(i9).aspectFit.fixWH(200,300);

    _stack.addChild(l2,iv9);

}


@end
 
