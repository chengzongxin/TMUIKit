//
//  TDThemeManager.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TDThemeManager.h"
#import "TDThemeProtocol.h"

/// 简单对 TMUIThemeManager 做一层业务的封装，省去类型转换的工作量
@interface TDThemeManager : NSObject

@property(class, nonatomic, readonly, nullable) NSObject<TDThemeProtocol> * currentTheme;
@end

@interface UIColor (TDTheme)

@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_backgroundColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_backgroundColorLighten;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_backgroundColorHighlighted;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_tintColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_titleTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_mainTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_descriptionTextColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_placeholderColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_codeColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_separatorColor;
@property(class, nonatomic, strong, readonly) UIColor * _Nullable td_gridItemTintColor;
@end

@interface UIImage (TDTheme)

@property(class, nonatomic, strong, readonly) UIImage * _Nullable td_searchBarTextFieldBackgroundImage;
@property(class, nonatomic, strong, readonly) UIImage * _Nullable td_searchBarBackgroundImage;
@end

@interface UIVisualEffect (TDTheme)

@property(class, nonatomic, strong, readonly) UIVisualEffect * _Nullable td_standardBlurEffect;
@end
