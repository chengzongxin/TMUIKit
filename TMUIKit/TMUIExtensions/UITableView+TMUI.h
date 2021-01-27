//
//  UITableView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (TMUI)

//将NSIndexPath转换成index
- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath;
//将index转换成NSIndexPath
- (NSIndexPath *)indexPathOfIndex:(NSUInteger)index;
@end


@interface UITableView (TNib)

- (void)registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

// 标签是NSStringFromClass([TCPIntroTableViewCell class]
- (void)registerNibIdentifierNSStringFromClass:(Class)cellClass;

@end


@interface UITableView (TRegisterCell)

// 注册名字为nibName的xib
- (void)registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier;

// Cell的样式默认为UITableViewCellStyleDefault
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                         initWithClass:(Class)cellClass;

// 在UITableView寻找identifier标签的Cell，若没有则创建类名为class的Cell
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                   initWithClass:(Class)cellClass
                                                 Style:(UITableViewCellStyle)style;

// 在UITableView寻找identifier标签的Cell，若没有则创建类名为classString的Cell
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                   initWithClassString:(NSString *)classString
                                                 Style:(UITableViewCellStyle)style;

// Cell的样式默认为UITableViewCellStyleDefault
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                   initWithClassString:(NSString *)classString;

@end



NS_ASSUME_NONNULL_END
