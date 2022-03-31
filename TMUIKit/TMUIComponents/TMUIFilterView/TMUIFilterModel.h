//
//  TMUIFilterModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUIFilterModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, copy) NSArray <NSString *> *items;

@property (nonatomic, assign) NSInteger defalutItem;

@end

NS_ASSUME_NONNULL_END
