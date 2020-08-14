//
//  TestItem.h
//  Example
//
//  Created by nigel.ning on 2020/8/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TMEmptyView.h>
#import <TMEmptyContentItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestItem : NSObject
@property (nonatomic, assign)TMEmptyContentType type;
@property (nonatomic, copy)NSString *title;

+ (instancetype)itemWithType:(TMEmptyContentType)type;

@end

NS_ASSUME_NONNULL_END
