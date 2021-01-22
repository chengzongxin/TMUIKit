//
//  NSObject+NSArrayASCorDESC.m
//  Matafy
//
//  Created by silkents on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "NSObject+NSArrayASCorDESC.h"

@implementation NSObject (NSArrayASCorDESC)
#pragma mark -- 数组排序方法（升序）
- (NSArray *)arraySortASC:(NSArray *)array{
    //对数组进行排序
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];

    return result;
  
}

#pragma mark -- 数组排序方法（降序）
- (NSArray *)arraySortDESC:(NSArray *)array{
    //对数组进行排序
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1]; //降序
    }];
    return result;
}

#pragma mark - 数字转阿拉伯数字
- (NSString *)translation:(NSString *)arebic {
    if (!arebic) {
        return nil;
    }
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]]) {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]]) {
                    [sums removeLastObject];
                }
            }else {
                sum = chinese_numerals[9];
            }
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
        }
        if (sum) {
            [sums addObject:sum];
        }
    }
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
//    NSLog(@"%@",str);
//    NSLog(@"%@",chinese);
    return chinese;
}


- (NSArray *)sortASCDictionaryArray:(NSArray *)array  withKey:(NSString *)key ascending:(BOOL)isASC
{
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:key ascending:isASC]; 
    
    
    NSArray *tempArray = [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor1, nil]];
    return tempArray;
}

- (NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
//    long long time=[timeStr longLongValue];
    //    如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    long long time=[timeStr longLongValue] / 1000;
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*timeString=[formatter stringFromDate:date];
    
    return timeString;
    
}

@end
