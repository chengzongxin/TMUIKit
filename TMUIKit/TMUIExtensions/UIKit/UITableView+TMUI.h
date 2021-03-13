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
- (NSUInteger)tmui_indexOfIndexPath:(NSIndexPath *)indexPath;
//将index转换成NSIndexPath
- (NSIndexPath *)tmui_indexPathOfIndex:(NSUInteger)index;
@end


@interface UITableView (TMUI_Nib)

- (void)tmui_registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

// 标签是NSStringFromClass([TCPIntroTableViewCell class]
- (void)tmui_registerNibIdentifierNSStringFromClass:(Class)cellClass;

@end


@interface UITableView (TMUI_RegisterCell)

// 注册名字为nibName的xib
- (void)tmui_registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier;

// Cell的样式默认为UITableViewCellStyleDefault
- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                              initWithClass:(Class)cellClass;

// 在UITableView寻找identifier标签的Cell，若没有则创建类名为class的Cell
- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                              initWithClass:(Class)cellClass
                                                      Style:(UITableViewCellStyle)style;

// 在UITableView寻找identifier标签的Cell，若没有则创建类名为classString的Cell
- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                        initWithClassString:(NSString *)classString
                                                      Style:(UITableViewCellStyle)style;

// Cell的样式默认为UITableViewCellStyleDefault
- (UITableViewCell *)tmui_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                        initWithClassString:(NSString *)classString;

@end



NS_ASSUME_NONNULL_END
