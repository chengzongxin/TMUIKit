//
//  NSString+Verify.h
//  TMUIKitmui_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Verify)

//判空 使用+方法 因为如果使用-方法，类型不对，根本不会执行该方法
//空对象、类型不对、纯空格或者长度为0，都是YES
+ (BOOL)tmui_isEmpty:(NSString *)string;

//整数
- (BOOL)tmui_isPureInt;

//电话号码，11位
- (BOOL)tmui_isMobileNumber;

//包含子串，iOS8以前没有containsString这个API；
//默认不忽略大小写
- (BOOL)tmui_containsSubstring:(NSString *)string;

//包含子串，ignoreCase：是否忽略大小写
- (BOOL)tmui_containsSubstring:(NSString *)string ignoreCase:(BOOL)ignore;

@end
