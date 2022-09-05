//
//  TMUIFilterModel.m
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import "TMUIFilterModel.h"
#import "NSArray+TMUI.h"
@implementation TMUIFilterItemModel

+ (instancetype)modelWithText:(NSString *)text{
    return [self modelWithCode:@0 text:text];
}

+ (instancetype)modelWithCode:(id)code text:(NSString *)text{
    TMUIFilterItemModel *model = [[TMUIFilterItemModel alloc] init];
    model.code = code;
    model.text = text;
    return model;
}

@end

@implementation TMUIFilterModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defalutItem = NSNotFound;
    }
    return self;
}

@end





@implementation NSArray (SetupFilterModel)

- (NSArray<TMUIFilterItemModel *> *)filterItemModels{
    return [self tmui_map:^id _Nonnull(id  _Nonnull item) {
        return [TMUIFilterItemModel modelWithText:item];
    }];
}

@end
