//
//  TMUIPageControl.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TMUIPageControlStyle) {
    TMUIPageControlStyleDot = 0,// 默认
    TMUIPageControlStyleLine = 1,
};

typedef NS_ENUM(NSUInteger, TMUIPageControlAlignment) {
    TMUIPageControlAlignmentCenter = 0,// 默认
    TMUIPageControlAlignmentLeft = 1,
    TMUIPageControlAlignmentRight = 2,
};

typedef void (^TMUIPageControlUpdateStyleBlock)(UIView* view, BOOL isSelected);

@interface TMUIPageControl : UIView

// 样式
@property (nonatomic) TMUIPageControlStyle style;
// 对齐方式
@property (nonatomic) TMUIPageControlAlignment alignment;

// 一共多少页 默认0
@property (nonatomic) NSInteger numberOfPages;
// 当前页码 取值范围 [0, numberOfPages - 1]
@property (nonatomic) NSInteger currentPage;

// 默认指示条的颜色
@property (nonatomic, strong) UIColor *tintColor;
// 当前指示条的颜色
@property (nonatomic, strong) UIColor *currentTintColor;

// 指示条默认大小
@property (nonatomic) CGSize indicatorSize;
// 当前指示条的大小
@property (nonatomic) CGSize currentIndicatorSize;

// 指示条间距
@property (nonatomic) CGFloat indicatorInset;

//更新指示条样式
@property (nonatomic, copy) TMUIPageControlUpdateStyleBlock updateStyleBlock;

@end

NS_ASSUME_NONNULL_END
