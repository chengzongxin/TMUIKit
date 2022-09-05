//
//  TMUIPopupMenuButtonItem.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/24.
//

#import "TMUIPopupMenuButtonItem.h"
#import "TMUIButton.h"
//#import "UIControl+TMUI.h"
#import "TMUIPopupMenuView.h"
#import "TMUICore.h"
#import "TMUIConfigurationMacros.h"


@interface TMUIPopupMenuButtonItem (UIAppearance)

- (void)updateAppearanceForMenuButtonItem;
@end

@implementation TMUIPopupMenuButtonItem

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title handler:(nullable void (^)(TMUIPopupMenuButtonItem *))handler {
    TMUIPopupMenuButtonItem *item = [[self alloc] init];
    item.image = image;
    item.title = title;
    item.handler = handler;
    return item;
}

- (instancetype)init {
    if (self = [super init]) {
        self.height = -1;
        
        _button = [[TMUIButton alloc] init];
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.button.tintColor = nil;
//        self.button.qmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
        [self.button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        [self updateAppearanceForMenuButtonItem];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.button sizeThatFits:size];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.bounds;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.button setImage:image forState:UIControlStateNormal];
    [self updateButtonImageEdgeInsets];
}

- (void)setImageMarginRight:(CGFloat)imageMarginRight {
    _imageMarginRight = imageMarginRight;
    [self updateButtonImageEdgeInsets];
}

- (void)updateButtonImageEdgeInsets {
    if (self.button.currentImage) {
        self.button.imageEdgeInsets = UIEdgeInsetsSetRight(self.button.imageEdgeInsets, self.imageMarginRight);
    }
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    self.button.highlightedBackgroundColor = highlightedBackgroundColor;
}

- (void)handleButtonEvent:(id)sender {
    if (self.handler) {
        self.handler(self);
    }
}

- (void)updateAppearance {
    self.button.titleLabel.font = self.menuView.itemTitleFont;
    [self.button setTitleColor:self.menuView.itemTitleColor forState:UIControlStateNormal];
    self.button.contentEdgeInsets = UIEdgeInsetsMake(0, self.menuView.padding.left, 0, self.menuView.padding.right);
}

@end

@implementation TMUIPopupMenuButtonItem (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearanceForPopupMenuView];
    });
}

+ (void)setDefaultAppearanceForPopupMenuView {
    TMUIPopupMenuButtonItem *appearance = [TMUIPopupMenuButtonItem appearance];
    appearance.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
    appearance.imageMarginRight = 6;
}

- (void)updateAppearanceForMenuButtonItem {
    TMUIPopupMenuButtonItem *appearance = [TMUIPopupMenuButtonItem appearance];
    self.highlightedBackgroundColor = appearance.highlightedBackgroundColor;
    self.imageMarginRight = appearance.imageMarginRight;
}

@end
