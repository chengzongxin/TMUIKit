//
//  VersionView.m
//  silu
//
//  Created by sawyerzhang on 2016/10/26.
//  Copyright © 2016年 upintech. All rights reserved.
//

#import "VersionView.h"
#import "AppDelegate.h"
@interface VersionView ()
@property (strong , nonatomic) UIView *showView;
@property (strong , nonatomic) UILabel *changeContent;
@property (strong , nonatomic) UILabel *versionLabel;
@property (strong , nonatomic) UIView *transparentView;
@property (strong , nonatomic) UITextView *textView;
@property (copy , nonatomic) NSString *url;
@property (assign ,nonatomic) NSInteger forceUpdate;  // 0不强制，1强制更新
@property (strong , nonatomic) UIButton *updateBtn;
@end

@implementation VersionView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIView *transparentView = [[UIView alloc] init]; /// 透明View
    self.transparentView = transparentView;
    [self addSubview:transparentView];
    [transparentView setAlpha:0.6];
    transparentView.backgroundColor = [UIColor blackColor];
    [transparentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.bottom.top.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *transparentViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transparentTap)];
    [transparentView addGestureRecognizer:transparentViewTap];
    UIView *showView  = [[UIView alloc] init];
    self.showView = showView;
    showView.layer.cornerRadius = 9.5;
    showView.backgroundColor = [UIColor clearColor];
    showView.layer.masksToBounds = YES;
    [self addSubview:showView];
    NSInteger height;
    if(KIsiPhoneX){
        height = 100;
    }else{
        height = 76;
    }
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kAspectRatio(315));
        make.height.mas_equalTo(kAspectRatio(450));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(transparentView.mas_top).offset(height);
    }];
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [showView addGestureRecognizer:tap];
    UIImageView *image_1 = [[UIImageView alloc] init];
    [image_1 setImage:[UIImage imageNamed:@"newversion"]];
    [showView addSubview:image_1];
    [image_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(showView);
    }];
    image_1.backgroundColor = [UIColor clearColor];

    UILabel *label  = [UILabel new];
    [label sizeToFit];
    label.text = kLStr(@"common_find_new_version");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20 weight:500];
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [showView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(showView.mas_left).offset(30);
        make.top.mas_equalTo(showView.mas_top).offset(80);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"1.1.1.1.1";
    self.versionLabel = versionLabel;
    versionLabel.font = [UIFont systemFontOfSize:15 weight:500];
    versionLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [versionLabel sizeToFit];
    [showView addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(label);
        make.top.mas_equalTo(label.mas_bottom).offset(3);
        
    }];

    UILabel *changeContent = [[UILabel alloc] init];
    self .changeContent = changeContent;
    [changeContent sizeToFit];
//    changeContent.text = @"更新内容:";
    changeContent.textColor =  [UIColor colorWithRed:68.0/255.0 green:68.0 / 255.0 blue:68.0/ 255.0 alpha:1];
    changeContent.font = [UIFont systemFontOfSize:kAspectRatio(16)];
    [showView addSubview:changeContent];
    [changeContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(showView.mas_leading).offset(kAspectRatio(30));
        make.top.mas_equalTo(versionLabel.mas_bottom).offset(40);
    }];
    
    self.textView = [[UITextView alloc] init];
    self.textView.editable = NO;
//    self.textView.font = [UIFont fontWithName:@"SFProText-Medium" size:20];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:192/255.0 alpha:1/1.0];
    self.textView.backgroundColor = [UIColor whiteColor];
    [showView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(changeContent.mas_left);
        make.top.mas_equalTo(changeContent.mas_bottom).offset(0);
        make.right.mas_equalTo(showView.mas_right).offset(-15);
        make.bottom.mas_equalTo(showView.mas_bottom).offset(-85);
    }];

    _updateBtn = [[UIButton alloc] init];
    [_updateBtn setBackgroundImage:[UIImage imageNamed:kLStr(@"common_alert_update_now")] forState:UIControlStateNormal];
    [_updateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_updateBtn setTitle:kLStr(@"common_alert_update_now") forState:UIControlStateNormal];
    [_updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    _updateBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:500];
    [_updateBtn setBackgroundColor: [UIColor colorWithRed:19.0/255.0 green:118.0 / 255.0 blue:254.0/ 255.0 alpha:1]];
    [_updateBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    _updateBtn.layer.cornerRadius = 25;
    _updateBtn.layer.masksToBounds = YES;
    [showView addSubview:_updateBtn];
    [_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kAspectRatio(255));
        make.height.mas_equalTo(kAspectRatio(50));
        make.centerX.mas_equalTo(showView);
        make.bottom.mas_equalTo(showView).offset(-kAspectRatio(25));
    }];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 28 * 0.5;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    NSInteger canheight;
    if(KIsiPhoneX){
        canheight = 100;
    }else{
        canheight = 66;
    }
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.bottom.mas_equalTo(showView.mas_bottom).offset(canheight);
        make.centerX.mas_equalTo(transparentView);
    }];
}

-(void)layoutSubviews
{
    UITableView *tableview = (UITableView *)self.superview;
    if ([tableview isKindOfClass:[UITableView class]]) {
        tableview.scrollEnabled = NO;
    }
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.versionLabel.text = [dic objectForKey:@"versionNumber"];
    self.textView.text = [dic objectForKey:@"updateContent"];
    self.url = [dic objectForKey:@"updateUrl"];
    self.forceUpdate = [[dic objectForKey:@"forceUpdate"] integerValue];
    if(self.forceUpdate == 1){
        [_updateBtn setTitle:kLStr(@"common_alert_update_now") forState:UIControlStateNormal];
    }
    
}

//-(void)setCounts:(NSInteger)counts{
//    _counts = counts;
//    for(NSInteger index = 0 ; index < counts; index ++){
//        UILabel *contentLabel = [[UILabel alloc] init];
//        contentLabel.font = [UIFont fontWithName:@"SFProText-Medium" size:14];
//        contentLabel.textColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:192/255.0 alpha:1/1.0];
//        contentLabel.numberOfLines = 0;
//        contentLabel.tag = (index + 1);
//        contentLabel.text = self.versionInfo[index]; /// 显示更新内容
//        [contentLabel sizeToFit];
//        [self.showView addSubview:contentLabel];
//        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(self.changeContent);
//            make.trailing.mas_equalTo(self.showView.mas_trailing).offset(-kAspectRatio(20));
//            if (index == 0) {
//                [self viewWithTag:1];
//                make.top.mas_equalTo(self.changeContent.mas_bottom).offset(kAspectRatio(7));
//            }else{
//                UIView *tagView = [self viewWithTag:index];
//                make.top.mas_equalTo(tagView.mas_bottom).offset(kAspectRatio(5));
//            }
//        }];
//    }
//}

- (void)btnClick:(UIButton *)button{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.url]];
}

- (void)setVersion:(NSString *)version{
    _version = version;
    self.versionLabel.text = version;
}

- (void)btnAction:(UIButton *)button{
    if(self.forceUpdate == 1){
        [self exitApplication];
    }else{
    [self removeFromSuperview];
    }
}

// 退出app
- (void)exitApplication {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        
        window.alpha = 0;
        
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        
    } completion:^(BOOL finished) {
        
        exit(0);
        
    }];
    
    //exit(0);
    
}

- (void)transparentTap{
//    UITableView *tableview = (UITableView *)self.superview;
//    if ([tableview isKindOfClass:[UITableView class]]) {
//        tableview.scrollEnabled = YES;
//    }else{
//        if (self.forceUpdate == 1) {
//            [self exitApplication];
//        }else{
//        [self removeFromSuperview];
//        }
//    }
}

- (void)tapClick{

}

#pragma mark - 懒加载
- (NSArray<NSString *> *)versionInfo{
    if(_versionInfo == nil){
        _versionInfo = [NSArray array];
    }
    return _versionInfo;
}
@end
