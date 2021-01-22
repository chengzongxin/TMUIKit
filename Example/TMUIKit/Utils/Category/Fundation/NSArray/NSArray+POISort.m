//
//  NSArray+POISort.m
//  Matafy
//
//  Created by Jason on 2018/8/24.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "NSArray+POISort.h"


@implementation NSArray (POISort)

- (NSArray *)sortPOIArray{
    
    NSArray *comparatorSortedArray = [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {

        POIListModel *m1 = obj1;
        POIListModel *m2 = obj2;

        int rank1 = [m1.rank intValue];
        int rank2 = [m2.rank intValue];
        int type1 = [m1.type intValue];
        int type2 = [m2.type intValue];
        
        //数组逆转
//        return NSOrderedDescending;

        
        // 景点第1名，酒店第1名，餐厅第1名
        // 景点第2名，酒店第2名，餐厅第2名
        if (rank1 < rank2) {
            return NSOrderedAscending;
        }else if (rank1 > rank2) {
            return NSOrderedDescending;
        }else{
            if (type1 < type2) {
                return NSOrderedAscending;
            }else if (type1 > type2) {
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
        }
        

    }];

    // 打印排序信息
//    [comparatorSortedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        POIListModel *tmp = obj;
//        NSLog(@"comparatorSortedArray model = %@", tmp.type);
//    }];
    return comparatorSortedArray;
}
@end
