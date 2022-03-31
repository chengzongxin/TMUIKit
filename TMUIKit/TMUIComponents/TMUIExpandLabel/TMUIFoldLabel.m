//
//  TMUIFoldLabel.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/3/24.
//

#import "TMUIFoldLabel.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+TMUI.h"
@interface TMUIFoldLabel ()

@property (nonatomic, strong) NSAttributedString *originAttr;

@property (nonatomic, assign) CGFloat maxWidth;
/** 收起/展开颜色 默认blueColor*/
@property (nonatomic, strong) UIColor *foldColor;
@property (nonatomic, assign) CGRect clickArea;
/// 段落样式
@property (nonatomic, strong) NSMutableParagraphStyle *style;

@property (nonatomic, strong) NSAttributedString *foldAttrString;
@property (nonatomic, strong) NSAttributedString *unfoldAttrString;

@property (nonatomic, strong) NSAttributedString *foldClickString;

@property (nonatomic, assign) CGFloat foldHeight;
@property (nonatomic, assign) CGFloat unfoldHeight;

@property (nonatomic, assign) BOOL isFold;

@property (nonatomic, assign) BOOL numberOfLinesEnoughShowAllContents;

@end


@implementation TMUIFoldLabel
@dynamic attributedText;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.numberOfLines = 3;
    self.maxWidth = UIScreen.mainScreen.bounds.size.width;
    self.font = [UIFont systemFontOfSize:12];
    self.isFold = YES;
    self.foldColor = UIColor.redColor;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureTapped:)]];
}


/// 最初设置富文本处于收起状态
- (void)setAttributedText:(NSAttributedString *)attributedText{
    _originAttr = attributedText;
    
    if (self.numberOfLines == 0) {
        [super setAttributedText:attributedText];
        return;
    }
    // 计算行数
    NSInteger lineCount = [self numberOfLinesForAttributtedText:attributedText];
    if (lineCount <= self.numberOfLines) {
        self.numberOfLinesEnoughShowAllContents = YES;
        [super setAttributedText:attributedText];
        return;
    }
    
    self.numberOfLinesEnoughShowAllContents = NO;
    self.font = attributedText.tmui_font;
    self.textColor = attributedText.tmui_color;
    self.style = attributedText.tmui_paragraphStyle;
    self.isFold = YES;
    
    [self createFoldAttr:attributedText];
    [self invalidateIntrinsicContentSize];
    [super setAttributedText:self.foldAttrString];
}


/// 点击了展开文本后，显示展开文本
- (void)actionGestureTapped: (UITapGestureRecognizer*)sender{
    if (CGRectContainsPoint(_clickArea, [sender locationInView:self])) {
        if (self.isFold == YES) {
            self.isFold = NO;
            self.numberOfLines = 0;
            [self invalidateIntrinsicContentSize];
            [super setAttributedText:self.originAttr];
        }
    }else{
//        !_clickActionBlock?:_clickActionBlock(TMUIExpandLabelClickActionType_Label,CGSizeMake(self.width, self.textHeight));
    }
}

///  创建折叠文本
- (void)createFoldAttr:(NSAttributedString *)originAttr{
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.maxWidth, UIScreen.mainScreen.bounds.size.height), nil);
//    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:originAttr];
//    [attributed tmui_setAttribute:NSParagraphStyleAttributeName value:self.style];
    // CTFrameRef
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)originAttr);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, originAttr.length), path, NULL);
    
    // CTLines
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    
    // CTLine Origins
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    CGFloat totalHeight = 0;
    
    NSMutableAttributedString *foldAttrString = [NSMutableAttributedString new];
    NSInteger numberOfLines = self.numberOfLines;
    // 拼接每一行
    for (int i = 0; i < numberOfLines; i++) {
        //获取行
        CTLineRef line = (__bridge CTLineRef)lines[i];
        //获取该行的在整个attributed的范围
        CFRange range = CTLineGetStringRange(line);
        //截取这一行的text
        NSAttributedString *lineAttr = [originAttr attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        if (i != numberOfLines - 1) {
            // 不是最后一行
                [foldAttrString appendAttributedString:lineAttr];
                totalHeight += [self heightForCTLine:line];
                totalHeight += self.style.lineSpacing; // 前面需要多加行高
        }else{
            // 是限制的最后一行
            NSMutableAttributedString *lastLineAttr = (NSMutableAttributedString*)lineAttr;
            //            if ([drawAttr.string hasSuffix:@"\n"]) { // 剔除结尾有换行的情况
            //                [drawAttr deleteCharactersInRange:NSMakeRange(drawAttr.string.length - 1, 1)];
            //            }
            for (int j = 0; j < lastLineAttr.length; j++) {
                //所限制的最后一行的内容 + "... 展开" 处理刚刚只显示成一行内容 如果不只一行 一个一个字符的减掉到只有一行为止
                NSMutableAttributedString *lastAppendAttr = [[NSMutableAttributedString alloc] initWithAttributedString:[lastLineAttr attributedSubstringFromRange:NSMakeRange(0, lastLineAttr.length-j)]];
                
                [lastAppendAttr appendAttributedString:self.foldClickString];
                //内容是否是只有一行
                NSInteger number = [self numberOfLinesForAttributtedText:lastAppendAttr];
                if (number == 1) {
                    [foldAttrString appendAttributedString:lastAppendAttr];
                    
                    CTLineRef lastLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)lastAppendAttr);
                    CGSize lastLineSize = CTLineGetBoundsWithOptions(lastLine, 0).size;
                    
                    CTLineRef expandLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.foldClickString);
                    CGSize expandSize = CTLineGetBoundsWithOptions(expandLine, 0).size;
                    
                    
                    self.clickArea = CGRectMake(lastLineSize.width - expandSize.width, totalHeight, expandSize.width, expandSize.height);
                    //                    [self addDebugView:totalHeight];
                    totalHeight += [self heightForCTLine:line];
                    
                    CFRelease(expandLine);
                    break;
                }
            }
        }
        CFRelease(line);
    }
    self.foldHeight = ceil(totalHeight); // 这里需要向上取整，避免显示不全
    self.foldAttrString = foldAttrString;
//    _attrType = TMUIExpandLabelAttrType_Shrink;
    // 避免重复走一遍逻辑
//    [self setAttributedText:drawAttributedText];
//    !_sizeChangeBlock?:_sizeChangeBlock(TMUIExpandLabelClickActionType_Shrink,CGSizeMake(self.width, totalHeight));
//    CFRelease(ctFrame);  // 释放会crash
    CFRelease(setter);
    CFRelease(path);
}

/// 创建展开文本
- (void)createUnfoldAttr:(NSAttributedString *)originAttr{
    NSAttributedString *foldClickAttr = self.foldClickString;
    // 需要拼接 ”展开“
    NSMutableAttributedString *unfoldAttr = [[NSMutableAttributedString alloc] initWithAttributedString:originAttr];
    [unfoldAttr appendAttributedString:foldClickAttr];
    
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)unfoldAttr);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.maxWidth, UIScreen.mainScreen.bounds.size.height), nil);
    // CTFrameRef
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, unfoldAttr.length), path, NULL);
    // CTLines
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    CGFloat totalHeight = 0;
    
    for (int i = 0; i < lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        if (i < lines.count - 1) {
//            [self addDebugView:totalHeight];
            // 前面几行
            totalHeight += [self heightForCTLine:line];
        }else if (i == lines.count - 1) {
            // 最后一行
            NSArray *runs = (NSArray*)CTLineGetGlyphRuns(line);
            CGFloat x = 0;
            for (int i = 0; i < runs.count - 1; i++) {
                CTRunRef run = (__bridge CTRunRef)runs[i];
                x += CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
            }
            
            CTLineRef moreLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)foldClickAttr);
            CGSize moreSize = CTLineGetBoundsWithOptions(moreLine, 0).size;
            self.clickArea = CGRectMake(x, totalHeight, moreSize.width, moreSize.height);
//            [self addDebugView:totalHeight];
//            if (self.isNewLine) {
//                totalHeight += moreSize.height;
//            }
            CFRelease(moreLine);
        }
    }
    
    self.unfoldHeight = ceil(totalHeight);
    self.unfoldAttrString = unfoldAttr;
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(setter);
}


- (NSAttributedString *)foldClickString{
    if (!_foldClickString) {
        NSMutableAttributedString *foldClickString = [[NSMutableAttributedString alloc] initWithString:@"... " attributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.textColor}];
         NSAttributedString  *foldString = [[NSAttributedString alloc] initWithString:@"展开" attributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.foldColor}];
         [foldClickString appendAttributedString:foldString];
        _foldClickString = foldClickString;
    }
    return _foldClickString;
}

#pragma mark - Private
/** 计算text的行数 */
-(NSInteger)numberOfLinesForAttributtedText:(NSAttributedString*)text {
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.maxWidth, UIScreen.mainScreen.bounds.size.height), nil);
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, text.length), path, nil);
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    CFRelease(ctFrame);
    CFRelease(setter);
    CFRelease(path);
    return lines.count;
}

- (CGFloat)heightForCTLine:(CTLineRef)line{
    CGFloat h = 0;
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    h = MAX(h, ascent + descent + leading);
    return h;
}


#pragma mark - Super
- (CGSize)intrinsicContentSize{
    if (self.numberOfLines == 0 || self.numberOfLinesEnoughShowAllContents) {
        return [super intrinsicContentSize];
    }
    if (self.isFold) {
        return CGSizeMake(self.maxWidth, self.foldHeight);
    }else{
        return CGSizeMake(self.maxWidth, self.unfoldHeight);
    }
}

@end
