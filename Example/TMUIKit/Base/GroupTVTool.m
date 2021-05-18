//
//  GroupTVTool.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "GroupTVTool.h"

@implementation GroupTVTool

+ (CUIStaticRow *)rowWithItems:(NSArray *)items{
    if (items.count == 2) {
        return Row.str(items[0]).fnt(15).cellHeightAuto.onClick(^{
            UIViewController *vc = [[NSClassFromString(items[1]) alloc] init];
            vc.demoInstructions = items[0];
            [UIViewController.new.tmui_topViewController.navigationController pushViewController:vc animated:YES];
        });
    }else if (items.count == 3) {
        return Row.str(items[0]).fnt(18).detailStr(items[1]).subtitleStyle.cellHeightAuto.onClick(^{
            UIViewController *vc = [[NSClassFromString(items[2]) alloc] init];
            vc.demoInstructions = items[1];
            [UIViewController.new.tmui_topViewController.navigationController pushViewController:vc animated:YES];
        });
    }else{
        return nil;
    }
}

@end
