//
//  NSArray+Json.h
//  Matafy
//
//  Created by Tiaotiao on 2019/7/8.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Json)

+ (NSArray *)formartWithJson:(NSString *)jsonStr;

@end

NS_ASSUME_NONNULL_END
