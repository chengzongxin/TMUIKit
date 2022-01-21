//
//  GroupTVTool.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/10.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+Base.h"
NS_ASSUME_NONNULL_BEGIN


#define THEME_CELL fnt(18).subtitleStyle.cellHeightAuto.color(TableViewCellTitleLabelColor).detailColor(TableViewCellDetailLabelColor)

#define THEME_TITLE(text) title(text).titleFont(Fnt(20)).titleColor(UIColor.td_tintColor)

// create GroupTV
#define SECTION_CREATE(...) Section(\
__VA_ARGS__\
).footer(@0.01)

// ROW_CREATE(@"title",@"subtitle", @"vc")  or  ROW_CREATE(@"title", @"vc")
#define ROW_CREATE(...) [GroupTVTool rowWithItems:@[__VA_ARGS__]]


// Create (@"title",@"subtitle", @"vc")
#define ROW_ONE_CREATE(title,classVC) Row.str(title).fnt(15).subtitleStyle.cellHeightAuto.onClick(^{\
UIViewController *vc = [[NSClassFromString(classVC) alloc] init];\
[self.navigationController pushViewController:vc animated:YES];\
})

// Create (@"title", @"vc")
#define ROW_TWO_CREATE(title,subtitle,classVC) Row.str(title).fnt(18).detailStr(subtitle).subtitleStyle.cellHeightAuto.onClick(^{\
UIViewController *vc = [[NSClassFromString(classVC) alloc] init];\
[self.navigationController pushViewController:vc animated:YES];\
})

// 废弃
#define ROW_CREATE1(...) \
id arg;\
NSMutableArray *arguments = [NSMutableArray array];\
va_list argList;\
va_start(argList, arg)\
id argument = 0;\
while ((argument = va_arg(argList, id))) {\
    [arguments addObject:argument];\
}\
va_end(argList);\
if (arguments.count == 2) {\
    Row.str(arguments[0]).fnt(15).cellHeightAuto.onClick(^{\
        UIViewController *vc = [[NSClassFromString(arguments[1]) alloc] init];\
        [self.navigationController pushViewController:vc animated:YES];\
    });\
}else{\
    Row.str(arguments[0]).fnt(18).detailStr(arguments[1]).subtitleStyle.cellHeightAuto.onClick(^{\
        UIViewController *vc = [[NSClassFromString(arguments[2]) alloc] init];\
        [self.navigationController pushViewController:vc animated:YES];\
    });\
}


@interface GroupTVTool : NSObject

+ (CUIStaticRow *)rowWithItems:(NSArray *)items;

@end

NS_ASSUME_NONNULL_END
