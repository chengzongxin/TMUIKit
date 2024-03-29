//
//  TMUIFilterToolbar.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TMUIFilterToolbar.h"
#import <Masonry/Masonry.h>
#import <TMUICore/TMUICore.h>
#import <TMUIExtensions/TMUIExtensions.h>
//#import "TMUIComponents.h"

@interface TMUIFilterToolbar ()


@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) UIView *line;


@end

@implementation TMUIFilterToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupviews];
    }
    return self;
}

- (void)setupviews{
    [self addSubview:self.resetBtn];
    [self addSubview:self.confirmBtn];
    self.tmui_borderPosition = TMUIViewBorderPositionTop;
    self.tmui_borderColor = UIColorBackgroundGray;
    self.tmui_borderWidth = 0.5;
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
}

- (void)tapItem:(UIButton *)btn{
    !_tapItem?:_tapItem(btn.tag);
}


- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton tmui_button];
        _resetBtn.tmui_text = @"重置";
        _resetBtn.tmui_titleColor = UIColorDark;
        _resetBtn.tmui_font = UIFont(16);
        _resetBtn.backgroundColor = UIColor.whiteColor;
        _resetBtn.tag = 0;
        [_resetBtn tmui_addTarget:self action:@selector(tapItem:)];
    }
    return _resetBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton tmui_button];
        _confirmBtn.tmui_text = @"确定";
        _confirmBtn.tmui_titleColor = UIColor.whiteColor;
        _confirmBtn.tmui_font = UIFont(16);
        _confirmBtn.backgroundColor = UIColorGreen;
        _confirmBtn.tag = 1;
        [_confirmBtn tmui_addTarget:self action:@selector(tapItem:)];
    }
    return _confirmBtn;
}
@end
