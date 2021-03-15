//
//  UITextView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import "UITextView+TMUI.h"
#import "TMUICore.h"
#import <objc/runtime.h>

@implementation UITextView (TMUI)


- (NSRange)tmui_convertNSRangeFromUITextRange:(UITextRange *)textRange {
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.start];
    NSInteger length = [self offsetFromPosition:textRange.start toPosition:textRange.end];
    return NSMakeRange(location, length);
}

- (UITextRange *)tmui_convertUITextRangeFromNSRange:(NSRange)range {
    if (range.location == NSNotFound || NSMaxRange(range) > self.text.length) {
        return nil;
    }
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    return [self textRangeFromPosition:startPosition toPosition:endPosition];
}

- (void)tmui_setTextKeepingSelectedRange:(NSString *)text {
    UITextRange *selectedTextRange = self.selectedTextRange;
    self.text = text;
    self.selectedTextRange = selectedTextRange;
}

- (void)tmui_setAttributedTextKeepingSelectedRange:(NSAttributedString *)attributedText {
    UITextRange *selectedTextRange = self.selectedTextRange;
    self.attributedText = attributedText;
    self.selectedTextRange = selectedTextRange;
}

- (void)tmui_scrollRangeToVisible:(NSRange)range {
    if (CGRectIsEmpty(self.bounds)) return;
    
    UITextRange *textRange = [self tmui_convertUITextRangeFromNSRange:range];
    if (!textRange) return;
    
    NSArray<UITextSelectionRect *> *selectionRects = [self selectionRectsForRange:textRange];
    CGRect rect = CGRectZero;
    for (UITextSelectionRect *selectionRect in selectionRects) {
        if (!CGRectIsEmpty(selectionRect.rect)) {
            if (CGRectIsEmpty(rect)) {
                rect = selectionRect.rect;
            } else {
                rect = CGRectUnion(rect, selectionRect.rect);
            }
        }
    }
    if (!CGRectIsEmpty(rect)) {
        rect = [self convertRect:rect fromView:self.textInputView];
        [self _scrollRectToVisible:rect animated:YES];
    }
}

- (void)tmui_scrollCaretVisibleAnimated:(BOOL)animated {
    if (CGRectIsEmpty(self.bounds)) return;
    
    CGRect caretRect = [self caretRectForPosition:self.selectedTextRange.end];
    [self _scrollRectToVisible:caretRect animated:animated];
}

- (void)_scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    // scrollEnabled 为 NO 时可能产生不合法的 rect 值 https://github.com/Tencent/QMUI_iOS/issues/205
    if (!CGRectIsValidated(rect)) {
        return;
    }
    
    CGFloat contentOffsetY = self.contentOffset.y;
    
    if (CGRectGetMinY(rect) == self.contentOffset.y + self.textContainerInset.top) {
        // 命中这个条件说明已经不用调整了，直接 return，避免继续走下面的判断，会重复调整，导致光标跳动
        return;
    }
    
    if (CGRectGetMinY(rect) < self.contentOffset.y + self.textContainerInset.top) {
        // 光标在可视区域上方，往下滚动
        contentOffsetY = CGRectGetMinY(rect) - self.textContainerInset.top - self.contentInset.top;
    } else if (CGRectGetMaxY(rect) > self.contentOffset.y + CGRectGetHeight(self.bounds) - self.textContainerInset.bottom - self.contentInset.bottom) {
        // 光标在可视区域下方，往上滚动
        contentOffsetY = CGRectGetMaxY(rect) - CGRectGetHeight(self.bounds) + self.textContainerInset.bottom + self.contentInset.bottom;
    } else {
        // 光标在可视区域内，不用调整
        return;
    }
    [self setContentOffset:CGPointMake(self.contentOffset.x, contentOffsetY) animated:animated];
}
@end



@interface UITextView ()

@property (nonatomic, strong) UILabel * placeholderLabel;

@end

@implementation UITextView (TMUI_TCategery_Placeholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method orgMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method swzMethod = class_getInstanceMethod(self, @selector(t_layoutSubviews));
        method_exchangeImplementations(orgMethod, swzMethod);
        
        Method orgDeallocMethod = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method swzDeallocMethod = class_getInstanceMethod(self, @selector(t_dealloc));
        method_exchangeImplementations(orgDeallocMethod, swzDeallocMethod);
    });
}

- (void)t_dealloc {
    [self t_dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)t_layoutSubviews {
    [self t_layoutSubviews];
    CGFloat top = self.textContainerInset.top;
    CGFloat left = self.textContainerInset.left + 5;
    CGFloat right = self.textContainerInset.right + 5;

    if (self.placeholderLabel.font.pointSize == 0 && self.font.pointSize != 0) {
        self.placeholderLabel.font = self.font;
    }
    self.placeholderLabel.frame = CGRectMake(left, top, self.frame.size.width - (left + right), 1);
    [self.placeholderLabel sizeToFit];
}

- (void)t_textViewDidChange:(NSNotification *)notification {
    if (![self isEqual:notification.object]) {
        return;
    }
    self.placeholderLabel.hidden = self.text.length > 0;
}


#pragma mark - Properties

- (void)setAttributePlaceholder:(NSAttributedString *)attributePlaceholder {
    self.placeholderLabel.attributedText = attributePlaceholder;
    self.placeholderLabel.hidden = self.text.length > 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(t_textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (NSAttributedString *)attributePlaceholder {
    return self.placeholderLabel.attributedText;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.attributePlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize]}];
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, self.frame.size.width - 10, 0)];
        label.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0];
        label.numberOfLines = 0;
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:label];
    }
    return label;
}

@end
