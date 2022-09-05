//
//  TMUIThemePrivate.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+TMUI.h"
#import "UIImage+TMUITheme.h"
#import "UIVisualEffect+TMUITheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TMUITheme_Private)

// 某些 view class 在遇到 tmui_registerThemeColorProperties: 无法满足 theme 变化时的刷新需求时，可以重写这个方法来做自己的逻辑
- (void)_tmui_themeDidChangeByManager:(nullable TMUIThemeManager *)manager identifier:(nullable __kindof NSObject<NSCopying> *)identifier theme:(nullable __kindof NSObject *)theme shouldEnumeratorSubviews:(BOOL)shouldEnumeratorSubviews;

/// 记录当前 view 总共有哪些 property 需要在 theme 变化时重新设置
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *tmuiTheme_themeColorProperties;

- (BOOL)_tmui_visible;

@end

/// @warning 由于支持 NSCopying，增加属性时必须在 copyWithZone: 里复制一次
@interface TMUIThemeColor : UIColor <TMUIDynamicColorProtocol>

@property(nonatomic, copy) NSObject<NSCopying> *managerName;
@property(nonatomic, copy) UIColor *(^themeProvider)(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme);
@end

@interface TMUIThemeImage : UIImage <TMUIDynamicImageProtocol, NSCopying>

@property(nonatomic, copy) NSObject<NSCopying> *managerName;
@property(nonatomic, copy) UIImage *(^themeProvider)(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme);
@end

/// @warning 由于支持 NSCopying，增加属性时必须在 copyWithZone: 里复制一次
@interface TMUIThemeVisualEffect : NSObject <TMUIDynamicEffectProtocol>

@property(nonatomic, copy) NSObject<NSCopying> *managerName;
@property(nonatomic, copy) __kindof UIVisualEffect *(^themeProvider)(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme);
@end

NS_ASSUME_NONNULL_END
