//
//  TDFoldLabelViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/3/25.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDFoldLabelViewController.h"

@interface TDFoldLabelViewController ()

@end

@implementation TDFoldLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GroupTV(
            SECTION_CREATE(
                           ROW_CREATE(@"TMUIFoldLabel",
                                      @"单个展开文本",
                                      @"TDOneFoldLabelViewController"),
                           ROW_CREATE(@"TMUIFoldLabel",
                                      @"展开文本列表",
                                      @"TDFoldLabelListViewController"),
                           ).THEME_TITLE(@"TMUIFoldLabel"),
            
            ).embedIn(self.view);
}


@end
