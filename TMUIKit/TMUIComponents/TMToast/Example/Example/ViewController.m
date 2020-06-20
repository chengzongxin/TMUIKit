//
//  ViewController.m
//  Example
//
//  Created by nigel.ning on 2020/4/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"普通toast";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"加兔币toast";
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"attributed toast";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        [TMToast toast:@"测试一下toast很长百草枯百草枯艺术厅有欠脆脆鬼脸解铃解铃胸"];
    }else if (indexPath.row == 1) {
        [TMToast toastScore:10 content:@"收藏成功"];
    }else if (indexPath.row == 2) {
        [TMToast toastAttributedString:[[NSAttributedString alloc] initWithString:@"测试一下toast很长百草枯百草枯艺术厅有欠脆脆鬼脸解铃解铃胸枯百草枯艺术厅有欠脆脆鬼脸解铃解枯百草枯艺术厅有欠脆脆鬼脸解铃解" attributes:@{NSFontAttributeName: UIFontMedium(15), NSForegroundColorAttributeName: [UIColor orangeColor]}]];
    }
}

@end
