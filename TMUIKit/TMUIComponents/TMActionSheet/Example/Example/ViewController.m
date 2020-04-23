//
//  ViewController.m
//  Example
//
//  Created by nigel.ning on 2020/4/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ViewController.h"
#import <TMUIComponents.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    if (indexPath.item == 0) {
        cell.textLabel.text = @"系统actionSheet样式";
    }else {
        cell.textLabel.text = @"自定义actionSheet样式";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.item == 0) {
        [self showSystemActionSheet];
    }else {
        [self showCustomActionSheet];
    }
}

- (void)showSystemActionSheet {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"系统ActionSheet样式" message:@"系统内容message" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:({
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"title_style_Default" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"select : %@", action.title);
        }];
        ac;
    })];
    [actionSheet addAction:({
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"title_style_Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"select : %@", action.title);
        }];
        ac;
    })];
    [actionSheet addAction:({
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"title_style_Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"select : %@", action.title);
        }];
        ac;
    })];
    [actionSheet addAction:({
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"title_style_Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"select : %@", action.title);
        }];
        ac;
    })];
    [actionSheet addAction:({
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"title_style_Default_Last" style:UIAlertActionStyleDefault handler:nil];
        ac;
    })];
    
    [self presentViewController:actionSheet animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [actionSheet addAction:({
                UIAlertAction *ac = [UIAlertAction actionWithTitle:@"title_style_Default_LastPlus" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"select : %@", action.title);
                }];
                ac;
            })];
        });
    }];
}

- (void)showCustomActionSheet {
    [TMActionSheet showWithTitle:@"自定义ActionSheet" actions:@[
        [TMActionSheetAction actionWithTitle:@"Title1" style:TMActionSheetActionStyleDefault handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        [TMActionSheetAction actionWithTitle:@"Title2" style:TMActionSheetActionStyleGray handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        [TMActionSheetAction actionWithTitle:@"Title3" style:TMActionSheetActionStyleDestructivem handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        [TMActionSheetAction actionWithTitle:@"Title3_1" style:TMActionSheetActionStyleDestructivem handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        [TMActionSheetAction actionWithTitle:@"Title3_2" style:TMActionSheetActionStyleDestructivem handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        
        //cancel
        [TMActionSheetAction actionWithTitle:@"Title4" style:TMActionSheetActionStyleCancel handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        
        [TMActionSheetAction actionWithTitle:@"Title5_1" style:TMActionSheetActionStyleDestructivem handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        [TMActionSheetAction actionWithTitle:@"Title5_2" style:TMActionSheetActionStyleDestructivem handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        [TMActionSheetAction actionWithTitle:@"Title5_3" style:TMActionSheetActionStyleDestructivem handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
        [TMActionSheetAction actionWithTitle:@"Title5_4" style:TMActionSheetActionStyleDestructivem handler:^(TMActionSheetAction * _Nonnull action) {
            NSLog(@"select: %@", action.title);
        }],
    ] fromViewController:self];
}

@end
