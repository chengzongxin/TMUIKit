//
//  TDThemeManager.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDThemeManager.h"
#import "TDThemeProtocol.h"

/// 简单对 QMUIThemeManager 做一层业务的封装，省去类型转换的工作量
@interface TDThemeManager : NSObject

@property(class, nonatomic, readonly, nullable) NSObject<TDThemeProtocol> * currentTheme;
@end

@interface UIColor (TDTheme)

@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_backgroundColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_backgroundColorLighten;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_backgroundColorHighlighted;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_tintColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_titleTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_mainTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_descriptionTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_placeholderColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_codeColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_separatorColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable qd_gridItemTintColor;
@end

@interface UIImage (TDTheme)

@property(class, nonatomic, strong, readonly) UIImage * _Nullable qd_searchBarTextFieldBackgroundImage;
@property(class, nonatomic, strong, readonly) UIImage * _Nullable qd_searchBarBackgroundImage;
@end

@interface UIVisualEffect (TDTheme)

@property(class, nonatomic, strong, readonly) UIVisualEffect * _Nullable qd_standardBlurEffect;
@end
