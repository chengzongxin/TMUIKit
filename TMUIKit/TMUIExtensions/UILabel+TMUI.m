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
#import "NSAttributedString+TMUI.h"
//#import "TMUIAssociatedObjectDefine.h"
#import <TMUIAssociatedPropertyDefines.h>
#import "UIView+TMUI.h"


@interface TMUILinkGestureRegcognizer : UIGestureRecognizer <UIGestureRecognizerDelegate>
@end

@implementation TMUILinkGestureRegcognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateCancelled;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

@end


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

- (CGSize)tmui_sizeWithWidth:(CGFloat)width{
    if (width == 0) {
        width = self.width;
    }
    // NSString 计算
    CGSize size1 = [self.text tmui_sizeForFont:self.font
                                          size:CGSizeMake(width, HUGE)
                                    lineHeight:self.tmui_attributeTextLineHeight
                                          mode:self.lineBreakMode];
    // NSAttributionStirng 计算
    CGSize size2 = [self.attributedText tmui_sizeForWidth:width];
    
    return CGSizeMake(MAX(size1.width, size2.width), MAX(size1.height, size2.height));
}

@end



@implementation UILabel (TMUI_AttributeText)

- (void)tmui_setAttributesText:(NSString *)text lineSpacing:(CGFloat)lineSpacing{
    CGFloat height = [NSAttributedString tmui_heightForAtsWithStr:text font:self.font width:self.frame.size.width lineH:lineSpacing];
    self.attributedText = [NSAttributedString tmui_atsForStr:text lineHeight:(height<self.font.pointSize*2+lineSpacing)?0:lineSpacing];
    self.numberOfLines = 0;
}

- (void)tmui_setAttributesText:(NSString *)text color:(UIColor *)color font:(UIFont *)font{
    NSRange range = [[self.attributedText string] rangeOfString:text];
    if(range.location != NSNotFound && range.length) {
        // 找到对应的字段
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        [mat addAttributes:@{NSFontAttributeName:font} range:range];
        self.attributedText = mat;
    }else{
        // 没有，在后面追加
        NSRange range = NSMakeRange(0, text.length);
        NSMutableAttributedString *appendAtr = [[NSMutableAttributedString alloc] initWithString:text];
        [appendAtr addAttributes:@{NSForegroundColorAttributeName:color} range:range];
        [appendAtr addAttributes:@{NSFontAttributeName:font} range:range];
        NSMutableAttributedString *mat = [self.attributedText mutableCopy] ?: [[NSMutableAttributedString alloc] init];
        [mat appendAttributedString:appendAtr];
        self.attributedText = mat;
    }
}

- (void)tmui_setAttributeslineSpacing:(CGFloat)lineSpacing{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = lineSpacing;
        [mat addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:range];
        self.attributedText = mat;
    }
}

- (void)tmui_setAttributesLineOffset:(CGFloat)lineOffset{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSBaselineOffsetAttributeName: @(lineOffset)} range:range];
        self.attributedText = mat;
    }
}


- (void)tmui_setAttributesLineSingle{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        self.attributedText = mat;
    }
}

- (void)tmui_setAttributesUnderLink{
    NSRange range = NSMakeRange(0, [self.attributedText string].length);
    if(range.location != NSNotFound) {
        NSMutableAttributedString *mat = [self.attributedText mutableCopy];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:range];
        self.attributedText = mat;
    }
}

@end

@interface UILabel (TMUI_AttributeAction)

@property(nonatomic, strong) NSMutableArray *tmui_attributeStrings;
@property(nonatomic, strong) NSMutableDictionary *tmui_effectDic;
@property(nonatomic, assign) BOOL tmui_isClickAction;
@property(nonatomic, assign) BOOL tmui_isClickEffect;
@property(nonatomic, copy) void (^tmui_clickBlock)(NSString *, NSRange, NSInteger);
@property(nonatomic, weak) id<TMUIAttrTextDelegate> tmui_delegate;

@end


@implementation UILabel (TMUI_AttributeAction)

#pragma mark - AssociatedObjects

// MARK: Publick Properties
TMUISynthesizeBOOLProperty(tmui_enabledClickEffect, setTmui_enabledClickEffect);
TMUISynthesizeCGPointProperty(tmui_enlargeClickArea,setTmui_enlargeClickArea);
- (UIColor *)tmui_clickEffectColor {
    UIColor *obj = objc_getAssociatedObject(self, _cmd);
    if(obj == nil) {obj = [UIColor lightGrayColor];}
    return obj;
}

- (void)setTmui_clickEffectColor:(UIColor *)clickEffectColor {
    objc_setAssociatedObject(self, @selector(tmui_clickEffectColor), clickEffectColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// MARK: Private Properties
TMUISynthesizeIdStrongProperty(tmui_attributeStrings, setTmui_attributeStrings);
TMUISynthesizeIdStrongProperty(tmui_effectDic, setTmui_effectDic);
TMUISynthesizeBOOLProperty(tmui_isClickAction, setTmui_isClickAction);
TMUISynthesizeBOOLProperty(tmui_isClickEffect, setTmui_isClickEffect);
TMUISynthesizeIdCopyProperty(tmui_clickBlock, setTmui_clickBlock);
TMUISynthesizeIdWeakProperty(tmui_delegate, setTmui_delegate);


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
    [self tmui_removeAttributeAction];
    self.userInteractionEnabled = YES;
    
    id reg = [[TMUILinkGestureRegcognizer alloc] initWithTarget:self action:@selector(tmui_handleLinkGesture:)];
    [self addGestureRecognizer:reg];
    
    [self attrTextRangesWithStrings:strings attributes:attributes];
    if (self.tmui_clickBlock != clickAction) {
        self.tmui_clickBlock = clickAction;
    }
    if ([self tmui_delegate] != delegate) {
        [self setTmui_delegate:delegate];
    }
}

- (void)tmui_handleLinkGesture:(UIPanGestureRecognizer *)reg {
    if (reg.state == UIGestureRecognizerStateBegan) {
        if (!self.tmui_isClickAction) {
            return;
        }

        if (objc_getAssociatedObject(self, @selector(tmui_enabledClickEffect))) {
            self.tmui_isClickEffect = self.tmui_enabledClickEffect;
        }

        CGPoint point = [reg locationInView:self];

        __weak __typeof(self)weakSelf = self;
        [self attrTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (strongSelf.tmui_clickBlock) {
                strongSelf.tmui_clickBlock (string , range , index);
            }

            if ([strongSelf tmui_delegate] && [[strongSelf tmui_delegate] respondsToSelector:@selector(didClickAttrText:range:index:)]) {
                [[strongSelf tmui_delegate] didClickAttrText:string range:range index:index];
            }

            if (strongSelf.tmui_isClickEffect) {
                [strongSelf saveEffectDicWithRange:range];
                [strongSelf clickEffectWithStatus:YES];
            }
        }];
        
        
    } else if (reg.state == UIGestureRecognizerStateChanged) {

    } else if (reg.state == UIGestureRecognizerStateEnded || reg.state == UIGestureRecognizerStateCancelled) {
        
        if (!self.tmui_isClickAction) {
            return;
        }
        if (self.tmui_isClickEffect) {
            [self performSelectorOnMainThread:@selector(clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
        }

        CGPoint point = [reg locationInView:self];

        [self attrTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        }];
        
    }
}

- (void)tmui_removeAttributeAction{
    self.tmui_enabledClickEffect = NO;
    self.tmui_enlargeClickArea = CGPointZero;
    self.tmui_isClickAction = NO;
    self.tmui_isClickEffect = NO;
    self.tmui_clickBlock = nil;
    self.tmui_delegate = nil;
    self.tmui_attributeStrings = [NSMutableArray array];
    self.tmui_effectDic = nil;
    [self removeLinkGes];
}

- (void)removeLinkGes{
    NSMutableArray *gesArr = [NSMutableArray array];
    for (UIGestureRecognizer *ges in self.gestureRecognizers) {
        if ([ges isKindOfClass:TMUILinkGestureRegcognizer.class]) {
            [gesArr addObject:ges];;
        }
    }
    
    for (UIGestureRecognizer *ges in gesArr) {
        [self removeGestureRecognizer:ges];
    }
    
}

#pragma mark - touchAction
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (!self.tmui_isClickAction) {
//        [super touchesBegan:touches withEvent:event];
//        return;
//    }
//
//    if (objc_getAssociatedObject(self, @selector(tmui_enabledClickEffect))) {
//        self.tmui_isClickEffect = self.tmui_enabledClickEffect;
//    }
//
//    UITouch *touch = [touches anyObject];
//
//    CGPoint point = [touch locationInView:self];
//
//    __weak __typeof(self)weakSelf = self;
//    BOOL ret = [self attrTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//
//        if (strongSelf.tmui_clickBlock) {
//            strongSelf.tmui_clickBlock (string , range , index);
//        }
//
//        if ([strongSelf tmui_delegate] && [[strongSelf tmui_delegate] respondsToSelector:@selector(didClickAttrText:range:index:)]) {
//            [[strongSelf tmui_delegate] didClickAttrText:string range:range index:index];
//        }
//
//        if (strongSelf.tmui_isClickEffect) {
//            [strongSelf saveEffectDicWithRange:range];
//            [strongSelf clickEffectWithStatus:YES];
//        }
//    }];
//
//    if (!ret) {
//        [super touchesBegan:touches withEvent:event];
//    }
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (!self.tmui_isClickAction) {
//        [super touchesEnded:touches withEvent:event];
//        return;
//    }
//    if (self.tmui_isClickEffect) {
//        [self performSelectorOnMainThread:@selector(clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
//    }
//    UITouch *touch = [touches anyObject];
//
//    CGPoint point = [touch locationInView:self];
//
//    BOOL ret = [self attrTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
//    }];
//
//    if (!ret) {
//        [super touchesEnded:touches withEvent:event];
//    }
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (!self.tmui_isClickAction) {
//        [super touchesEnded:touches withEvent:event];
//        return;
//    }
//    if (self.tmui_isClickEffect) {
//        [self performSelectorOnMainThread:@selector(clickEffectWithStatus:) withObject:nil waitUntilDone:NO];
//    }
//    UITouch *touch = [touches anyObject];
//
//    CGPoint point = [touch locationInView:self];
//
//    BOOL ret = [self attrTextFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
//    }];
//
//    if (!ret) {
//        [super touchesCancelled:touches withEvent:event];
//    }
//}
//
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *subview;
//    if (self.subviews.count) {
//        subview = [super hitTest:point withEvent:event];
//    }
//    // 有subview时返回subview， 不拦截subview事件
//    if (subview) {
//        return subview;
//    }
//
//    if((self.tmui_isClickAction) && ([self attrTextFrameWithTouchPoint:point result:nil])) {
//        return self;
//    }
//    return [super hitTest:point withEvent:event];
//}

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
    
    CGFloat maxY = 0;

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

        rect.origin.y = maxY;
        maxY = maxY + rect.size.height + lineSpace;
        // 增加点击区域
        CGRect largeRect = CGRectInset(rect, self.tmui_enlargeClickArea.x, self.tmui_enlargeClickArea.y);
        rect = CGRectIsValidated(largeRect) ? largeRect : rect;

        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            if (offset > relativePoint.x) {
                index = index - 1;
            }

            NSInteger link_count = self.tmui_attributeStrings.count;
            for (int j = 0; j < link_count; j++) {
                TMAttrTextModel *model = self.tmui_attributeStrings[j];
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


- (CGAffineTransform)transformForCoreText {
    return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
}


- (CGFloat)aNewlineHeight{
    UIFont *font = [self.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil]?:self.font;
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font}];
    CTLineRef newline = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CTLineGetTypographicBounds(newline, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent);
    return height;
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + fabs(descent);

    CGFloat nlHeight = [self aNewlineHeight];
    
    height = MAX(height, nlHeight);
    
    return CGRectMake(point.x, point.y , width, height);
}

#pragma mark - clickEffect
- (void)clickEffectWithStatus:(BOOL)status {
    if (self.tmui_isClickEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.tmui_effectDic allValues] firstObject]];
        NSRange range = NSRangeFromString([[self.tmui_effectDic allKeys] firstObject]);
        //TMUI: 处理因换行符导致range越界问题
        if (range.location > attStr.length - 1 - range.length) {
            range.location = attStr.length - 1 - range.length;
        }
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName value:self.tmui_clickEffectColor range:NSMakeRange(0, subAtt.string.length)];
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }else {
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)saveEffectDicWithRange:(NSRange)range {
    self.tmui_effectDic = [NSMutableDictionary dictionary];
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    [self.tmui_effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

#pragma mark - getRange
- (void)attrTextRangesWithStrings:(NSArray <NSString *> *)strings attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes{
    if (self.attributedText == nil) {
        self.tmui_isClickAction = NO;
        return;
    }

    self.tmui_isClickAction = YES;
    self.tmui_isClickEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.tmui_attributeStrings = [NSMutableArray array];

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
            [strongSelf.tmui_attributeStrings addObject:model];
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
