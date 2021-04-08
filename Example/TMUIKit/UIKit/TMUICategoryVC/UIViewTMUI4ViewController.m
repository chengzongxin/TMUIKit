//
//  UIViewTMUI4ViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/4/8.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UIViewTMUI4ViewController.h"
#import "TDThemeManager.h"

@interface UIViewTMUI4ViewController ()

@property(nonatomic, strong) UIView *targetView;

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) TMUILabel *locationTitleLabel;
@property(nonatomic, strong) TMUISegmentedControl *locationSegmentedControl;

@property(nonatomic, strong) TMUILabel *positionTitleLabel;
@property(nonatomic, strong) TMUIButton *positionTopButton;
@property(nonatomic, strong) TMUIButton *positionLeftButton;
@property(nonatomic, strong) TMUIButton *positionBottomButton;
@property(nonatomic, strong) TMUIButton *positionRightButton;

@property(nonatomic, strong) TMUILabel *maskedCornersTitleLabel;
@property(nonatomic, strong) TMUIButton *maskedCornersMinXMinYButton;
@property(nonatomic, strong) TMUIButton *maskedCornersMaxXMinYButton;
@property(nonatomic, strong) TMUIButton *maskedCornersMinXMaxYButton;
@property(nonatomic, strong) TMUIButton *maskedCornersMaxXMaxYButton;

@property(nonatomic, strong) TMUILabel *widthTitleLabel;
@property(nonatomic, strong) TMUITextField *widthTextField;

@property(nonatomic, strong) TMUILabel *cornerRadiusTitleLabel;
@property(nonatomic, strong) TMUITextField *cornerRadiusTextField;

@property(nonatomic, strong) TMUILabel *colorTitleLabel;
@property(nonatomic, strong) TMUISegmentedControl *colorSegmentedControl;

@property(nonatomic, strong) TMUILabel *dashPatternTitleLabel;
@property(nonatomic, strong) TMUITextField *dashPatternWidthTextField;
@property(nonatomic, strong) TMUITextField *dashPatternSpacingTextField;

@property(nonatomic, strong) TMUILabel *dashPhaseTitleLabel;
@property(nonatomic, strong) TMUITextField *dashPhaseTextField;

//@property(nonatomic, strong) TMUIKeyboardManager *keyboardManager;

@property(nonatomic, strong) UIView *magnifyingView;
@property(nonatomic, strong) UIImageView *magnifyingImageView;
@end

@implementation UIViewTMUI4ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.targetView = [[UIView alloc] tmui_initWithSize:CGSizeMake(100, 100)];
    self.targetView.backgroundColor = [UIColor.qd_tintColor colorWithAlphaComponent:.3];
    [self.view addSubview:self.targetView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:self.scrollView];
    
    self.locationTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(tmui_borderLocation))];
    self.locationSegmentedControl = [self generateSegmentedControlWithItems:@[@"Inside", @"Center", @"Outside"]];
    
    self.positionTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(tmui_borderPosition))];
    self.positionTopButton = [self generateSelectableButtonWithTitle:@"Top"];
    self.positionLeftButton = [self generateSelectableButtonWithTitle:@"Left"];
    self.positionBottomButton = [self generateSelectableButtonWithTitle:@"Bottom"];
    self.positionRightButton = [self generateSelectableButtonWithTitle:@"Right"];
    
    self.maskedCornersTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(tmui_maskedCorners))];
    self.maskedCornersMinXMinYButton = [self generateSelectableButtonWithTitle:@"MinXMinY"];
    self.maskedCornersMaxXMinYButton = [self generateSelectableButtonWithTitle:@"MaxXMinY"];
    self.maskedCornersMinXMaxYButton = [self generateSelectableButtonWithTitle:@"MinXMaxY"];
    self.maskedCornersMaxXMaxYButton = [self generateSelectableButtonWithTitle:@"MaxXMaxY"];
    
    self.widthTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(tmui_borderWidth))];
    self.widthTextField = [self generateNumericTextField];
    
    self.cornerRadiusTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(cornerRadius))];
    self.cornerRadiusTextField = [self generateNumericTextField];
    
    self.colorTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(tmui_borderColor))];
    self.colorSegmentedControl = [self generateSegmentedControlWithItems:@[@"Translucence", @"Opacity", @"Black"]];
    
    self.dashPatternTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(tmui_dashPattern))];
    self.dashPatternWidthTextField = [self generateNumericTextField];
    self.dashPatternSpacingTextField = [self generateNumericTextField];
    
    self.dashPhaseTitleLabel = [self generateTitleLabelWithText:NSStringFromSelector(@selector(tmui_dashPhase))];
    self.dashPhaseTextField = [self generateNumericTextField];
    self.dashPhaseTextField.placeholder = @"0";
    
//    self.keyboardManager = [[TMUIKeyboardManager alloc] initWithDelegate:self];
    
    // 默认值的设置
    self.locationSegmentedControl.selectedSegmentIndex = 0;
    self.positionTopButton.selected = YES;
    self.widthTextField.text = [NSString stringWithFormat:@"%.1f", 3.0];
    self.cornerRadiusTextField.text = @"0";
    self.colorSegmentedControl.selectedSegmentIndex = 0;
    self.dashPatternWidthTextField.text = @"0";
    self.dashPatternSpacingTextField.text = @"0";
    self.dashPhaseTextField.text = @"0";
    [self fireAllEvents];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.keyboardManager.delegateEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.keyboardManager.delegateEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.magnifyingView) {
        // 放大镜
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        [self.targetView addGestureRecognizer:longGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        [self.targetView addGestureRecognizer:panGesture];
        
        self.magnifyingView = [[UIView alloc] tmui_initWithSize:self.targetView.bounds.size];
        self.magnifyingView.backgroundColor = UIColorWhite;
        self.magnifyingView.layer.cornerRadius = CGRectGetHeight(self.magnifyingView.frame) / 2;
        self.magnifyingView.layer.borderWidth = 1;
        self.magnifyingView.layer.borderColor = UIColorSeparator.CGColor;
        self.magnifyingView.clipsToBounds = YES;
        self.magnifyingView.hidden = YES;
        
        self.magnifyingImageView = [[UIImageView alloc] init];
        [self.magnifyingView addSubview:self.magnifyingImageView];
    }
    
    if (!self.magnifyingView.superview) {
        [self.navigationController.view addSubview:self.magnifyingView];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.magnifyingView removeFromSuperview];
}

- (TMUILabel *)generateTitleLabelWithText:(NSString *)text {
    TMUILabel *label = [[TMUILabel alloc] tmui_initWithFont:UIFontMake(14) textColor:UIColor.qd_mainTextColor];
    label.text = text;
    [label sizeToFit];
    [self.scrollView addSubview:label];
    return label;
}

- (TMUISegmentedControl *)generateSegmentedControlWithItems:(NSArray<NSString *> *)items {
    TMUISegmentedControl *segmentedControl = [[TMUISegmentedControl alloc] initWithItems:items];
    segmentedControl.tintColor = UIColor.qd_tintColor;
    segmentedControl.frame = CGRectSetWidth(segmentedControl.frame, 240);// 统一按照最长的来就行啦
    segmentedControl.transform = CGAffineTransformMakeScale(.8, .8);
//    segmentedControl.tmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
    [self.scrollView addSubview:segmentedControl];
    [segmentedControl addTarget:self action:@selector(handleSegmentedControlEvent:) forControlEvents:UIControlEventValueChanged];
    return segmentedControl;
}

- (TMUIButton *)generateSelectableButtonWithTitle:(NSString *)title {
    TMUIButton *button = [[TMUIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
//    UIImage *selectedImage = [TableViewCellCheckmarkImage tmui_imageResizedInLimitedSize:CGSizeMake(13, 13) resizingMode:TMUIImageResizingModeScaleAspectFit];
    UIImage *selectedImage = [TableViewCellCheckmarkImage tmui_scaleToSize:CGSizeMake(13, 13)];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setImage:selectedImage forState:UIControlStateHighlighted | UIControlStateSelected];
    button.imagePosition = TMUIButtonImagePositionRight;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    button.titleLabel.font = UIFontMake(12);
    [button setTitleColor:UIColor.qd_descriptionTextColor forState:UIControlStateNormal];
    button.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
//    button.tmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
    [self.scrollView addSubview:button];
    [button addTarget:self action:@selector(handleSelectableButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (TMUITextField *)generateNumericTextField {
    TMUITextField *textField = [[TMUITextField alloc] tmui_initWithSize:CGSizeMake(44, 32)];
    textField.font = UIFontMake(12);
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.layer.borderWidth = PixelOne;
    textField.layer.borderColor = UIColorSeparator.CGColor;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = UIColor.qd_tintColor;
    [self.scrollView addSubview:textField];
    [textField addTarget:self action:@selector(handleTextFieldChangedEvent:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!IS_IPAD && IS_LANDSCAPE) {
        self.targetView.left = self.view.tmui_safeAreaInsets.left + 32;
        self.targetView.top = CGFloatGetCenter(CGRectGetHeight(self.view.bounds) - UIEdgeInsetsGetVerticalValue(self.view.tmui_safeAreaInsets), CGRectGetHeight(self.targetView.frame));
        CGFloat scrollViewMinX = CGRectGetMaxX(self.targetView.frame) + 32;
        self.scrollView.frame = CGRectMake(scrollViewMinX, 0, self.view.width - scrollViewMinX, CGRectGetHeight(self.view.bounds));
        self.scrollView.tmui_borderPosition = TMUIViewBorderPositionLeft;
    } else {
        self.targetView.left = self.targetView.leftWhenCenterInSuperview;
        self.targetView.top = tmui_navigationBarHeight() + 32;
        CGFloat scrollViewMinY = self.targetView.bottom + 32;
        self.scrollView.frame = CGRectMake(0, scrollViewMinY, self.view.width, CGRectGetHeight(self.view.bounds) - scrollViewMinY);
        self.scrollView.tmui_borderPosition = TMUIViewBorderPositionTop;
    }
    
    CGFloat marginLeft = 16 + self.scrollView.tmui_safeAreaInsets.left;
    CGFloat marginRight = 16 + self.scrollView.tmui_safeAreaInsets.right;
    __block CGFloat maxY = 0;
    CGFloat defaultLineHeight = 44;
    
    self.locationTitleLabel.left = marginLeft;
    self.locationTitleLabel.top = CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.locationTitleLabel.frame));
    self.locationSegmentedControl.center = CGPointMake(CGRectGetWidth(self.scrollView.bounds) - marginRight - CGRectGetWidth(self.locationSegmentedControl.frame) / 2.0, self.locationTitleLabel.center.y);
    maxY = defaultLineHeight;
    
    self.positionTitleLabel.left = marginLeft;
    self.positionTitleLabel.top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.positionTitleLabel.frame));
    maxY += defaultLineHeight;
    [@[self.positionTopButton, self.positionLeftButton, self.positionBottomButton, self.positionRightButton] enumerateObjectsUsingBlock:^(TMUIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentEdgeInsets = UIEdgeInsetsMake(0, marginLeft + 18, 0, marginRight);
        obj.top = maxY;
        obj.width = CGRectGetWidth(self.scrollView.bounds);
        obj.height = 32;
        maxY = obj.bottom;
    }];
    
    self.widthTitleLabel.left = marginLeft;
    self.widthTitleLabel.top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.widthTitleLabel.frame));
    self.widthTextField.right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.widthTextField.top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.widthTextField.frame));
    maxY += defaultLineHeight;
    
    self.colorTitleLabel.left = marginLeft;
    self.colorTitleLabel.top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.colorTitleLabel.frame));
    self.colorSegmentedControl.center = CGPointMake(CGRectGetWidth(self.scrollView.bounds) - marginRight - CGRectGetWidth(self.colorSegmentedControl.frame) / 2.0, self.colorTitleLabel.center.y);
    maxY += defaultLineHeight;
    
    self.cornerRadiusTitleLabel.left = marginLeft;
    self.cornerRadiusTitleLabel.top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.cornerRadiusTitleLabel.frame));
    self.cornerRadiusTextField.tmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.cornerRadiusTextField.tmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.cornerRadiusTextField.frame));
    maxY += defaultLineHeight;
    
    self.maskedCornersTitleLabel.tmui_left = marginLeft;
    self.maskedCornersTitleLabel.tmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.maskedCornersTitleLabel.frame));
    maxY += defaultLineHeight;
    [@[self.maskedCornersMinXMinYButton, self.maskedCornersMaxXMinYButton, self.maskedCornersMinXMaxYButton, self.maskedCornersMaxXMaxYButton] enumerateObjectsUsingBlock:^(TMUIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentEdgeInsets = UIEdgeInsetsMake(0, marginLeft + 18, 0, marginRight);
        obj.tmui_top = maxY;
        obj.tmui_width = CGRectGetWidth(self.scrollView.bounds);
        obj.tmui_height = 32;
        maxY = obj.tmui_bottom;
    }];
    
    self.dashPatternTitleLabel.tmui_left = marginLeft;
    self.dashPatternTitleLabel.tmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPatternTitleLabel.frame));
    self.dashPatternSpacingTextField.tmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.dashPatternSpacingTextField.tmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPatternSpacingTextField.frame));
    self.dashPatternWidthTextField.tmui_right = self.dashPatternSpacingTextField.tmui_left - 8;
    self.dashPatternWidthTextField.tmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPatternWidthTextField.frame));
    maxY += defaultLineHeight;
    
    self.dashPhaseTitleLabel.tmui_left = marginLeft;
    self.dashPhaseTitleLabel.tmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPhaseTitleLabel.frame));
    self.dashPhaseTextField.tmui_right = CGRectGetWidth(self.scrollView.bounds) - marginRight;
    self.dashPhaseTextField.tmui_top = maxY + CGFloatGetCenter(defaultLineHeight, CGRectGetHeight(self.dashPhaseTextField.frame));
    maxY += defaultLineHeight;
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), maxY);
}

- (void)handleSegmentedControlEvent:(TMUISegmentedControl *)segmentedControl {
    if (segmentedControl == self.locationSegmentedControl) {
        self.targetView.tmui_borderLocation = segmentedControl.selectedSegmentIndex;
    } else if (segmentedControl == self.colorSegmentedControl) {
        UIColor *borderColor = nil;
        switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                borderColor = [UIColor.qd_tintColor colorWithAlphaComponent:.5];
                break;
            case 1:
                borderColor = UIColor.qd_tintColor;
                break;
            case 2:
                borderColor = [UIColor blackColor];
            default:
                break;
        }
        self.targetView.tmui_borderColor = borderColor;
    }
}

- (void)handleSelectableButtonEvent:(TMUIButton *)button {
    button.selected = !button.selected;
    if (button == self.positionTopButton || button == self.positionLeftButton || button == self.positionBottomButton || button == self.positionRightButton) {
        [self updateBorderPosition];
    } else {
        [self updateMaskedCorners];
    }
}

- (void)handleTextFieldChangedEvent:(TMUITextField *)textField {
    if (textField == self.widthTextField) {
        self.targetView.tmui_borderWidth = [textField.text doubleValue];
    } else if (textField == self.dashPhaseTextField) {
        self.targetView.tmui_dashPhase = [textField.text doubleValue];
    } else if (textField == self.cornerRadiusTextField) {
        self.targetView.layer.cornerRadius = [textField.text doubleValue];
    } else {
        CGFloat width = [self.dashPatternWidthTextField.text doubleValue];
        CGFloat spacing = [self.dashPatternSpacingTextField.text doubleValue];
        if (width > 0 || spacing > 0) {
            self.targetView.tmui_dashPattern = @[@(width), @(spacing)];
        } else {
            self.targetView.tmui_dashPattern = nil;
        }
    }
}

- (void)updateBorderPosition {
    TMUIViewBorderPosition position = TMUIViewBorderPositionNone;
    if (self.positionTopButton.selected) {
        position |= TMUIViewBorderPositionTop;
    }
    if (self.positionLeftButton.selected) {
        position |= TMUIViewBorderPositionLeft;
    }
    if (self.positionBottomButton.selected) {
        position |= TMUIViewBorderPositionBottom;
    }
    if (self.positionRightButton.selected) {
        position |= TMUIViewBorderPositionRight;
    }
    self.targetView.tmui_borderPosition = position;
}

- (void)updateMaskedCorners {
    TMUICornerMask cornerMask = 0;
    if (self.maskedCornersMinXMinYButton.isSelected) {
        cornerMask |= TMUILayerMinXMinYCorner;
    }
    if (self.maskedCornersMaxXMinYButton.isSelected) {
        cornerMask |= TMUILayerMaxXMinYCorner;
    }
    if (self.maskedCornersMinXMaxYButton.isSelected) {
        cornerMask |= TMUILayerMinXMaxYCorner;
    }
    if (self.maskedCornersMaxXMaxYButton.isSelected) {
        cornerMask |= TMUILayerMaxXMaxYCorner;
    }
    if (cornerMask == 0) {
        // 默认值
        cornerMask = TMUILayerAllCorner;
    }
    self.targetView.layer.tmui_maskedCorners = cornerMask;
}

- (void)fireAllEvents {
    [@[self.locationSegmentedControl, self.widthTextField, self.colorSegmentedControl, self.dashPatternWidthTextField, self.dashPatternSpacingTextField, self.dashPhaseTextField] enumerateObjectsUsingBlock:^(UIControl *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    [@[self.widthTextField, self.dashPatternWidthTextField, self.dashPatternSpacingTextField, self.dashPhaseTextField] enumerateObjectsUsingBlock:^(UIControl *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj sendActionsForControlEvents:UIControlEventEditingChanged];
    }];
    [self updateBorderPosition];
}

- (void)handleGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    CGFloat offset = self.targetView.tmui_borderWidth + 5;
    CGFloat scale = 8;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.magnifyingView.hidden = YES;
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGSize size = self.targetView.frame.size;
        size.width += offset * 2;
        size.height += offset * 2;
        
        UIImage *snapshotImage = [UIImage tmui_imageWithSize:size opaque:NO scale:ScreenScale * scale actions:^(CGContextRef contextRef) {
            CGContextTranslateCTM(contextRef, offset, offset);
            // 当你使用了 tmui_maskedCorners 并且只指定某几个角为圆角时，用以下这种方式绘制出来的图片会让直角也绘制为圆角，这是 iOS 11 及以上的系统 bug，暂不处理
            [self.targetView.layer renderInContext:contextRef];
        }];
        
        self.magnifyingImageView.image = snapshotImage;
        [self.magnifyingImageView sizeToFit];
        self.magnifyingImageView.transform = CGAffineTransformMakeScale(scale, scale);
        
        self.magnifyingView.hidden = NO;
    }
    
    CGPoint locationInView = [gestureRecognizer locationInView:self.magnifyingView.superview];
    locationInView.x = MIN(MAX(locationInView.x, CGRectGetMinX(self.targetView.frame) - self.targetView.tmui_borderWidth), CGRectGetMaxX(self.targetView.frame) + self.targetView.tmui_borderWidth);
    locationInView.y = MIN(MAX(locationInView.y, CGRectGetMinY(self.targetView.frame) - self.targetView.tmui_borderWidth), CGRectGetMaxY(self.targetView.frame) + self.targetView.tmui_borderWidth);
    self.magnifyingView.center = locationInView;
    
    CGPoint locationInTarget = [self.targetView convertPoint:locationInView fromView:self.magnifyingView.superview];
    self.magnifyingImageView.center = CGPointMake(CGRectGetWidth(self.magnifyingView.bounds) / 2 + CGRectGetWidth(self.magnifyingImageView.frame) / 2 - offset * scale - locationInTarget.x * scale, CGRectGetHeight(self.magnifyingView.bounds) / 2 + CGRectGetHeight(self.magnifyingImageView.frame) / 2 - offset * scale - locationInTarget.y * scale);
    
    // 避免手指挡住放大镜
    CGFloat avoidFingerX = -60;
    CGFloat avoidFingerY = -100;
    CGFloat magnifyingViewMinX = CGRectGetMinX(self.magnifyingView.frame);
    CGFloat magnifyingViewMinY = CGRectGetMinY(self.magnifyingView.frame);
    if (magnifyingViewMinY + avoidFingerY < self.magnifyingView.superview.tmui_safeAreaInsets.top) {
        magnifyingViewMinY = self.magnifyingView.superview.tmui_safeAreaInsets.top;
        if (magnifyingViewMinX + avoidFingerX < self.magnifyingView.superview.tmui_safeAreaInsets.left) {
            magnifyingViewMinX -= avoidFingerX;
        } else {
            magnifyingViewMinX += avoidFingerX;
        }
    } else {
        magnifyingViewMinY += avoidFingerY;
    }
    self.magnifyingView.frame = CGRectSetXY(self.magnifyingView.frame, magnifyingViewMinX, magnifyingViewMinY);
}

#pragma mark - <TMUIKeyboardManagerDelegate>

//- (void)keyboardWillChangeFrameWithUserInfo:(TMUIKeyboardUserInfo *)keyboardUserInfo {
//    TMUITextField *textField = (TMUITextField *)keyboardUserInfo.targetResponder;
//    CGRect textFieldRect = [self.view convertRect:textField.frame fromView:textField.superview];
//    textFieldRect = CGRectSetHeight(textFieldRect, CGRectGetHeight(textFieldRect) + 12);// 12 是距离底部键盘的间距
//    CGFloat keyboardHeight = [keyboardUserInfo heightInView:self.view];
//    self.scrollView.contentInset = UIEdgeInsetsSetBottom(self.scrollView.contentInset, keyboardHeight);
//    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsSetBottom(self.scrollView.contentInset, self.scrollView.contentInset.bottom - (keyboardHeight > 0 ? self.scrollView.tmui_safeAreaInsets.bottom : 0));
//    if (CGRectGetMaxY(textFieldRect) < CGRectGetHeight(self.view.bounds) - keyboardHeight) {
//        return;
//    }
//
//    CGFloat scrollDistance = CGRectGetMaxY(textFieldRect) - (CGRectGetHeight(self.view.bounds) - keyboardHeight);
//    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + scrollDistance)];
//}

@end
