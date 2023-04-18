//
//  TMUIFilterModel.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUIFilterItemModel : NSObject
/// 代码，用于回调回显给外部数据
@property (nonatomic, strong) id code;
/// 显示文本，展示UI
@property (nonatomic, strong) NSString *text;

+ (instancetype)modelWithText:(NSString *)text;
+ (instancetype)modelWithCode:(id)code text:(NSString *)text;

@end

@interface TMUIFilterModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, copy) NSArray <TMUIFilterItemModel *> *items;

@property (nonatomic, assign) NSInteger defalutItem;

@property (nonatomic, assign) NSInteger defalutSection;

@property (nonatomic, assign) BOOL isOnlySectionStyle;

@end


@interface NSArray (SetupFilterModel)

@property (nonatomic, copy ,readonly) NSArray <TMUIFilterItemModel *> *filterItemModels;

@end

NS_ASSUME_NONNULL_END
