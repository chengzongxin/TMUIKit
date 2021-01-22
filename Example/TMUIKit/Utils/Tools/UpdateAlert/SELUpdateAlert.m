//
//  SELUpdateAlert.m
//  SelUpdateAlert
//
//  Created by zhuku on 2018/2/7.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SELUpdateAlert.h"
#import "SELUpdateAlertConst.h"

#define DEFAULT_MAX_HEIGHT (kMTFYScreenH - 88)
#define DESC_MAX_HEIGHT (DEFAULT_MAX_HEIGHT - 62 - 92)

@interface SELUpdateAlert()

/** 版本号 */
@property (nonatomic, copy) NSString *title;
/** 版本更新内容 */
@property (nonatomic, copy) NSString *desc;

@end

@implementation SELUpdateAlert

/**
 添加版本更新提示

 @param version 版本号
 @param descriptions 版本更新内容（数组）
 
 descriptions 格式如 @[@"1.xxxxxx",@"2.xxxxxx"]
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Descriptions:(NSArray *)descriptions
{
    if (!descriptions || descriptions.count == 0) {
        return;
    }
    
    //数组转换字符串，动态添加换行符\n
    NSString *description = @"";
    for (NSInteger i = 0;  i < descriptions.count; ++i) {
        id desc = descriptions[i];
        if (![desc isKindOfClass:[NSString class]]) {
            return;
        }
        description = [description stringByAppendingString:desc];
        if (i != descriptions.count-1) {
            description = [description stringByAppendingString:@"\n"];
        }
    }
    NSLog(@"====%@",description);
    SELUpdateAlert *updateAlert = [[SELUpdateAlert alloc]initVersion:version description:description];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}

/**
 添加版本更新提示

 @param version 版本号
 @param description 版本更新内容（字符串）
 
description 格式如 @"1.xxxxxx\n2.xxxxxx"
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Description:(NSString *)description
{
    SELUpdateAlert *updateAlert = [[SELUpdateAlert alloc]initVersion:version description:description];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}

+ (void)showUpdateAlertWithVersion:(NSString *)title
                       description:(NSString *)description
                          onAction:(ClickAction)clickAction
{
    SELUpdateAlert *updateAlert = [[SELUpdateAlert alloc] initVersion:title description:description];
    updateAlert.clickAction = clickAction;
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}

- (instancetype)initVersion:(NSString *)version description:(NSString *)description
{
    self = [super init];
    if (self) {
        self.title = version;
        self.desc = description;
        
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    
    //获取更新内容高度
    CGFloat descHeight = [self _sizeofString:self.desc font:[UIFont systemFontOfSize:SELDescriptionFont] maxSize:CGSizeMake(self.frame.size.width - 100, self.frame.size.height - 127- 110)].height;
    
    //bgView实际高度,(desc 计算后)
    CGFloat realHeight = descHeight + 62 + 92;
    
    //bgView最大高度
    CGFloat maxHeight = DEFAULT_MAX_HEIGHT;
    //更新内容可否滑动显示
    BOOL scrollEnabled = NO;
    
    //重置bgView最大高度 设置更新内容可否滑动显示
    if (realHeight > DEFAULT_MAX_HEIGHT) {
        scrollEnabled = YES;
        descHeight = DESC_MAX_HEIGHT;
    }else
    {
        maxHeight = realHeight;
    }
    
    //backgroundView
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = [UIScreen mainScreen].bounds;
    bgView.center = self.center;
    [self addSubview:bgView];
    
    //添加更新提示
    UIView *updateView = [[UIView alloc]initWithFrame:CGRectMake(15, 64, bgView.frame.size.width - 30, maxHeight)];
    updateView.backgroundColor = [UIColor whiteColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 5.0f;
    [bgView addSubview:updateView];
    
    //20+166+10+28+10+descHeight+20+40+20 = 314+descHeight 内部元素高度计算bgView高度
//    UIImageView *updateIcon = [[UIImageView alloc]initWithFrame:CGRectMake((updateView.frame.size.width - Ratio(178))/2, Ratio(20), Ratio(178), Ratio(166))];
//    updateIcon.image = [UIImage imageNamed:@"VersionUpdate_Icon"];
//    [updateView addSubview:updateIcon];
    
    //版本号
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, updateView.frame.size.width, 20)];
    versionLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    versionLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1/1.0];
    versionLabel.font = [UIFont boldSystemFontOfSize:18];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = self.title;
    [updateView addSubview:versionLabel];
    
    //更新内容
    UITextView *descTextView = [[UITextView alloc]initWithFrame:CGRectMake(35, 16 + CGRectGetMaxY(versionLabel.frame), updateView.frame.size.width - 70, descHeight)];
    descTextView.font = [UIFont systemFontOfSize:SELDescriptionFont];
    descTextView.textContainer.lineFragmentPadding = 0;
    descTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    descTextView.editable = NO;
    descTextView.selectable = NO;
    descTextView.scrollEnabled = scrollEnabled;
    descTextView.showsVerticalScrollIndicator = scrollEnabled;
    descTextView.showsHorizontalScrollIndicator = NO;
    descTextView.textColor = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1/1.0];
    descTextView.text = self.desc;
    [updateView addSubview:descTextView];
    
    if (scrollEnabled) {
        //若显示滑动条，提示可以有滑动条
        [descTextView flashScrollIndicators];
    }
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(35, CGRectGetMaxY(descTextView.frame) + 33, 108, 32);
    cancelButton.backgroundColor =  [UIColor colorWithRed:201/255.0 green:205/255.0 blue:208/255.0 alpha:1/1.0];
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 16.0f;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitle:kLStr(@"common_btn_reject") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateView addSubview:cancelButton];
    
    //更新按钮
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    updateButton.frame = CGRectMake(updateView.frame.size.width - 35 - 108, CGRectGetMaxY(descTextView.frame) + 33, 108, 32);
    updateButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:195/255.0 blue:206/255.0 alpha:1/1.0];
    updateButton.clipsToBounds = YES;
    updateButton.layer.cornerRadius = 16.0f;
    [updateButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    updateButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [updateButton setTitle:kLStr(@"common_btn_read_accept") forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [updateView addSubview:updateButton];
    
    
    
    //显示更新
    [self showWithAlert:bgView];
}

/** 更新按钮点击事件 跳转AppStore更新 */
- (void)confirmAction
{
    if (self.clickAction) {
        self.clickAction(YES);
    }
    [self dismissAlert];
}

/** 取消按钮点击事件 */
- (void)cancelAction
{
    if (self.clickAction) {
        self.clickAction(NO);
    }
    [self dismissAlert];
}

/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = SELAnimationTimeInterval;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}


/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
    
}

/**
 计算字符串高度
 @param string 字符串
 @param font 字体大小
 @param maxSize 最大Size
 @return 计算得到的Size
 */
- (CGSize)_sizeofString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}




@end
