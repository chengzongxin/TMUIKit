//
//  UITextView+TMUIPlaceholder.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/7/27.
//

#import "UITextView+TMUIPlaceholder.h"
#import <objc/runtime.h>

@interface UITextView (TMUIPlaceholder)

@property (nonatomic, strong) UILabel * placeholderLabel;

@end

@implementation UITextView (TMUIPlaceholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method orgMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method swzMethod = class_getInstanceMethod(self, @selector(tmui_layoutSubviews));
        method_exchangeImplementations(orgMethod, swzMethod);

        Method orgDeallocMethod = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method swzDeallocMethod = class_getInstanceMethod(self, @selector(tmui_dealloc));
        method_exchangeImplementations(orgDeallocMethod, swzDeallocMethod);
    });
}

- (void)tmui_dealloc {
    [self tmui_dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tmui_layoutSubviews {
    [self tmui_layoutSubviews];
    CGFloat top = self.textContainerInset.top;
    CGFloat left = self.textContainerInset.left + 5;
    CGFloat right = self.textContainerInset.right + 5;

    if (self.placeholderLabel.font.pointSize == 0 && self.font.pointSize != 0) {
        self.placeholderLabel.font = self.font;
    }
    self.placeholderLabel.frame = CGRectMake(left, top, self.frame.size.width - (left + right), 1);
    [self.placeholderLabel sizeToFit];
}

- (void)tmui_textViewDidChange:(NSNotification *)notification {
    if (![self isEqual:notification.object]) {
        return;
    }
    self.placeholderLabel.hidden = self.text.length > 0;
}


#pragma mark - Properties

- (void)setAttributePlaceholder:(NSAttributedString *)attributePlaceholder {
    self.placeholderLabel.attributedText = attributePlaceholder;
    self.placeholderLabel.hidden = self.text.length > 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tmui_textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
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
