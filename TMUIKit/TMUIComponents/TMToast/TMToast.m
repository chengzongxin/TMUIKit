//
//  TMToast.m
//  Masonry
//
//  Created by nigel.ning on 2020/4/28.
//

#import "TMToast.h"
#import <Masonry/Masonry.h>
#import <TMUICommonDefines.h>
#import <TMUIKitDefines.h>
#import <UIColor+TMUI.h>

@interface TMToastView : UIView
@property (nonatomic, strong)UIVisualEffectView *effectView;
@property (nonatomic, strong)UILabel *msgLbl;
@end

@implementation TMToastView

+ (instancetype)toastViewWithString:(NSString *)str {
    TMToastView *view = [[self alloc] init];
    view.msgLbl.text = str;
    return view;
}

+ (instancetype)toastViewWithAttributedString:(NSAttributedString *)attriStr {
    TMToastView *view = [[self alloc] init];
    view.msgLbl.attributedText = attriStr;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    //self.backgroundColor = [[UIColor tmui_colorWithHexString:@"353535"] colorWithAlphaComponent:0.5];
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.msgLbl = [[UILabel alloc] init];
    [self.effectView.contentView addSubview:self.msgLbl];
    [self.msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.effectView.contentView.mas_centerY);
    }];
    self.msgLbl.textColor = [UIColor whiteColor];
    self.msgLbl.font = UIFont(12);
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    self.alpha = 0;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 17;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_greaterThanOrEqualTo(60);
        make.trailing.mas_lessThanOrEqualTo(-60);
        make.height.mas_equalTo(34);
        make.centerX.mas_equalTo(window.mas_centerX);
        make.top.mas_equalTo(tmui_safeAreaTopInset() + 44);
    }];
    [self.superview setNeedsUpdateConstraints];
    [self.superview updateConstraints];
    [self.superview layoutSubviews];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tmui_safeAreaTopInset() + 44 + 80);
        }];
        [self.superview setNeedsUpdateConstraints];
        [self.superview updateConstraints];
        [self.superview layoutSubviews];
    } completion:^(BOOL finished) {
        [self delayHide];
    }];
}

- (void)delayHide {
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:[TMToast duration]];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end


@interface TMToast()

@end

@implementation TMToast

static NSTimeInterval s_duration = 1.0;
+ (NSTimeInterval)duration {
    return s_duration;
}

+ (void)setDuration:(NSTimeInterval)duration {
    s_duration = duration;
}

+ (void)toast:(NSString *)str {
    TMToastView *view = [TMToastView toastViewWithString:str];
    [view show];
}

+ (void)toastAttributedString:(NSAttributedString *)attrStr {
    TMToastView *view = [TMToastView toastViewWithAttributedString:attrStr];
    [view show];
}

@end


@implementation TMToast(ScoreToast)

+ (void)toastScore:(NSInteger)score content:(NSString *)content {
    
    if (score <= 0 && content.length == 0) {
        return;
    }
    
    UIImage *icon = [UIImage imageNamed:@"TMToastAssets.bundle/icon_gold_coin"];
    NSAssert(icon, @"score icon should not be nil");
    
    if (!icon) {
        if (content.length > 0) {
            [self toast:content];
        }
    }else {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:@""];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = icon;
        attachment.bounds = CGRectMake(0, -4, 16, 16);
        [mAttr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        
        NSMutableAttributedString *leftTxtStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" +%ld", score] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightRegular]}].mutableCopy;
        //微调+号的显示位置，默认位置太靠下了，上移一点
        //NSRange addSymbolRange = [leftTxtStr.string rangeOfString:@"+"];
        //[leftTxtStr addAttribute:NSBaselineOffsetAttributeName value:@(2) range:addSymbolRange];
        [mAttr appendAttributedString:leftTxtStr];
        
        if (content.length > 0) {
            NSAttributedString *contentStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", content] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightRegular]}];
            [mAttr appendAttributedString:contentStr];
        }
        
        [mAttr addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:NSMakeRange(0, mAttr.length)];
        
        [self toastAttributedString:mAttr];
    }
}

@end
