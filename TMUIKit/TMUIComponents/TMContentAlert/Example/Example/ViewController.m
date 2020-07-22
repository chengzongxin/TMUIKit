//
//  ViewController.m
//  Example
//
//  Created by nigel.ning on 2020/4/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UIView *alertContentView;
@property (nonatomic, assign)BOOL useAnimate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"无动画弹框";
    }else {
        cell.textLabel.text = @"自定义动画效果弹框";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self showAlerView];
    }else {
        [self showAlertViewWithAnimate];
    }
}

- (void)showAlerView {
    self.useAnimate = NO;
    [TMContentAlert showFromViewController:self loadContentView:^(__kindof UIViewController * _Nonnull toShowVc) {
        UIView *view = [self createAlertContentView];
        self.alertContentView = view;
        [toShowVc.view addSubview:self.alertContentView];
        [self.alertContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(toShowVc.view);
            make.centerY.mas_equalTo(toShowVc.view.mas_centerY).mas_offset(-50);
            make.leading.mas_equalTo(40);
            make.trailing.mas_equalTo(-40);
        }];
        toShowVc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } didShowBlock:^{
        NSLog(@"alert view did show");
    }];
}

- (void)showAlertViewWithAnimate {
    self.useAnimate = YES;
    __block UIViewController *vc = nil;
    [TMContentAlert showFromViewController:self loadContentView:^(__kindof UIViewController * _Nonnull toShowVc) {
        vc = toShowVc;
        UIView *view = [self createAlertContentView];
        self.alertContentView = view;
        [toShowVc.view addSubview:self.alertContentView];
        [self.alertContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(toShowVc.view);
            make.centerY.mas_equalTo(toShowVc.view.mas_centerY).mas_offset(-50);
            make.leading.mas_equalTo(40);
            make.trailing.mas_equalTo(-40);
        }];
        self.alertContentView.alpha = 0;
        self.alertContentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } didShowBlock:^{
        NSLog(@"alert view did show");
        [UIView animateWithDuration:0.3 animations:^{
            vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            self.alertContentView.alpha = 1;
            self.alertContentView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (UIView *)createAlertContentView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 160)];
    view.backgroundColor = [UIColor whiteColor];
    view.clipsToBounds = YES;
    
    UILabel *titleLbl = [[UILabel alloc] init];
    [view addSubview:titleLbl];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *msgLbl = [[UILabel alloc] init];
    [view addSubview:msgLbl];
    msgLbl.textAlignment = NSTextAlignmentCenter;
    msgLbl.numberOfLines = 2;
    
    UIButton *okBtn = [[UIButton alloc] init];
    [okBtn setBackgroundColor:[UIColor redColor]];
    [view addSubview:okBtn];
    [okBtn setTitle:@"知道了" forState:UIControlStateNormal];
        
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    [msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.top.mas_equalTo(titleLbl.mas_bottom).mas_offset(20);
    }];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(view);
        make.top.mas_equalTo(msgLbl.mas_bottom).mas_offset(30);
    }];
    
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 4;
    okBtn.layer.cornerRadius = 4;
    [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    titleLbl.text = @"标题提醒";
    msgLbl.text = @"消息描述串";
        
    return view;
}

- (void)okBtnClick {
    if (self.useAnimate) {
        if (self.alertContentView) {
            UIViewController *vc = self.alertContentView.tmui_viewController;
            [UIView animateWithDuration:0.3 animations:^{
                vc.view.alpha = 0;
            } completion:^(BOOL finished) {
                [TMContentAlert hiddenContentView:self.alertContentView didHiddenBlock:^{
                    NSLog(@"did hidden");
                }];
            }];
        }
    }else {
        if (self.alertContentView) {
            [TMContentAlert hiddenContentView:self.alertContentView didHiddenBlock:^{
                NSLog(@"did hidden");
            }];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
