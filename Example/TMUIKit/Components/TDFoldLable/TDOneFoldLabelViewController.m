//
//  TDOneFoldLabelViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/3/25.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDOneFoldLabelViewController.h"

@interface TDOneFoldLabelViewController ()

@property (nonatomic, assign) NSInteger lineSpace;

@end

@implementation TDOneFoldLabelViewController

- (void)rightClick{
    
    self.lineSpace++;
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setupviews];
}

- (void)setupviews{
    // 注意这里的段落必须用NSLineBreakByWordWrapping，否则不会计算换行
//    NSParagraphStyle *style = [NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:30 lineBreakMode:NSLineBreakByWordWrapping];
    NSParagraphStyle *style = [NSMutableParagraphStyle tmui_paragraphStyleWithLineSpacing:self.lineSpace lineBreakMode:NSLineBreakByWordWrapping];
    
    
    NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSForegroundColorAttributeName:UIColor.tmui_randomColor,NSFontAttributeName:UIFont(18),NSParagraphStyleAttributeName:style}];
    
    
    NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSForegroundColorAttributeName:UIColor.tmui_randomColor,NSFontAttributeName:UIFont(16),NSParagraphStyleAttributeName:style}];
    
    
    NSAttributedString *attr3 = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSForegroundColorAttributeName:UIColor.tmui_randomColor,NSFontAttributeName:UIFont(14),NSParagraphStyleAttributeName:style}];
    
    
    NSAttributedString *attr4 = [[NSAttributedString alloc] initWithString:[self contentStr] attributes:@{NSForegroundColorAttributeName:UIColor.tmui_randomColor,NSFontAttributeName:UIFont(12),NSParagraphStyleAttributeName:style}];
    
    
    TMUIFoldLabel *label1 = [[TMUIFoldLabel alloc] init];
    label1.numberOfLines = 1;
    label1.attributedText = attr1;
    [self.view addSubview:label1];
    
    TMUIFoldLabel *label2 = [[TMUIFoldLabel alloc] init];
    label2.numberOfLines = 2;
    label2.attributedText = attr2;
    [self.view addSubview:label2];
    
    TMUIFoldLabel *label3 = [[TMUIFoldLabel alloc] init];
    label3.numberOfLines = 3;
    label3.attributedText = attr3;
    [self.view addSubview:label3];
    
    TMUIFoldLabel *label4 = [[TMUIFoldLabel alloc] init];
    label4.numberOfLines = 4;
    label4.attributedText = attr4;
    [self.view addSubview:label4];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NavigationContentTop + 20);
        make.left.right.mas_equalTo(0);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
    }];
    
    
    CGSize size1 = [label1 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
    
    UIView *debugView1 = [[UIView alloc] init];
    debugView1.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.5];
    [self.view insertSubview:debugView1 atIndex:0];
    [debugView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(label1);
        make.size.mas_equalTo(size1);
    }];
    
    CGSize size2 = [label2 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
    
    UIView *debugView2 = [[UIView alloc] init];
    debugView2.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.5];
    [self.view insertSubview:debugView2 atIndex:0];
    [debugView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(label2);
        make.size.mas_equalTo(size2);
    }];
    
    CGSize size3 = [label3 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
    
    UIView *debugView3 = [[UIView alloc] init];
    debugView3.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.5];
    [self.view insertSubview:debugView3 atIndex:0];
    [debugView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(label3);
        make.size.mas_equalTo(size3);
    }];
    
    CGSize size4 = [label4 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
    
    UIView *debugView4 = [[UIView alloc] init];
    debugView4.backgroundColor = [UIColor.tmui_randomColor colorWithAlphaComponent:0.5];
    [self.view insertSubview:debugView4 atIndex:0];
    [debugView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(label4);
        make.size.mas_equalTo(size4);
    }];
    
    @weakify(label1);
    label1.clickFold = ^(BOOL isFold, TMUIFoldLabel * _Nonnull label){
        @strongify(label1);
        [debugView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            CGSize size = [label1 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
        }];
    };
    
    @weakify(label2);
    label2.clickFold = ^(BOOL isFold, TMUIFoldLabel * _Nonnull label){
        @strongify(label2);
        [debugView2 mas_updateConstraints:^(MASConstraintMaker *make) {
            CGSize size = [label2 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
        }];
    };
    
    @weakify(label3);
    label3.clickFold = ^(BOOL isFold, TMUIFoldLabel * _Nonnull label){
        @strongify(label3);
        [debugView3 mas_updateConstraints:^(MASConstraintMaker *make) {
            CGSize size = [label3 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
        }];
    };
    
    @weakify(label4);
    label4.clickFold = ^(BOOL isFold, TMUIFoldLabel * _Nonnull label){
        @strongify(label4);
        [debugView4 mas_updateConstraints:^(MASConstraintMaker *make) {
            CGSize size = [label4 sizeThatFits:CGSizeMake(TMUI_SCREEN_WIDTH, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
        }];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"增大行高" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
    self.lineSpace = 5;
    [self setupviews];
}


- (NSString *)contentStr {
    NSString *str = @"最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new最新入驻的三家公司，在样式上logo外围增加一个圈，同时五家装修公司都增加new";
    return str;
}



@end
