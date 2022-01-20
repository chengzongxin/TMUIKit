//
//  TMTextViewViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/23.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITextViewViewController.h"

@interface TMUITextViewViewController ()<TMUITextViewDelegate>
@property(nonatomic,strong) TMUITextView *textView;
@property(nonatomic, assign) CGFloat textViewMinimumHeight;

@property(nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UILabel *l1;
@end

@implementation TMUITextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _l1 = Label.str(self.demoInstructions.subReplace(@"、",@"\n")).styles(body).lineGap(5).addTo(self.view).makeCons(^{
        make.top.left.right.constants(NavigationContentTop+20,20,-20);
    });
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textViewMinimumHeight = 96;
    self.textView = [[TMUITextView alloc] init];
    self.textView.delegate = self;
    self.textView.placeholder = @"支持 placeholder、支持自适应高度、支持限制文本输入长度";
    self.textView.placeholderColor = UIColor.tmui_randomColor; // 自定义 placeholder 的颜色
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFont(15),
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:30],
                                       NSForegroundColorAttributeName: self.textView.textColor
    };
//    self.textView.backgroundColor = UIColor.td_backgroundColorLighten;
    // 限制可输入的字符长度
    self.textView.maximumTextLength = 1000;

    // 限制输入框自增高的最大高度
    self.textView.maximumHeight = 500;

    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = UIColor.tmui_randomColor.CGColor;
    self.textView.layer.cornerRadius = 4;
    [self.view addSubview:self.textView];

    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"最长不超过 %@ 个文字，可尝试输入 emoji、粘贴一大段文字。\n会自动监听回车键，触发发送逻辑。", @(self.textView.maximumTextLength)] attributes:@{NSFontAttributeName: UIFont(12), NSForegroundColorAttributeName: UIColor.tmui_randomColor, NSParagraphStyleAttributeName: [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:16]}];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:self.tipsLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets padding = UIEdgeInsetsMake(_l1.maxY + 16, 16 + self.view.safeAreaInsets.left, 16 + self.view.safeAreaInsets.bottom, 16 + self.view.safeAreaInsets.right);
        CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
        
        CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
        self.textView.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), fmax(textViewSize.height, self.textViewMinimumHeight));
        
        CGFloat tipsLabelHeight = [self.tipsLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
        self.tipsLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.textView.frame) + 8, contentWidth, tipsLabelHeight);
    } else {
        // Fallback on earlier versions
    }
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
}

#pragma mark - <TMUITextViewDelegate>

// 实现这个 delegate 方法就可以实现自增高
- (void)textView:(TMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmax(height, self.textViewMinimumHeight);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)textView:(TMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [TMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)]];
}

// 可以利用这个 delegate 来监听发送按钮的事件，当然，如果你习惯以前的方式的话，也可以继续在 textView:shouldChangeTextInRange:replacementText: 里处理
- (BOOL)textViewShouldReturn:(TMUITextView *)textView {
    [TMUITips showWithText:[NSString stringWithFormat:@"成功发送文字：%@", textView.text]];
    textView.text = nil;
    
    // return YES 表示这次 return 按钮的点击是为了触发“发送”，而不是为了输入一个换行符
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    Log(@"%s",_cmd);
}

@end

