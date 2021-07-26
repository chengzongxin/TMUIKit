//
//  UILabelTMUIViewController2.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/7/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UILabelTMUIViewController2.h"
#import <CoreText/CoreText.h>

static NSString *const kStr1 = @"hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hhh";

static NSString *const kStr2 = @"hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hhh";

static NSString *const kStr3 = @"hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hhh";


#define kMaxW TMUI_SCREEN_WIDTH - 40

@interface UILabelTMUIViewController2 ()
@property (nonatomic, strong) CUIStack *stack;
@end

@implementation UILabelTMUIViewController2



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // embedin scrollview will not vertival huge view
    id scrollView = [UIScrollView new].embedIn(self.view);
    _stack = VerStack().gap(10).fixWidth(kMaxW).embedIn(scrollView, 20, 20, 80);
    
    
    for (int i = 0; i < 5; i ++) {
        [self demo:i sizeType:0];
    }
    
    _stack.addChild(View);
}

- (void)demo:(NSInteger)line sizeType:(NSInteger)sizeType{
    UILabel *label = Label.txtColor(@"random").fnt(15).lines(line).w(kMaxW);
    [label tmui_setAttributesString:@"春眠不觉晓，\n" color:UIColor.systemBlueColor font:UIFont(20)];
    [label tmui_setAttributesString:@"处处闻啼鸟，\n" color:UIColor.greenColor font:UIFont(18)];
    [label tmui_setAttributesString:@"夜来风雨声，\n" color:UIColor.systemPurpleColor font:UIFont(14)];
    [label tmui_setAttributesString:@"花落知多少。" color:UIColor.yellowColor font:UIFont(12)];
        
    [label tmui_setAttributeslineSpacing:20];
    
    // 影响计算属性，但在计算的时候，会生成一个副本修改
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    /// Label
    CGSize LabelSize = [label tmui_sizeForWidth:kMaxW];
    
    /// AttrbuteString
    CGSize AttrbuteStringSize = [label.tmui_attributedText tmui_sizeForWidth:kMaxW];
    
    /// Text
    CGSize TextSize = [label.text tmui_sizeForFont:label.font size:CGSizeMake(kMaxW, CGFLOAT_MAX) lineHeight:label.tmui_attributeTextLineHeight mode:NSLineBreakByWordWrapping];
    
    id s1 = @"".
    a(@"Lbl Size = ").a(Str(LabelSize)).a(@"\n").
    a(@"Atr Size = ").a(Str(AttrbuteStringSize)).a(@"\n").
    a(@"Txt Size = ").a(Str(TextSize));
    
    id a1 = AttStr(AttStr(Str(@"Line %zd Text\n",line)).styles(h1),
           AttStr(s1).styles(body)).lineGap(3);
    id l1 = Label.str(a1).multiline;
    
    CGRect realSize;
    if (sizeType == 0) {
        realSize = CGRectMakeWithSize(LabelSize);
    }else if (sizeType == 1) {
        realSize = CGRectMakeWithSize(AttrbuteStringSize);
    }else {
        realSize = CGRectMakeWithSize(TextSize);
    }
    
    View.bgColor([UIColor.tmui_randomColor colorWithAlphaComponent:0.2]).addTo(label).xywh(realSize);
     
    _stack.addChild(l1,label,@30);
}
















//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//    id i9 = [UIImage tmui_imageWithView:self.view afterScreenUpdates:YES];
//    id iv9 = ImageView.img(i9).aspectFit.addTo(self.view).makeCons(^{
//        make.left.top.right.bottom.constants(0, 400, 0, 0);
//    });
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    [ALAssetsLibrary.new tmui_saveImage:i9 toAlbum:appName withCompletionBlock:^(NSError * _Nullable error) {
//        if (!error) {
//            [TMToast toast:@"保存成功"];
//        }else{
//            [[[UIAlertView alloc]initWithTitle:@"无法保存"
//                                       message:[NSString stringWithFormat:@"请在iPhone的“设置-隐私-照片”选项中，允许%@访问你的照片",appName]
//                                      delegate:nil
//                             cancelButtonTitle:@"好的"
//                             otherButtonTitles:nil, nil] show];
//            TMUI_DEBUG_Code(
//                    NSLog(@"%@",[error description]);
//                    )
//        }
//    }];
//}

- (void)sizeFit:(UILabel *)label{
//    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, label.width, 0)];
//    sizeLabel.attributedText = [label.attributedText copy];
//    sizeLabel.numberOfLines = label.numberOfLines;
//    [sizeLabel sizeToFit];
//
//    CGFloat maxW = sizeLabel.width;
//    CGFloat maxH = sizeLabel.height;
    
    CGSize size = [label sizeThatFits:CGSizeMake(label.width, CGFLOAT_MAX)];
    CGFloat maxW = size.width;
    CGFloat maxH = size.height;
    
    View.
    bgColor([UIColor.tmui_randomColor colorWithAlphaComponent:0.5]).
    addTo(self.view).
    makeCons((^{
        make.top.left.width.height.constants(tmui_navigationBarHeight() + 50, 50, maxW, maxH);
    }));
    
    [self.view bringSubviewToFront:label];
}

@end
