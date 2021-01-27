//
//  NSAttributedString+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSAttributedString+TMUI.h"

@implementation NSAttributedString (TMUI)


- (CGFloat)heightWithMaxWidth:(CGFloat)width {
    CGRect rt = [self boundingRectWithSize:CGSizeMake(width, 100000)
                                   options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                   context:nil];
    return ceilf(rt.size.height);// 向上取整，消除小数转整数误差
}

// 设置行间距
+ (instancetype)atsForStr:(NSString *)str lineHeight:(CGFloat)h {
    return [self atsForStr:str lineHeight:h forCompute:NO];
}

+ (instancetype)atsForStr:(NSString *)str lineHeight:(CGFloat)h forCompute:(BOOL)forCompute {
    if (![str isKindOfClass:[NSString class]] || str.length == 0) {
        return nil;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = forCompute?NSLineBreakByWordWrapping:NSLineBreakByTruncatingTail;
    [paragraphStyle setLineSpacing:h];// 调整行间距
    NSAttributedString * attributedString = [[self alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    return attributedString;
}

// 获取设置行间距的NSAttributedString的高度
-(CGFloat)heightWithFont:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lh {
    CGFloat height = [self heightWithMaxWidth:w];
    if (height < ft.pointSize*2+lh) {
        height = ft.lineHeight;
    }
    return ceilf(height);
}

+ (CGFloat)heightForAtsWithStr:(NSString *)str font:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat )lh {
    if (![str isKindOfClass:[NSString class]] || str.length == 0) {
        return 0;
    }
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString atsForStr:str lineHeight:lh forCompute:YES];
    [attributedString addAttribute:NSFontAttributeName value:ft range:NSMakeRange(0, str.length)];
    
    CGFloat height = [attributedString heightWithFont:ft width:w lineH:lh];
    return ceilf(height);
}

- (CGFloat)heightWithFont:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lineGap maxLine:(NSUInteger)lineNum {
    return [[self class] heightForAtsWithStr:self.string font:ft width:w lineH:lineGap maxLine:lineNum];
}

+ (CGFloat)heightForAtsWithStr:(NSString *)str font:(UIFont *)ft width:(CGFloat)w lineH:(CGFloat)lh maxLine:(NSUInteger)lineNum {
    CGFloat heightOfAll = [self heightForAtsWithStr:str font:ft width:w lineH:lh];
    CGFloat heightOfMax = CGFLOAT_MAX;
    if (lineNum != 0) {
        NSString *strTem = @"a";
        for (int i=0; i<lineNum-1; i++) {
            strTem = [strTem stringByAppendingString:@"\na"];
        }
        heightOfMax = [self heightForAtsWithStr:strTem font:ft width:w lineH:lh];
    }
    return ceilf(MIN(heightOfAll, heightOfMax));
}
@end


@implementation NSAttributedString (TMUI_Drawing)
//固定宽度计算多行文本高度，支持开头空格、自定义插入的文本图片不纳入计算范围，包含emoji表情符仍然会有较大偏差，但在UITextView和UILabel等控件中不影响显示。
- (CGSize)tmui_sizeForWidth:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, HUGE) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

@end
