//
//  AlertContentView.m
//  Matafy
//
//  Created by silkents on 2019/4/10.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "AlertContentView.h"

@implementation AlertContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        self.clipsToBounds = YES;
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = kLStr(@"community_search_clearHistorySure");
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 17];
        [self addSubview:titleLab];
        titleLab.frame = CGRectMake(0, 20, CGRectGetWidth(frame), 50);
        
        // shop_invite_icon
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"shop_invite_icon"];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self addSubview:imgView];
        imgView.frame = CGRectMake(20,  CGRectGetMaxY(titleLab.frame) + 10, CGRectGetWidth(frame) - 40, CGRectGetHeight(frame) - (CGRectGetMaxY(titleLab.frame) + 10 + 60));
        
        UIView *botVIew = [[UIView alloc] init];
        botVIew.backgroundColor = X16Color(@"#EAEAEA");
        [self addSubview:botVIew];
        botVIew.frame = CGRectMake(0, CGRectGetHeight(frame) - 50, CGRectGetWidth(frame), 50);
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = [UIColor whiteColor];
        leftBtn.tag = 11;
        [leftBtn setTitle:kLStr(@"common_alert_cancel") forState:UIControlStateNormal];
        [leftBtn setTitleColor:X16Color(@"#333333") forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 17];
        [leftBtn addTarget:self action:@selector(botBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [botVIew addSubview:leftBtn];
        leftBtn.frame = CGRectMake(0, 1, (CGRectGetWidth(frame) - 1) * 0.5, 49);
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor whiteColor];
        rightBtn.tag = 12;
        [rightBtn setTitle:kLStr(@"common_alert_sure") forState:UIControlStateNormal];
        [rightBtn setTitleColor:X16Color(@"#00C3CE") forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 17];
        [rightBtn addTarget:self action:@selector(botBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [botVIew addSubview:rightBtn];
        rightBtn.frame = CGRectMake((CGRectGetWidth(frame) - 1) * 0.5 + 1, 1, (CGRectGetWidth(frame) - 1) * 0.5, 49);
    }
    return self;
}

- (void)botBtnClick:(UIButton *)btn
{
    NKAlertView *alertView = (NKAlertView *)self.superview;
    [alertView hide];
    switch (btn.tag) {
        case 11:
        {
            if(self.btnClick)
            {
                self.btnClick(0);
            }
        }
            break;
        case 12:
        {
            if(self.btnClick)
            {
                self.btnClick(1);
            }
        }
            break;
        default:
            break;
    }
}
@end
