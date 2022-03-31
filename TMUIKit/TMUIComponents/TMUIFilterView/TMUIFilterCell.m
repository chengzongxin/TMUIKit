//
//  TMUIFilterCell.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TMUIFilterCell.h"
#import "Masonry.h"
#import "TMUIExtensions.h"
#import "TMUICore.h"
@interface TMUIFilterCell ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation TMUIFilterCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupviews];
    }
    return self;
}

- (void)setupviews {
    [self.contentView addSubview:self.btn];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected{
    _btn.selected = selected;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton tmui_button];
        _btn.backgroundColor = UIColorHex(F6F8F6);
        _btn.titleLabel.font = UIFont(14);
        [_btn setTitleColor:UIColorHex(7E807E) forState:UIControlStateNormal];
        [_btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_btn tmui_setNormalBackGroundColor:UIColorHex(F6F8F6) selectedBackGroundColor:UIColorHex(22C77D)];
        _btn.cornerRadius = 4;
        _btn.userInteractionEnabled = NO;
//        _btn.enabled = NO;
    }
    return _btn;
}

@end
