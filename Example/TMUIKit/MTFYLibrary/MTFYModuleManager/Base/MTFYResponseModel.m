//
//  MTFYResponseModel.m
//  Matafy
//
//  Created by Fussa on 2019/9/17.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYResponseModel.h"

@implementation MTFYResponseModel

@end

@implementation MTFYResponsePageModel

+ (instancetype)objectWithKeyValues:(id)keyValues classInArray:(Class)className {
    MTFYResponsePageModel *page = [MTFYResponsePageModel mj_objectWithKeyValues:keyValues];
    if (page.list && page.list.count) {
        page.list = [className mj_objectArrayWithKeyValuesArray:page.list];
    }
    return page;
}

@end
