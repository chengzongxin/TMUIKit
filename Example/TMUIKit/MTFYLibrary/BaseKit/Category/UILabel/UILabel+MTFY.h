//
//  UILabel+MTFY.h
//  Matafy
//
//  Created by Fussa on 2019/11/27.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (MTFY)


/**
 * 设置最后一行结尾缩进, 并多余的显示省略号
 * @param inset 缩进量
 */
- (void)mtfy_setLineBreakByTruncatingLastLineInset:(CGFloat)inset;


/**
  设置最后一行结尾缩进到行中间, 显示省略号
 */
- (void)mtfy_setLineBreakByTruncatingLastLineMiddle;

/**
 分割成行数组
 @return 各个行组成的数组
 */
- (NSArray *)mtfy_getSeparatedLinesArray;

/**
 设置最后一行截断, 并添加文字(如'查看更多')

 @param title 要添加的文字
 @param attributes 文本样式
 @param maxLine 超过多少行后显示更多
 @param clickHandle 点击回调
 */
- (void)mtfy_setEndLineTruncationActionWithTitle:(NSString *)title attributes:(NSDictionary *)attributes maxLine:(NSInteger)maxLine clickHandle:(void (^)(void))clickHandle;


@end

NS_ASSUME_NONNULL_END
