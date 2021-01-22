//
//  ShareMenu.m
//  Matafy
//
//  Created by Joe on 2019/5/28.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "ShareMenu.h"

static const CGFloat ScrollH = 113;
//static const CGFloat TitleViewH = 33;
static const CGFloat TitleViewH = 50;
static const CGFloat CloseButtonH = 52;
static NSString *ShareSlogan = @"share_slogan";

@interface ShareMenu ()

@property (nonatomic, strong) UIView           *container;

@end

@implementation ShareMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = ShareStyleBusiness;
    }
    return self;
}

- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts{
    return [self initWithTopIcons:topIcons topTexts:topTexts bottomIcons:nil bottomTexts:nil style:ShareStyleBusiness];
}

- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts style:(ShareStyle)style{
    return [self initWithTopIcons:topIcons topTexts:topTexts bottomIcons:nil bottomTexts:nil style:style];
}

- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts bottomIcons:(nullable NSArray *)bottomIcons bottomTexts:(nullable NSArray *)bottomTexts{
    return [self initWithTopIcons:topIcons topTexts:topTexts bottomIcons:bottomIcons bottomTexts:bottomTexts style:ShareStyleBusiness];
}

- (instancetype)initWithTopIcons:(NSArray *)topIcons topTexts:(NSArray *)topTexts bottomIcons:(NSArray *)bottomIcons bottomTexts:(NSArray *)bottomTexts style:(ShareStyle)style{
    self = [super init];
    if (self) {
        self.topIcons = topIcons;
        self.topTexts = topTexts;
        self.bottomIcons = bottomIcons;
        self.bottomTexts = bottomTexts;
        self.style = style;
        
        [self setupWithshareType:style];
    }
    return self;
}

- (void)setupWithshareType:(ShareStyle)style{
    
    if (style == ShareStyleBusiness) {
        // 商务模式
        self.frame = ScreenFrame;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, kMTFYScreenH, kMTFYScreenW, (ScrollH * (self.bottomIcons.count?2:1)) + TitleViewH + SafeAreaBottomHeight)];
        _container.backgroundColor = UIColor.whiteColor;
        [self addSubview:_container];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        visualEffectView.alpha = 1.0f;
        [_container addSubview:visualEffectView];
        
        CGFloat loganImgViewW = 186;
        UIImageView *loganImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kMTFYScreenW - loganImgViewW ) * 0.5, 14, loganImgViewW , 20)];
        loganImgView.image = [UIImage imageNamed:ShareSlogan];
        loganImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_container addSubview:loganImgView];
        _headerSloganImageView = loganImgView;
        
        UIButton *closeButton = [UIButton button];
        closeButton.frame = CGRectMake(kMTFYScreenW - 30, 17, 17, 17);
        [closeButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [closeButton setOkaImage:@"share_h5_x"];
        [closeButton addTarget:self action:@selector(dismiss)];
        [_container addSubview:closeButton];
        
        
        CGFloat itemWidth = kMTFYScreenW/self.topIcons.count;
        
        UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TitleViewH, kMTFYScreenW, ScrollH)];
        topScrollView.contentSize = CGSizeMake(itemWidth * self.topIcons.count, 80);
        topScrollView.showsHorizontalScrollIndicator = NO;
        topScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
        [_container addSubview:topScrollView];
        
        for (NSInteger i = 0; i < self.topIcons.count; i++) {
            ShareMenuItem *item = [[ShareMenuItem alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, ScrollH)];
            item.icon.image = [UIImage imageNamed:self.topIcons[i]];
            item.label.text = self.topTexts[i];
            item.tag = i;
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTopItemTap:)]];
            [item startAnimation:i*0.03f];
            [topScrollView addSubview:item];
            
            // 比价大赛
            if ([Global sharedInstance].isPriceContest && [item.label.text containsString:@"社区"]) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(item.icon.centerX+30, 0, 40, 16)];
                label.text = @"低价大赛";
                label.font = [UIFont systemFontOfSize:8];
                label.textColor = UIColor.whiteColor;
                label.backgroundColor = UIColor.redColor;
                label.textAlignment = NSTextAlignmentCenter;
                label.layer.cornerRadius = 8;
                label.layer.masksToBounds = YES;
                [item.icon addSubview:label];
            }
        }
        
        
        if (self.bottomIcons) {
            UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, TitleViewH + ScrollH, kMTFYScreenW, 0.5f)];
            splitLine.backgroundColor = HEXCOLOR(0xD8D8D8);
            [_container addSubview:splitLine];
            
            UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TitleViewH + ScrollH + 5, kMTFYScreenW, ScrollH)];
            bottomScrollView.contentSize = CGSizeMake(itemWidth * self.bottomIcons.count, 80);
            bottomScrollView.showsHorizontalScrollIndicator = NO;
            bottomScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
            [_container addSubview:bottomScrollView];
            
            for (NSInteger i = 0; i < self.bottomIcons.count; i++) {
                ShareMenuItem *item = [[ShareMenuItem alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, ScrollH)];
                item.icon.image = [UIImage imageNamed:self.bottomIcons[i]];
                item.label.text = self.bottomTexts[i];
                item.tag = i;
                [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBottomItemTap:)]];
                [item startAnimation:i*0.03f];
                [bottomScrollView addSubview:item];
            }
        }
    } else {
        // 社区模式
        self.frame = ScreenFrame;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)]];
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, kMTFYScreenH, kMTFYScreenW, (ScrollH * (self.bottomIcons.count?2:1)) + TitleViewH + CloseButtonH + SafeAreaBottomHeight)];
        _container.backgroundColor = UIColor.whiteColor;
        [self addSubview:_container];
        
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _container.layer.mask = shape;
        
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualEffectView.frame = self.bounds;
        visualEffectView.alpha = 1.0f;
        [_container addSubview:visualEffectView];

        CGFloat loganImgViewW = kAspectRatio(186);
        CGFloat loganImgViewH = kAspectRatio(20);
        UIImageView *loganImgView = [[UIImageView alloc]initWithFrame:CGRectMake((kMTFYScreenW - loganImgViewW ) * 0.5, (TitleViewH - loganImgViewH) * 0.5, loganImgViewW , loganImgViewH)];
        loganImgView.image = [UIImage imageNamed:ShareSlogan];
        [_container addSubview:loganImgView];
        _headerSloganImageView = loganImgView;

        CGFloat itemWidth = kMTFYScreenW/self.topIcons.count;

        UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TitleViewH, kMTFYScreenW, ScrollH)];
        topScrollView.contentSize = CGSizeMake(itemWidth * self.topIcons.count, 80);
        topScrollView.showsHorizontalScrollIndicator = NO;
        topScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
        [_container addSubview:topScrollView];
        
        for (NSInteger i = 0; i < self.topIcons.count; i++) {
            ShareMenuItem *item = [[ShareMenuItem alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, ScrollH)];
            item.icon.image = [UIImage imageNamed:self.topIcons[i]];
            item.label.text = self.topTexts[i];
            item.tag = i;
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTopItemTap:)]];
            [item startAnimation:i*0.03f];
            [topScrollView addSubview:item];
            
            // 比价大赛
            if ([Global sharedInstance].isPriceContest && [item.label.text containsString:@"社区"]) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(item.icon.centerX+30, 0, 40, 16)];
                label.text = @"低价大赛";
                label.font = [UIFont systemFontOfSize:8];
                label.textColor = UIColor.whiteColor;
                label.backgroundColor = UIColor.redColor;
                label.textAlignment = NSTextAlignmentCenter;
                label.layer.cornerRadius = 8;
                label.layer.masksToBounds = YES;
                [item.icon addSubview:label];
            }
        }
        
        
        if (self.bottomIcons) {
//            UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, TitleViewH + ScrollH, kMTFYScreenW, 0.5f)];
//            splitLine.backgroundColor = HEXCOLOR(0xD8D8D8);
//            [_container addSubview:splitLine];
            
            UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TitleViewH + ScrollH + 5, kMTFYScreenW, ScrollH)];
            bottomScrollView.contentSize = CGSizeMake(itemWidth * self.bottomIcons.count, 80);
            bottomScrollView.showsHorizontalScrollIndicator = NO;
            bottomScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 30);
            [_container addSubview:bottomScrollView];
            
            for (NSInteger i = 0; i < self.bottomIcons.count; i++) {
                ShareMenuItem *item = [[ShareMenuItem alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, ScrollH)];
                item.icon.image = [UIImage imageNamed:self.bottomIcons[i]];
                item.label.text = self.bottomTexts[i];
                item.tag = i;
                [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBottomItemTap:)]];
                [item startAnimation:i*0.03f];
                [bottomScrollView addSubview:item];
            }
        }
        
        UIButton *closeButton = [UIButton button];
        closeButton.backgroundColor = UIColor.whiteColor;
        closeButton.frame = CGRectMake(0, _container.height - CloseButtonH, KMainScreenWidth, CloseButtonH);
        closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [closeButton setOkaTitleColor:HEXCOLOR(0x1A1A1A)];
        [closeButton setOkaTitle:@"取消"];
        [closeButton addTarget:self action:@selector(dismiss)];
        [_container addSubview:closeButton];
    }
}


- (void)onTopItemTap:(UITapGestureRecognizer *)sender{
    [self dismiss];
    if (self.tapItem) {
        self.tapItem([NSIndexPath indexPathForItem:sender.view.tag inSection:0]);
    }
}

- (void)onBottomItemTap:(UITapGestureRecognizer *)sender{\
    [self dismiss];
    if (self.tapItem) {
        self.tapItem([NSIndexPath indexPathForItem:sender.view.tag inSection:1]);
    }
}

- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
}

- (void)setBackgroundViewColor:(UIColor *)color{
    _container.backgroundColor = color;
}

- (void)show {
    if ([KEY_WINDOW.subviews containsObject:self]) {
        return;
    }
    [KEY_WINDOW addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    
    if (self.dismissHandle) {
        self.dismissHandle();
    }
    
}

@end

#pragma Item view

@implementation ShareMenuItem
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"iconHomeAllshareCopylink"];
        _icon.contentMode = UIViewContentModeCenter;
        _icon.userInteractionEnabled = YES;
        [self addSubview:_icon];
        
        _label = [[UILabel alloc] init];
        _label.text = @"TEXT";
        _label.textColor = HEXCOLOR(0x8F8F8F);
        _label.font = SmallFont;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
-(void)startAnimation:(NSTimeInterval)delayTime {
    CGRect originalFrame = self.frame;
    self.frame = CGRectMake(CGRectGetMinX(originalFrame), 35, originalFrame.size.width, originalFrame.size.height);
    [UIView animateWithDuration:0.9f
                          delay:delayTime
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = originalFrame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-20);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(30);
        make.left.right.equalTo(self);
    }];
}


@end
