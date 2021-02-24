//
//  AttributeTextVC.m
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/24.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "AttributeTextVC.h"
#import "NSString+TSize.h"

@interface AttributeTextVC ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation AttributeTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //@"洒上大蒜是否接口连接和客服电话接口v看v你把你们那边你们谁都不马赛克海军封锁复活节看风景看风景好看iuiuusyuidfuiyasfuibfbfb与温热为任何人啊撒上的撒打算带你吃不饱v还是加大阿萨德八十多";
    NSString *text = @"洒上大蒜是否接口连接和客服电话接口v看v你把你们那边你们谁都不马赛克海军封锁复活节看风景看风景好看iuiuusyuidfuiyasfuibfbfb与温热为任何人啊撒上的撒打算带你吃不饱v还是加大阿萨德八十多";
//    _label.text = text;
    NSInteger lines = [text tmui_numberOfLinesWithFont:[UIFont systemFontOfSize:17] contrainstedToWidth:300];
//    NSLog(@"");
    
    _label.text = text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
