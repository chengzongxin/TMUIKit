//
//  TDModalPresentationViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/5/7.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDModalPresentationViewController.h"
#import "TMUIModalPresentationViewController.h"
#import "TDCommonUI.h"
#import "UIImageEffects.h"


#define Row_Modal(x,y) \
Row.str(self.dataSource[x].allKeys[y]).fnt(18).detailStr(self.dataSource[x].allValues[y]).subtitleStyle.cellHeightAuto.onClick(^{\
[self didSelectCellWithTitle:self.dataSource[x].allKeys[y]];\
})

static NSString * const kSectionTitleForUsing = @"使用方式";
static NSString * const kSectionTitleForStyling = @"内容及动画";

@interface TDModalContentViewController : UIViewController<TMUIModalPresentationContentViewControllerProtocol>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;
@end

@interface TDModalPresentationViewController ()
@property(nonatomic, strong) TMUIOrderedDictionary <NSString *,TMUIOrderedDictionary *>*dataSource;
@property(nonatomic, assign) TMUIModalPresentationAnimationStyle currentAnimationStyle;
@property(nonatomic, strong) TMUIModalPresentationViewController *modalViewControllerForAddSubview;

@end

@implementation TDModalPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                        kSectionTitleForUsing, [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                @"showWithAnimated",      @"以 UIWindow 的形式盖在当前界面上",
                                                @"presentViewController", @"以 presentViewController: 的方式显示",
                                                @"showInView",            @"以 addSubview: 的方式直接将浮层添加到要显示的 UIView 上",
                                                nil],
                        kSectionTitleForStyling, [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                  @"contentView",           @"直接显示一个UIView浮层",
                                                  @"contentViewController", @"显示一个UIViewController",
                                                  @"animationStyle",        @"默认提供3种动画，可重复点击，依次展示",
                                                  @"dimmingView",           @"自带背景遮罩，也可自行制定一个遮罩的UIView",
                                                  @"layoutBlock",           @"利用layoutBlock、showingAnimation、hidingAnimation制作自定义的显示动画",
                                                  @"keyboard",              @"控件自带对keyboard的管理，并且能保证浮层和键盘同时升起，不会有跳动",
                                                  nil],
                       nil];
    
    GroupTV(
            Section(
                    Row_Modal(0, 0),
                    Row_Modal(0, 1),
                    Row_Modal(0, 2),
                    ).title(self.dataSource.allKeys[0]),
            Section(
                    Row_Modal(1, 0),
                    Row_Modal(1, 1),
                    Row_Modal(1, 2),
                    Row_Modal(1, 3),
                    Row_Modal(1, 4),
                    Row_Modal(1, 5),
                    ).title(self.dataSource.allKeys[1]),
            ).embedIn(self.view);
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"showWithAnimated"]) {
        [self handleWindowShowing];
    } else if ([title isEqualToString:@"presentViewController"]) {
        [self handlePresentShowing];
    } else if ([title isEqualToString:@"showInView"]) {
        [self handleShowInView];
    } else if ([title isEqualToString:@"contentView"]) {
        [self handleShowContentView];
    } else if ([title isEqualToString:@"contentViewController"]) {
        [self handleShowContentViewController];
    } else if ([title isEqualToString:@"animationStyle"]) {
        [self handleAnimationStyle];
    } else if ([title isEqualToString:@"dimmingView"]) {
        [self handleCustomDimmingView];
    } else if ([title isEqualToString:@"layoutBlock"]) {
        [self handleLayoutBlockAndAnimation];
    } else if ([title isEqualToString:@"keyboard"]) {
        [self handleKeyboard];
    }
}

#pragma mark - Handles

- (void)handleWindowShowing {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 208)];
    contentView.backgroundColor = UIColor.td_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"TMUIModalPresentationViewController支持 3 种使用方式，当前使用第 1 种。提供 UIWindow 的方式目的是为了盖住状态栏，但 iOS 13 及以后，状态栏已经无法被盖住了，所以只有在 iOS 12 及以下才能看到状态栏盖住的效果。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding), TMUIViewSelfSizingHeight);
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 UIWindow 的形式来展示
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handlePresentShowing {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    contentView.backgroundColor = UIColor.td_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"TMUIModalPresentationViewController支持 3 种使用方式，当前使用第 2 种，注意遮罩无法盖住屏幕顶部的状态栏。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding), TMUIViewSelfSizingHeight);
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    // 以 presentViewController 的形式展示时，animated 要传 NO，否则系统的动画会覆盖 TMUIModalPresentationAnimationStyle 的动画
    [self presentViewController:modalViewController animated:NO completion:NULL];
}

- (void)handleShowInView {
    if (!self.modalViewControllerForAddSubview) {
        CGRect modalRect = CGRectMake(40, NavigationContentTop + 40, CGRectGetWidth(self.view.bounds) - 40 * 2, CGRectGetHeight(self.view.bounds) - NavigationContentTop - 40 * 2);
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(modalRect) - 40, 0)];
        contentView.backgroundColor = UIColor.td_backgroundColorLighten;
        contentView.layer.cornerRadius = 6;
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
        paragraphStyle.paragraphSpacing = 16;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"TMUIModalPresentationViewController支持 3 种使用方式，当前使用第 3 种，注意可以透过遮罩外的空白地方点击到背后的 cell。\n这种方式适用于需要保持浮层显示的情况下切换界面，你可以点击按钮看效果。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
        NSDictionary *codeAttributes = CodeAttributes(16);
        [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
            [attributedString addAttributes:codeAttributes range:codeRange];
        }];
        label.attributedText = attributedString;
        [contentView addSubview:label];
        
        TMUIButton *button = [[TMUIButton alloc] init];
        button.tintColorAdjustsTitleAndImage = ButtonTintColor;
        button.titleLabel.font = UIFontMake(16);
        [button setTitle:@"进入下一个界面" forState:UIControlStateNormal];
        [button setImage:TableViewCellDisclosureIndicatorImage forState:UIControlStateNormal];
        button.spacingBetweenImageAndTitle = 4;
        button.imagePosition = TMUIButtonImagePositionRight;
        [button sizeToFit];
        button.tmui_click = ^{
            [TMUIHelper.visibleViewController.navigationController pushViewController:TDModalPresentationViewController.new animated:YES];
        };
        [contentView addSubview:button];
        
        UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
        label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding), TMUIViewSelfSizingHeight);
        button.frame = CGRectSetXY(button.frame, CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) + 24);
        contentView.frame = CGRectSetHeight(contentView.frame, CGRectGetMaxY(button.frame) + contentViewPadding.bottom);
        
        self.modalViewControllerForAddSubview = [[TMUIModalPresentationViewController alloc] init];
        self.modalViewControllerForAddSubview.contentView = contentView;
        self.modalViewControllerForAddSubview.view.frame = modalRect;// 为了展示，故意让浮层小于当前界面，以展示局部浮层的能力
        // 以 addSubview 的形式显示，此时需要retain住modalPresentationViewController，防止提前被释放
    }
    [self.modalViewControllerForAddSubview showInView:self.view animated:NO completion:nil];
}


- (void)handleShowContentView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = UIColor.td_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"默认的布局是上下左右居中，可通过contentViewMargins、maximumContentViewWidth属性来调整宽高、上下左右的偏移。\n你现在可以试试旋转一下设备试试看。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding), TMUIViewSelfSizingHeight);
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleShowContentViewController {
    TDModalContentViewController *contentViewController = [[TDModalContentViewController alloc] init];
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.contentViewController = contentViewController;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleAnimationStyle {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = UIColor.td_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"modalViewController提供的显示/隐藏动画总共有3种，可通过animationStyle属性来设置，默认为TMUIModalPresentationAnimationStyleFade。\n多次打开此浮层会在这3种动画之间互相切换。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding), TMUIViewSelfSizingHeight);
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = self.currentAnimationStyle % 3;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
    
    self.currentAnimationStyle++;
}

- (void)handleCustomDimmingView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    contentView.backgroundColor = UIColor.td_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    contentView.layer.shadowColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        return [identifier isEqualToString:TDThemeIdentifierDark] ? UIColorWhite : UIColorBlack;
    }].CGColor;
    contentView.layer.shadowOpacity = .08;
    contentView.layer.shadowRadius = 15;
    contentView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds cornerRadius:contentView.layer.cornerRadius].CGPath;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"TMUIModalPresentationViewController允许自定义背景遮罩的dimmingView，例如这里的背景遮罩是拿当前界面进行截图磨砂后显示出来的。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding), TMUIViewSelfSizingHeight);
    
    UIImage *blurredBackgroundImage = [UIImage tmui_imageWithView:self.navigationController.view];
    if ([TMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:TDThemeIdentifierDark]) {
        blurredBackgroundImage = [UIImageEffects imageByApplyingDarkEffectToImage:blurredBackgroundImage];
    } else {
        blurredBackgroundImage = [UIImageEffects imageByApplyingExtraLightEffectToImage:blurredBackgroundImage];
    }
    UIImageView *blurredDimmingView = [[UIImageView alloc] initWithImage:blurredBackgroundImage];
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.dimmingView = blurredDimmingView;
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleLayoutBlockAndAnimation {
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    contentView.backgroundColor = UIColor.td_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    contentView.alwaysBounceVertical = NO;
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"利用layoutBlock可以自定义浮层的布局，注意此时contentViewMargins、maximumContentViewWidth属性均无效，如果需要实现外间距、最大宽高的保护，请自行计算。\n另外搭配showingAnimation、hidingAnimation也可制作自己的显示/隐藏动画，例如这个例子里实现了一个从底部升起的面板，升起后停靠在容器底端，你可以试着旋转设备，会发现依然能正确布局。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    label.frame = CGRectMake(contentViewPadding.left, contentViewPadding.top, CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding), TMUIViewSelfSizingHeight);
    
    contentView.contentSize = CGSizeMake(CGRectGetWidth(contentView.bounds), CGRectGetMaxY(label.frame) + contentViewPadding.bottom);
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = TMUIModalPresentationAnimationStyleSlide;
    modalViewController.contentView = contentView;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        contentView.tmui_frameApplyTransform = CGRectSetXY(contentView.frame, CGFloatGetCenter(CGRectGetWidth(containerBounds), CGRectGetWidth(contentView.frame)), CGRectGetHeight(containerBounds) - 20 - CGRectGetHeight(contentView.frame));
    };
    [modalViewController showWithAnimated:YES completion:nil];
}

- (void)handleKeyboard {
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    contentView.alwaysBounceVertical = NO;
    contentView.alwaysBounceHorizontal = NO;
    contentView.backgroundColor = UIColor.td_backgroundColorLighten;
    contentView.layer.cornerRadius = 6;
    
    UIEdgeInsets contentViewPadding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGFloat contentLimitWidth = CGRectGetWidth(contentView.bounds) - UIEdgeInsetsGetHorizontalValue(contentViewPadding);
    
    TMUITextField *textField = [[TMUITextField alloc] initWithFrame:CGRectMake(contentViewPadding.left, contentViewPadding.top, contentLimitWidth, 36)];
    textField.placeholder = @"请输入文字";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = UIFontMake(16);
    [contentView addSubview:textField];
    [textField becomeFirstResponder];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:20];
    paragraphStyle.paragraphSpacing = 10;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"如果你的浮层里有输入框，建议在把输入框添加到界面上后立即调用becomeFirstResponder（如果你用contentViewController，则在viewWillAppear:时调用becomeFirstResponder），以保证键盘跟随浮层一起显示。\n而在浮层消失时，modalViewController会自动降下键盘，所以你的浮层里并不需要处理。" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    
    NSDictionary *codeAttributes = @{NSFontAttributeName: CodeFontMake(12), NSForegroundColorAttributeName: UIColor.td_codeColor};
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        [attributedString addAttributes:codeAttributes range:codeRange];
    }];
    
    label.attributedText = attributedString;
    [contentView addSubview:label];
    
    label.frame = CGRectMake(contentViewPadding.left, CGRectGetMaxY(textField.frame) + 8, contentLimitWidth, TMUIViewSelfSizingHeight);
    contentView.contentSize = CGSizeMake(CGRectGetWidth(contentView.bounds), CGRectGetMaxY(label.frame) + contentViewPadding.bottom);
    
    TMUIModalPresentationViewController *modalViewController = [[TMUIModalPresentationViewController alloc] init];
    modalViewController.animationStyle = TMUIModalPresentationAnimationStyleSlide;
    __weak __typeof(modalViewController)weakModal = modalViewController;
    modalViewController.layoutBlock = ^(CGRect containerBounds, CGFloat keyboardHeight, CGRect contentViewDefaultFrame) {
        
        CGSize contentViewContainerSize = CGSizeMake(CGRectGetWidth(containerBounds) - UIEdgeInsetsGetHorizontalValue(weakModal.contentViewMargins), CGRectGetHeight(containerBounds) - keyboardHeight - UIEdgeInsetsGetVerticalValue(weakModal.contentViewMargins));
        CGSize contentViewLimitSize = CGSizeMake(MIN(weakModal.maximumContentViewWidth, contentViewContainerSize.width), contentViewContainerSize.height);
        CGSize contentViewSize = contentView.contentSize;
        contentViewSize.width = MIN(contentViewLimitSize.width, contentViewSize.width);
        contentViewSize.height = MIN(contentViewLimitSize.height, contentViewSize.height);
        CGRect contentViewFrame = CGRectMake(CGFloatGetCenter(contentViewContainerSize.width, contentViewSize.width) + weakModal.contentViewMargins.left, CGFloatGetCenter(contentViewContainerSize.height, contentViewSize.height) + weakModal.contentViewMargins.top, contentViewSize.width, contentViewSize.height);
        contentView.tmui_frameApplyTransform = contentViewFrame;
    };
    modalViewController.contentView = contentView;
    [modalViewController showWithAnimated:YES completion:nil];
}


@end


@implementation TDModalContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.td_backgroundColorLighten;
    self.view.layer.cornerRadius = 6;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderWidth = PixelOne;
    self.imageView.layer.borderColor = UIColor.td_separatorColor.CGColor;
    self.imageView.image = UIImageMake(@"angel");
    [self.scrollView addSubview:self.imageView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:24];
    paragraphStyle.paragraphSpacing = 16;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"如果你的浮层是以UIViewController的形式存在的，那么就可以通过modalViewController.contentViewController属性来显示出来。\n利用UIViewController的特点，你可以方便地管理复杂的UI状态，并且响应设备在不同状态下的布局。\n例如这个例子里，图片和文字的排版会随着设备的方向变化而变化，你可以试着旋转屏幕看看效果。" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColor.td_mainTextColor, NSParagraphStyleAttributeName: paragraphStyle}];
    NSDictionary *codeAttributes = CodeAttributes(16);
    [attributedString.string enumerateCodeStringUsingBlock:^(NSString *codeString, NSRange codeRange) {
        if (![codeString isEqualToString:@"UI"]) {
            [attributedString addAttributes:codeAttributes range:codeRange];
        }
    }];
    self.textLabel.attributedText = attributedString;
    [self.scrollView addSubview:self.textLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, 20, 20);
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.view.bounds) - UIEdgeInsetsGetVerticalValue(padding));
    self.scrollView.frame = self.view.bounds;
    
    if (IS_LANDSCAPE) {
        // 横屏下图文水平布局
//        CGFloat imageViewLimitWidth = contentSize.width / 3;
        self.imageView.frame = CGRectSetXY(self.imageView.frame, padding.left, padding.top);
//        [self.imageView tmui_sizeToFitKeepingImageAspectRatioInSize:CGSizeMake(imageViewLimitWidth, CGFLOAT_MAX)];
        
        CGFloat textLabelMarginLeft = 20;
        self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + textLabelMarginLeft, padding.top - 6, contentSize.width - CGRectGetWidth(self.imageView.frame) - textLabelMarginLeft, TMUIViewSelfSizingHeight);
    } else {
        // 竖屏下图文垂直布局
        CGFloat imageViewLimitHeight = 120;
        self.imageView.frame = CGRectMake(padding.left, padding.top, contentSize.width, imageViewLimitHeight);
        
        CGFloat textLabelMarginTop = 20;
        self.textLabel.frame = CGRectMake(padding.left, CGRectGetMaxY(self.imageView.frame) + textLabelMarginTop, contentSize.width, TMUIViewSelfSizingHeight);
    }
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.textLabel.frame) + padding.bottom);
}

#pragma mark - <TMUIModalPresentationContentViewControllerProtocol>

- (CGSize)preferredContentSizeInModalPresentationViewController:(TMUIModalPresentationViewController *)controller keyboardHeight:(CGFloat)keyboardHeight limitSize:(CGSize)limitSize {
    // 高度无穷大表示不显示高度，则默认情况下会保证你的浮层高度不超过TMUIModalPresentationViewController的高度减去contentViewMargins
    return CGSizeMake(CGRectGetWidth(controller.view.bounds) - UIEdgeInsetsGetHorizontalValue(controller.view.tmui_safeAreaInsets) - UIEdgeInsetsGetHorizontalValue(controller.contentViewMargins), CGRectGetHeight(controller.view.bounds) - UIEdgeInsetsGetVerticalValue(controller.view.tmui_safeAreaInsets) - UIEdgeInsetsGetVerticalValue(controller.contentViewMargins));
}

@end
