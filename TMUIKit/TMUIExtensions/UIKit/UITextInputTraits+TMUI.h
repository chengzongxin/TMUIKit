//
//  UITextInputTraits+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TMUITextInput)

@end

@interface NSObject (TMUITextInput_Private)

/// 内部使用，标记某次 keyboardAppearance 的改动是由于 UIView+TMUITheme 内导致的，而非用户手动修改
@property(nonatomic, assign) UIKeyboardAppearance tmui_keyboardAppearance;

/// 内部使用，用于标志业务自己修改了 keyboardAppearance 的情况
@property(nonatomic, assign) BOOL tmui_hasCustomizedKeyboardAppearance;
@end

NS_ASSUME_NONNULL_END
