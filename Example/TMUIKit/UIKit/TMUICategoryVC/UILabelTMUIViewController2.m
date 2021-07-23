//
//  UILabelTMUIViewController2.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/7/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UILabelTMUIViewController2.h"
#import <CoreText/CoreText.h>
@interface UILabelTMUIViewController2 ()

@end

@implementation UILabelTMUIViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hello world hhh";
    UILabel *label = Label.
    txtColor(@"random").
    fnt(15).
    lines(0).
    addTo(self.view).
    makeCons(^{
        make.top.left.right.equal.constants(tmui_navigationBarHeight() + 50, 50, -50);
    });
    
    [label tmui_setAttributesString:str lineSpacing:20];
//    [label layoutIfNeeded];
    
    CGFloat maxW = TMUI_SCREEN_WIDTH - 100;
    CGFloat maxH;
        
    // 影响计算
//    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    /// Label
    CGSize realSize = [label tmui_sizeForWidth:maxW];
    CGFloat textW = realSize.width-2;
    CGFloat textH = realSize.height;
    
    View.
    bgColor([UIColor.tmui_randomColor colorWithAlphaComponent:0.5]).
    addTo(self.view).
    makeCons((^{
        make.top.left.width.height.constants(tmui_navigationBarHeight() + 50, 50, textW, textH);
    }));
    
    /// AttrbuteString
    maxH = [label.tmui_attributedText tmui_sizeForWidth:maxW].height;
//
//    /// Text
//    maxH = [label.text tmui_sizeForFont:label.font size:CGSizeMake(maxW, CGFLOAT_MAX) lineHeight:label.tmui_attributeTextLineHeight mode:label.lineBreakMode].height;
    
    Log(maxH);
    
    Log(label.text);
     
    NSArray *arr = [label.text tmui_linesArrayForFont:label.font maxWidth:textW];
    NSInteger line = [label.text tmui_numberOfLinesForFont:label.font maxWidth:textW];
    NSInteger line2 = [label.text tmui_numberOfLinesWithFont:label.font contrainstedToWidth:textW];
    Log(arr);
    Log(line);
    Log(line2);
    
//    [self sizeFit:label];
    
}

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
