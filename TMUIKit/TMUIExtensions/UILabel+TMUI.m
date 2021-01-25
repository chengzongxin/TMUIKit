//
//  UILabel+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import "UILabel+TMUI.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import "TMUICommonDefines.h"


@interface TMAttrTextModel : NSObject
@property (nonatomic, copy) NSString *str;
@property (nonatomic, assign) NSRange range;
@end

@implementation TMAttrTextModel
@end

@implementation UILabel (TMUI)

- (instancetype)tmui_initWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    BeginIgnoreClangWarning(-Wunused-value)
    [self init];
    EndIgnoreClangWarning
    self.font = font;
    self.textColor = textColor;
    return self;
}

- (CGFloat)tmui_attributeTextLineHeight{
    return [(NSMutableParagraphStyle *)[self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil] lineSpacing];
}

@end



@implementation UILabel (TMUI_AttributeText)


- (void)tmui_addAttributesText:(NSString *)text color:(UIColor *)color font:(UIFont *)font{
    NSRange range = [[self.attributedText string] rangeOfString:text];
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        [mat addAttributes:@{NSFontAttributeName:font} range:range];
        self.attributedText = mat;
    }
}

- (void)tmui_addAttributeslineSpacing:(CGFloat)lineSpacing{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = lineSpacing;
        [mat addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:range];
        self.attributedText = mat;
    }
}

- (void)tmui_addAttributesLineOffset:(CGFloat)lineOffset{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSBaselineOffsetAttributeName: @(lineOffset)} range:range];
        self.attributedText = mat;
    }
}


- (void)tmui_addAttributesLineSingle{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        self.attributedText = mat;
    }
}

- (void)tmui_addAttributesUnderLink{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        self.attributedText = mat;
    }
}

@end



@implementation UILabel (TMUI_AttributeAction)

#pragma mark - AssociatedObjects
- (NSMutableArray *)attributeStrings {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttributeStrings:(NSMutableArray *)attributeStrings {
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)effectDic {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEffectDic:(NSMutableDictionary *)effectDic {
    objc_setAssociatedObject(self, @selector(effectDic), effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isClickAction {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsClickAction:(BOOL)isClickAction {
    objc_setAssociatedObject(self, @selector(isClickAction), @(isClickAction), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(NSString *, NSRange, NSInteger))clickBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setClickBlock:(void (^)(NSString *, NSRange, NSInteger))clickBlock {
    objc_setAssociatedObject(self, @selector(clickBlock), clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id<TMUIAttrTextDelegate>)delegate {
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)enabledClickEffect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setEnabledClickEffect:(BOOL)enabledClickEffect {
    objc_setAssociatedObject(self, @selector(enabledClickEffect), @(enabledClickEffect), OBJC_ASSOCIATION_ASSIGN);
    //    self.isClickEffect = enabledClickEffect;
}

- (UIColor *)clickEffectColor {
    UIColor *obj = objc_getAssociatedObject(self, _cmd);
    if(obj == nil) {obj = [UIColor lightGrayColor];}
    return obj;
}

- (void)setClickEffectColor:(UIColor *)clickEffectColor {
    objc_setAssociatedObject(self, @selector(clickEffectColor), clickEffectColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isClickEffect {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsClickEffect:(BOOL)isClickEffect {
    objc_setAssociatedObject(self, @selector(isClickEffect), @(isClickEffect), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setDelegate:(id<TMUIAttrTextDelegate>)delegate {
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - mainFunction
- (void)tmui_clickAttrTextWithStrings:(NSArray<NSString *> *)strings clickAction:(void (^)(NSString *string, NSRange range, NSInteger index))clickAction {
    [self tmui_clickAttrTextWithStrings:strings attributes:nil delegate:nil clickAction:clickAction];
}

- (void)tmui_clickAttrTextWithStrings:(NSArray<NSString *> *)strings attributes:(nullable NSDictionary *)attributes clickAction:(nonnull void (^)(NSString * _Nonnull, NSRange, NSInteger))clickAction{
    [self tmui_clickAttrTextWithStrings:strings attributes:attributes delegate:nil clickAction:clickAction];
}

- (void)tmui_clickAttrTextWithStrings:(NSArray<NSString *> *)strings delegate:(id<TMUIAttrTextDelegate>)delegate {
    [self tmui_clickAttrTextWithStrings:strings attributes:nil delegate:delegate clickAction:nil];
}

- (void)tmui_clickAttrTextWithStrings:(NSArray<NSString *> *)strings attributes:(nullable NSDictionary *)attributes delegate:(nonnull id<TMUIAttrTextDelegate>)delegate{
    [self tmui_clickAttrTextWithStrings:strings attributes:attributes delegate:delegate clickAction:nil];
}

- (void)tmui_clickAttrTextWithStrings:(NSArray<NSString *> *)strings attributes:(nullable NSDictionary *)attributes delegate:(nullable id<TMUIAttrTextDelegate>)delegate clickAction:(nullable void (^)(NSString * _Nonnull, NSRange, NSInteger))clickAction{
    [self attrTextRangesWithStrings:strings attributes:attributes];
    if (self.clickBlock != clickAction) {
        self.clickBlock = clickAction;
    }
    if ([self delegate] != delegate) {
        [self setDelegate:delegate];
    }
}

#pragma mark - touchAction
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isClickAction) {
        return;
    }

    if (objc_getAssociatedObject(self, @selector(enabledClickEffect))) {
        self.isClickEffect = self.enabledClickEffect;
    }

    UITouch *touch = [touches anyObject];

    CGPoint point = [touch locationInView:self];

    __weak __typeof(self)weakSelf = self;
    [self attrTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf.clickBlock) {
            strongSelf.clickBlock (string , range , index);
        }

        if ([strongSelf delegate] && [[strongSelf delegate] respondsToSelector:@selector(didClickAttrText:range:index:)]) {
            [[strongSelf delegate] didClickAttrText:string range:range index:index];
        }

        if (strongSelf.isClickEffect) {
            [strongSelf saveEffectDicWithRange:range];
            [strongSelf clickEffectWithStatus:YES];
        }
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if((self.isClickAction) && ([self attrTextFrameWithTouchPoint:point result:nil])) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - getClickFrame
- (BOOL)attrTextFrameWithTouchPoint:(CGPoint)point result:(void (^) (NSString *string , NSRange range , NSInteger index))resultBlock {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    CFRange range = CTFrameGetVisibleStringRange(frame);

    if (self.attributedText.length > range.length) {
        UIFont *font ;
        if ([self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]) {
            font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
        }else if (self.font){
            font = self.font;
        }else {
            font = [UIFont systemFontOfSize:17];
        }

        CGPathRelease(Path);
        Path = CGPathCreateMutable();
        CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + font.lineHeight));
        frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    }

    CFArrayRef lines = CTFrameGetLines(frame);

    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }

    CFIndex count = CFArrayGetCount(lines);
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    CGAffineTransform transform = [self transformForCoreText];
    CGFloat verticalOffset = 0;

    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        rect = CGRectInset(rect, 0, 0);
        rect = CGRectOffset(rect, 0, verticalOffset);
        NSParagraphStyle *style = [self.attributedText attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        CGFloat lineSpace;
        if (style) {
            lineSpace = style.lineSpacing;
        }else {
            lineSpace = 0;
        }

        CGFloat lineOutSpace = (self.bounds.size.height - lineSpace * (count - 1) -rect.size.height * count) / 2;
        rect.origin.y = lineOutSpace + rect.size.height * i + lineSpace * i;
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            if (offset > relativePoint.x) {
                index = index - 1;
            }

            NSInteger link_count = self.attributeStrings.count;
            for (int j = 0; j < link_count; j++) {
                TMAttrTextModel *model = self.attributeStrings[j];
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.str , model.range , (NSInteger)j);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isClickEffect) {
        [self performSelectorOnMainThread:@selector(clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isClickEffect) {
        [self performSelectorOnMainThread:@selector(clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
}

- (CGAffineTransform)transformForCoreText {
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent) + leading;

    return CGRectMake(point.x, point.y , width, height);
}

#pragma mark - clickEffect
- (void)clickEffectWithStatus:(BOOL)status {
    if (self.isClickEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.effectDic allValues] firstObject]];
        NSRange range = NSRangeFromString([[self.effectDic allKeys] firstObject]);
        //TMUI: 处理因换行符导致range越界问题
        if (range.location > attStr.length - 1 - range.length) {
            range.location = attStr.length - 1 - range.length;
        }
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.clickEffectColor range:NSMakeRange(0, subAtt.string.length)];
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)saveEffectDicWithRange:(NSRange)range {
    self.effectDic = [NSMutableDictionary dictionary];
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    [self.effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange
- (void)attrTextRangesWithStrings:(NSArray <NSString *> *)strings attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes{
    if (self.attributedText == nil) {
        self.isClickAction = NO;
        return;
    }

    self.isClickAction = YES;
    self.isClickEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];

    __weak __typeof(self)weakSelf = self;
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSRange range = [totalStr rangeOfString:obj];
        if (range.length != 0) {
            totalStr = [totalStr stringByReplacingCharactersInRange:range withString:[strongSelf getStringWithRange:range]];
            if (attributes) {
                NSMutableAttributedString *originAttributedString = self.attributedText.mutableCopy;
                [originAttributedString addAttributes:attributes range:range];
                self.attributedText = originAttributedString;
            }
            TMAttrTextModel *model = [[TMAttrTextModel alloc]init];
            model.range = range;
            model.str = obj;
            [strongSelf.attributeStrings addObject:model];
        }
    }];
}

- (NSString *)getStringWithRange:(NSRange)range {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}

@end
