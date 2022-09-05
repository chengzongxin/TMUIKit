//
//  TMUIFilterToolbar.h
//  Demo
//
//  Created by Joe.cheng on 2022/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMUIFilterToolbar : UIView

@property (nonatomic, copy) void (^tapItem)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
