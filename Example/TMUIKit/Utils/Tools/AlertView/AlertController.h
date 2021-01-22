//
//  AlertController.h
//  Matafy
//
//  Created by Joe on 2019/11/11.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^OnAction)(NSInteger index);


@interface AlertController : UIView

#pragma mark - 持有属性
@property (nonatomic, strong) UIView        *container;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *subtitleLabel;
@property (nonatomic, strong) OnAction      onAction;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSArray <NSString *>*buttonTitles;
@property (copy, nonatomic) NSMutableArray <UIButton *>*buttons;

#pragma mark - 外部方法

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                 buttonTitles:(NSArray *)buttonTitles;

// 高亮按钮(蓝色背景),默认左按钮为高亮
- (void)hilightButtonIndex:(NSInteger)index;
- (void)show;
- (void)dismiss;


/**
 快捷设置弹窗显示自定义高亮

 @param title 标题
 @param subtitle 子标题
 @param buttonTitles 按钮标题数组
 @param index 高亮哪个按钮
 @param actionHandle 点击回调
 */
+ (void)showWithTitle:(NSString *)title
             subtitle:(NSString *)subtitle
         buttonTitles:(NSArray *)buttonTitles
   hilightButtonIndex:(int)index
         actionHandle:(OnAction)actionHandle;


/**
 快捷设置弹窗
 
 @param title 标题
 @param subtitle 子标题
 @param buttonTitles 按钮标题数组
 @param actionHandle 点击回调
 */
+ (void)showWithTitle:(NSString *)title
             subtitle:(NSString *)subtitle
         buttonTitles:(NSArray *)buttonTitles
         actionHandle:(OnAction)actionHandle;


@end




NS_ASSUME_NONNULL_END
