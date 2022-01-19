//
//  TDDialogViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/1/19.
//  Copyright © 2022 chengzongxin. All rights reserved.
//
static NSString * const kSectionTitleForNormal = @"TMUIDialogViewController";
static NSString * const kSectionTitleForSelection = @"TMUIDialogSelectionViewController";
static NSString * const kSectionTitleForTextField = @"TMUIDialogTextFieldViewController";

#define Row_Modal(x,y) \
Row.str(self.dataSource[x].allKeys[y]).fnt(18).detailStr(self.dataSource[x].allValues[y]).subtitleStyle.cellHeightAuto.onClick(^{\
[self didSelectCellWithTitle:self.dataSource[x].allKeys[y]];\
})

#import "TDDialogViewController.h"
#import "TMUIDialogViewController.h"
#import "TMUITips.h"

@interface TDDialogViewController ()
@property(nonatomic, weak) TMUIDialogTextFieldViewController *currentTextFieldDialogViewController;
@property(nonatomic, strong) TMUIOrderedDictionary <NSString *,TMUIOrderedDictionary *>*dataSource;
@end

@implementation TDDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     kSectionTitleForNormal, [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                              @"普通弹窗", @"",
                                                              @"支持自定义样式", @"可通过 appearance 方式来统一修改全局样式",
                                                              nil],
                                     kSectionTitleForSelection, [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                                 @"列表弹窗", @"支持显示一个列表",
                                                                 @"支持单选", @"最多只能勾选一个 item，不可不选",
                                                                 @"支持多选", @"可同时勾选多个 item，可全部取消勾选",
                                                                 nil],
                                     kSectionTitleForTextField, [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                                 @"输入框弹窗", @"",
                                                                 @"支持通过键盘 Return 按键触发弹窗提交按钮事件", @"默认开启，当需要自己管理输入框 shouldReturn 事件时请将其关闭",
                                                                 @"支持自动控制提交按钮的 enable 状态", @"默认开启，只要文字不为空则允许点击",
                                                                 @"支持自定义提交按钮的 enable 状态", @"通过 block 来控制状态",
                                                                 nil],
                                     nil];
    
    
    
    GroupTV(
            Section(
                    Row_Modal(0, 0),
                    Row_Modal(0, 1),
                    ).title(self.dataSource.allKeys[0]),
            Section(
                    Row_Modal(1, 0),
                    Row_Modal(1, 1),
                    Row_Modal(1, 2),
                    ).title(self.dataSource.allKeys[1]),
            Section(
                    Row_Modal(2, 0),
                    Row_Modal(2, 1),
                    Row_Modal(2, 2),
                    Row_Modal(2, 3),
                    ).title(self.dataSource.allKeys[2]),
            ).embedIn(self.view);
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"普通弹窗"]) {
        [self showNormalDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持自定义样式"]) {
        [self showAppearanceDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"列表弹窗"]) {
        [self showNormalSelectionDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持单选"]) {
        [self showRadioSelectionDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持多选"]) {
        [self showMultipleSelectionDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"输入框弹窗"]) {
        [self showNormalTextFieldDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持通过键盘 Return 按键触发弹窗提交按钮事件"]) {
        [self showReturnKeyDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持自动控制提交按钮的 enable 状态"]) {
        [self showSubmitButtonEnablesDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持自定义提交按钮的 enable 状态"]) {
        [self showCustomSubmitButtonEnablesDialogViewController];
        return;
    }
}


- (void)showNormalDialogViewController {
    TMUIDialogViewController *dialogViewController = [[TMUIDialogViewController alloc] init];
    dialogViewController.title = @"标题";
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    contentView.backgroundColor = UIColorWhite;
    UILabel *label = [[UILabel alloc] tmui_initWithFont:UIFontMake(14) textColor:UIColorBlack];
    label.text = @"自定义contentView";
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetWidth(contentView.bounds) / 2.0, CGRectGetHeight(contentView.bounds) / 2.0);
    [contentView addSubview:label];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
    }];
    [dialogViewController show];
}

- (void)showAppearanceDialogViewController {
    TMUIDialogViewController *dialogViewController = [[TMUIDialogViewController alloc] init];
    dialogViewController.title = @"标题";
    dialogViewController.titleView.subtitle = @"副标题";
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    contentView.backgroundColor = UIColor.td_tintColor;
    UILabel *label = [[UILabel alloc] tmui_initWithFont:UIFontMake(14) textColor:UIColorWhite];
    label.text = @"自定义contentView";
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetWidth(contentView.bounds) / 2.0, CGRectGetHeight(contentView.bounds) / 2.0);
    [contentView addSubview:label];
    dialogViewController.contentView = contentView;
    
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
    }];
    
    // === 自定义样式 ===
    dialogViewController.headerViewBackgroundColor = UIColor.td_tintColor;
    dialogViewController.headerSeparatorColor = nil;
    dialogViewController.footerSeparatorColor = nil;
    
    // titleView
    dialogViewController.titleView.style = TMUINavigationTitleViewStyleSubTitleVertical;
    dialogViewController.titleView.verticalTitleFont = UIFontBoldMake(17);
    dialogViewController.titleTintColor = UIColorWhite;
    dialogViewController.titleLabelTextColor = nil;
    dialogViewController.subTitleLabelTextColor = nil;
    
    dialogViewController.buttonHighlightedBackgroundColor = [dialogViewController.headerViewBackgroundColor tmui_colorWithAlphaAddedToWhite:.3];
    NSMutableDictionary *buttonTitleAttributes = dialogViewController.buttonTitleAttributes.mutableCopy;
    buttonTitleAttributes[NSForegroundColorAttributeName] = dialogViewController.headerViewBackgroundColor;
    dialogViewController.buttonTitleAttributes = buttonTitleAttributes;
    [dialogViewController.submitButton setImage:[[UIImageMake(@"icon_emotion") tmui_imageResizedInLimitedSize:CGSizeMake(18, 18) resizingMode:TMUIImageResizingModeScaleToFill] tmui_imageWithTintColor:buttonTitleAttributes[NSForegroundColorAttributeName]] forState:UIControlStateNormal];
    dialogViewController.submitButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    
    [dialogViewController show];
}

- (void)showNormalSelectionDialogViewController {
    TMUIDialogSelectionViewController *dialogViewController = [[TMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"支持的语言";
    dialogViewController.items = @[@"简体中文", @"繁体中文", @"英语（美国）", @"英语（英国）"];
    dialogViewController.cellForItemBlock = ^(TMUIDialogSelectionViewController *aDialogViewController, TMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (TMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    __weak __typeof(dialogViewController)weakDialogViewController = dialogViewController;
    dialogViewController.didSelectItemBlock = ^(TMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        [TMUITips showInfo:weakDialogViewController.items[itemIndex] inView:self.view];
        [aDialogViewController hide];
    };
    [dialogViewController show];
}

- (void)showRadioSelectionDialogViewController {
    TMUIOrderedDictionary *citys = [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                    @"北京", @"吃到的第一个菜肯定是烤鸭吧！",
                                    @"广东", @"听说那里的人一日三餐都吃🐍🐸🐛🦂😋",
                                    @"上海", @"好像现在全世界的蟹都叫大闸蟹？",
                                    @"成都", @"你分得清冒菜和麻辣烫、龙抄手和馄饨吗？",
                                    nil];
    TMUIDialogSelectionViewController *dialogViewController = [[TMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"你去过哪里？";
    dialogViewController.items = citys.allKeys;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogViewController *aDialogViewController) {
        TMUIDialogSelectionViewController *d = (TMUIDialogSelectionViewController *)aDialogViewController;
        if (d.selectedItemIndex == TMUIDialogSelectionViewControllerSelectedItemIndexNone) {
            [TMUITips showError:@"请至少选一个" inView:d.tmui_modalPresentationViewController.view hideAfterDelay:1.2];
            return;
        }
        NSString *city = d.items[d.selectedItemIndex];
        NSString *resultString = (NSString *)[citys objectForKey:city];
        [aDialogViewController hideWithAnimated:YES completion:^(BOOL finished) {
            [TMUITips showWithText:resultString];
//            TMUIAlertController *alertController = [TMUIAlertController alertControllerWithTitle:resultString message:nil preferredStyle:TMUIAlertControllerStyleAlert];
//            TMUIAlertAction *action = [TMUIAlertAction actionWithTitle:@"好" style:TMUIAlertActionStyleCancel handler:nil];
//            [alertController addAction:action];
//            [alertController showWithAnimated:YES];
        }];
    }];
    [dialogViewController show];
}

- (void)showMultipleSelectionDialogViewController {
    TMUIDialogSelectionViewController *dialogViewController = [[TMUIDialogSelectionViewController alloc] init];
    dialogViewController.titleView.style = TMUINavigationTitleViewStyleSubTitleVertical;
    dialogViewController.title = @"你常用的编程语言";
    dialogViewController.titleView.subtitle = @"可多选";
    dialogViewController.allowsMultipleSelection = YES;// 打开多选
    dialogViewController.items = @[@"Objective-C", @"Swift", @"Java", @"JavaScript", @"Python", @"PHP"];
    dialogViewController.cellForItemBlock = ^(TMUIDialogSelectionViewController *aDialogViewController, TMUITableViewCell *cell, NSUInteger itemIndex) {
        if ([aDialogViewController.items[itemIndex] isEqualToString:@"JavaScript"]) {
            cell.detailTextLabel.text = @"包含前后端";
        } else {
            cell.detailTextLabel.text = nil;
        }
    };
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    __weak __typeof(self)weakSelf = self;
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogViewController *aDialogViewController) {
        TMUIDialogSelectionViewController *d = (TMUIDialogSelectionViewController *)aDialogViewController;
        [d hide];
        
        if ([d.selectedItemIndexes containsObject:@(5)]) {
            [TMUITips showInfo:@"PHP 是世界上最好的编程语言" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(4)]) {
            [TMUITips showInfo:@"你代码缩进用 Tab 还是 Space？" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(3)]) {
            [TMUITips showInfo:@"JavaScript 即将一统江湖" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(2)]) {
            [TMUITips showInfo:@"Android 7 都出了，我还在兼容 Android 4" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(0)] || [d.selectedItemIndexes containsObject:@(1)]) {
            [TMUITips showInfo:@"iOS 开发你好" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
    }];
    [dialogViewController show];
}

- (void)showNormalTextFieldDialogViewController {
    TMUIDialogTextFieldViewController *dialogViewController = [[TMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"注册用户";
    [dialogViewController addTextFieldWithTitle:@"昵称" configurationHandler:^(TMUILabel *titleLabel, TMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"不超过10个字符";
        textField.maximumTextLength = 10;
    }];
    [dialogViewController addTextFieldWithTitle:@"密码" configurationHandler:^(TMUILabel *titleLabel, TMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"6位数字";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.maximumTextLength = 6;
        textField.secureTextEntry = YES;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = NO;// 为了演示效果与第二个 cell 的区分开，这里手动置为 NO，平时的默认值为 YES
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogTextFieldViewController *aDialogViewController) {
        if (aDialogViewController.textFields.firstObject.text.length > 0) {
            [aDialogViewController hide];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
            });
        } else {
            [TMUITips showInfo:@"请填写内容" inView:self.view hideAfterDelay:1.2];
        }
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

- (void)showReturnKeyDialogViewController {
    TMUIDialogTextFieldViewController *dialogViewController = [[TMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入别名";
    [dialogViewController addTextFieldWithTitle:nil configurationHandler:^(TMUILabel *titleLabel, TMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"点击键盘 Return 键视为点击确定按钮";
        textField.maximumTextLength = 10;
    }];
    dialogViewController.shouldManageTextFieldsReturnEventAutomatically = YES;// 让键盘的 Return 键也能触发确定按钮的事件。这个属性默认就是 YES，这里为写出来只是为了演示
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogViewController *dialogViewController) {
        [TMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
        [dialogViewController hide];
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

- (void)showSubmitButtonEnablesDialogViewController {
    TMUIDialogTextFieldViewController *dialogViewController = [[TMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入签名";
    [dialogViewController addTextFieldWithTitle:nil configurationHandler:^(TMUILabel *titleLabel, TMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"不超过10个字";
        textField.maximumTextLength = 10;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = YES;// 自动根据输入框的内容是否为空来控制 submitButton.enabled 状态。这个属性默认就是 YES，这里为写出来只是为了演示
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogViewController *dialogViewController) {
        [TMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
        [dialogViewController hide];
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

- (void)showCustomSubmitButtonEnablesDialogViewController {
    TMUIDialogTextFieldViewController *dialogViewController = [[TMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入手机号码";
    [dialogViewController addTextFieldWithTitle:nil configurationHandler:^(TMUILabel *titleLabel, TMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"11位手机号码";
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.maximumTextLength = 11;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = YES;// 自动根据输入框的内容是否为空来控制 submitButton.enabled 状态。这个属性默认就是 YES，这里为写出来只是为了演示
    dialogViewController.shouldEnableSubmitButtonBlock = ^BOOL(TMUIDialogTextFieldViewController *aDialogViewController) {
        // 条件改为一定要写满11位才允许提交
        return aDialogViewController.textFields.firstObject.text.length == aDialogViewController.textFields.firstObject.maximumTextLength;
    };
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(TMUIDialogViewController *dialogViewController) {
        [TMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
        [dialogViewController hide];
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}




@end
