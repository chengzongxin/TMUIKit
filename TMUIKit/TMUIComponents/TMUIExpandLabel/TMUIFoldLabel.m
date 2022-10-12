//
//  TMUIFoldLabel.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/3/24.
//

#import "TMUIFoldLabel.h"
#import <CoreText/CoreText.h>
#import "NSAttributedString+TMUI.h"
#import "TMUICore.h"
@interface TMUIFoldLabel ()

/// 原始富文本
@property (nonatomic, strong) NSAttributedString *originAttr;
/// 原始行数
@property (nonatomic, assign) NSInteger originNumberOfLine;
/// 段落样式
@property (nonatomic, strong) NSMutableParagraphStyle *style;

@property (nonatomic, strong) NSAttributedString *foldAttrString;
@property (nonatomic, strong) NSAttributedString *unfoldAttrString;

@property (nonatomic, strong) NSAttributedString *foldClickString;
@property (nonatomic, strong) NSAttributedString *unfoldClickString;

@property (nonatomic, assign) CGRect clickFoldArea;
@property (nonatomic, assign) CGRect clickUnfoldArea;

@property (nonatomic, assign) CGFloat foldHeight;
@property (nonatomic, assign) CGFloat unfoldHeight;

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
    self.isAutoRefreshContentWhenClickFold = YES;
    self.foldColor = TMUIColorHex(2C82EC);
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)]];
}

+ (CGSize)sizeForAttr:(NSAttributedString *)attr line:(NSInteger)line width:(CGFloat)width{
    TMUIFoldLabel *label = [[TMUIFoldLabel alloc] init];
    label.numberOfLines = line;
    label.maxWidth = width;
    label.attributedText = attr;
    return [label sizeForFits];
}

- (CGSize)sizeForFits{
    return [self sizeThatFits:CGSizeMake(self.maxWidth, CGFLOAT_MAX)];
}


/// 最初设置富文本处于收起状态
- (void)setAttributedText:(NSAttributedString *)attributedText{
    _originAttr = attributedText;
    
    // 重置，以免在cell中复用出问题
    _foldAttrString = nil;
    _unfoldAttrString = nil;
    
    // 初始设置，会影响后面创建富文本
    self.font = attributedText.tmui_font;
    self.textColor = attributedText.tmui_color;
    self.style = attributedText.tmui_paragraphStyle;
    
    NSInteger lineCount = [self numberOfLinesForAttributtedText:attributedText];
    
    if (self.numberOfLines == 0 || lineCount <= self.numberOfLines) {
        self.isFold = NO;
    }else{
        self.isFold = YES;
        self.originNumberOfLine = self.numberOfLines;
    }
    
    NSAttributedString *attrStr = self.isFold ? self.foldAttrString : self.unfoldAttrString;
    [super setAttributedText:attrStr];
}

#pragma mark - Action
/// 点击了展开文本后，显示展开文本
- (void)tapLabel:(UITapGestureRecognizer *)tap{
    CGPoint tapPoint = [tap locationInView:self];
    NSLog(@"%@--%@--%@",NSStringFromCGPoint(tapPoint),NSStringFromCGRect(_clickFoldArea),NSStringFromCGRect(_clickUnfoldArea));
    CGRect clickArea = self.isFold ? _clickFoldArea : _clickUnfoldArea;
    if (CGRectContainsPoint(clickArea, tapPoint)) {
        // 点击展开
        if (self.isFold == YES) {
            self.isFold = NO;
            if (self.isAutoRefreshContentWhenClickFold) {
                self.numberOfLines = 0;
                [super setAttributedText:self.unfoldAttrString];
            }
        }else{
            // 点击收起
            self.isFold = YES;
            if (self.isAutoRefreshContentWhenClickFold) {
                self.numberOfLines = self.originNumberOfLine;
                [super setAttributedText:self.foldAttrString];
            }
        }
        
        !_clickFold ?: _clickFold(self.isFold,self);
    }else{
        // 没有点击在展开收起
        !_clickText ?: _clickText(self.isFold,self);
    }
}

///  创建折叠文本
- (void)createFoldAttr:(NSAttributedString *)originAttr{
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.maxWidth, CGFLOAT_MAX), nil);
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
        CGFloat lineHeight = [self heightForCTLine:line];
        CGFloat lineSpace = self.style.lineSpacing;
        //截取这一行的text
        NSAttributedString *lineAttr = [originAttr attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        if (i != numberOfLines - 1) {
            // 不是最后一行
                [foldAttrString appendAttributedString:lineAttr];
                totalHeight += lineSpace; // 前面需要多加行高
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
                    
                    
                    self.clickFoldArea = CGRectMake(lastLineSize.width - expandSize.width, totalHeight, expandSize.width, expandSize.height);
                    //                    [self addDebugView:totalHeight];
                    CFRelease(expandLine);
                    break;
                }
            }
        }
        totalHeight += lineHeight;
        CFRelease(line);
    }
    _foldHeight = ceil(totalHeight); // 这里需要向上取整，避免显示不全
    _foldAttrString = foldAttrString;
    
//    CFRelease(ctFrame);  // 释放会crash
    CFRelease(setter);
    CFRelease(path);
}

/// 创建展开文本
- (void)createUnfoldAttr:(NSAttributedString *)originAttr{
    // 需要拼接 ”展开“
    NSMutableAttributedString *unfoldAttrString = [[NSMutableAttributedString alloc] init];
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)originAttr);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.maxWidth, CGFLOAT_MAX), nil);
    // CTFrameRef
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, originAttr.length), path, NULL);
    // CTLines
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    CGFloat totalHeight = 0;
    
    for (int i = 0; i < lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CGFloat lineHeight = [self heightForCTLine:line];
        CGFloat lineSpace = self.style.lineSpacing;
        CFRange range = CTLineGetStringRange(line);
        NSAttributedString *lineAttr = [originAttr attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        [unfoldAttrString appendAttributedString:lineAttr];
        if (i < lines.count - 1) {
            totalHeight += lineSpace;
        }else if (i == lines.count - 1) {
            // 最后一行
            
//            if (self.type == TMUIFoldLabelType_ShowFoldAndUnfold) {
//                [unfoldAttrString appendAttributedString:self.unfoldClickString];
//            }
            
            if (self.type == TMUIFoldLabelType_ShowFoldAndUnfold) {
                
                
                NSMutableAttributedString *lastAttr = [lineAttr mutableCopy];
//                [lastAttr appendAttributedString:self.unfoldAttrString];
                
                if ([self numberOfLinesForAttributtedText:lastAttr] > 1) {
                    
                }
                
                [unfoldAttrString appendAttributedString:self.unfoldClickString];
                
                
                // 获取收起点击位置
                NSArray *runs = (NSArray*)CTLineGetGlyphRuns(line);
                CGFloat x = 0;
                for (int i = 0; i < runs.count - 1; i++) {
                    CTRunRef run = (__bridge CTRunRef)runs[i];
                    x += CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
                }
                CTLineRef moreLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.unfoldClickString);
                CGSize moreSize = CTLineGetBoundsWithOptions(moreLine, 0).size;
                self.clickUnfoldArea = CGRectMake(x, totalHeight, moreSize.width, moreSize.height);
                
                CFRelease(moreLine);
                //            [self addDebugView:self.clickUnfoldArea];
                //            if (self.isNewLine) {
                //                totalHeight += moreSize.height;
                //            }
            }
            
        }
        
        totalHeight += lineHeight;
    }
    
    _unfoldHeight = ceil(totalHeight);
    _unfoldAttrString = unfoldAttrString;
    
    CFRelease(ctFrame);
    CFRelease(path);
    CFRelease(setter);
}

- (void)addDebugView:(CGRect)frame{
    UIView *view = [UIView new];
    view.frame = frame;
    view.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.3];
    [self addSubview:view];
}

- (CGFloat)foldHeight{
    if (!_foldHeight) {
        [self createFoldAttr:self.originAttr];
    }
    return _foldHeight;
}

- (CGFloat)unfoldHeight{
    if (!_unfoldHeight) {
        [self createUnfoldAttr:self.originAttr];
    }
    return _unfoldHeight;
}

// 这里如果用懒加载会引起问题，因为在cell中会有重用机制
- (NSAttributedString *)foldAttrString{
    if (!_foldAttrString) {
        [self createFoldAttr:self.originAttr];
    }
    return _foldAttrString;
}

// 这里如果用懒加载会引起问题，因为在cell中会有重用机制
- (NSAttributedString *)unfoldAttrString{
    if (!_unfoldAttrString) {
        [self createUnfoldAttr:self.originAttr];
    }
    return _unfoldAttrString;
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

- (NSAttributedString *)unfoldClickString{
    if (!_unfoldClickString) {
        _unfoldClickString = [[NSAttributedString alloc] initWithString:@"收起" attributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:self.foldColor}];
    }
    return _unfoldClickString;
}

#pragma mark - Private
/** 计算text的行数 */
- (NSInteger)numberOfLinesForAttributtedText:(NSAttributedString*)text {
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, self.maxWidth, CGFLOAT_MAX), nil);
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
//    if (self.numberOfLines == 0 && self.unfoldHeight) {
//        return CGSizeMake(self.maxWidth, self.unfoldHeight);
//    }
//
//    if (self.numberOfLines == 0 || self.numberOfLinesEnoughShowAllContents) {
//        return [super intrinsicContentSize];
//    }
    if (self.isFold) {
        CGSize size = [self sizeThatFits:CGSizeMake(self.maxWidth, self.foldHeight)];
        return size;
    }else{
        CGSize size =  [self sizeThatFits:CGSizeMake(self.maxWidth, self.unfoldHeight)];
        return size;
    }
}

@end
