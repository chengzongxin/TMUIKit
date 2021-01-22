//
//  NSDictionary+JsonStringToJsonClass.h
//  Matafy
//
//  Created by silkents on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JsonStringToJsonClass)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
