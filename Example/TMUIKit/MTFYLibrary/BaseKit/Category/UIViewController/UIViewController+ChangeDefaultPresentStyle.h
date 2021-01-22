//
// Created by Fussa on 2019/10/30.
// Copyright (c) 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (ChangeDefaultPresentStyle)

/**
 Whether or not to set ModelPresentationStyle automatically for instance, Default is [Class mtfy_automaticallySetModalPresentationStyle].
 设置当前实例是否自动设置ModelPresentationStyle. 默认是[Class mtfy_automaticallySetModalPresentationStyle].
*/
@property (nonatomic, assign) BOOL mtfy_automaticallySetModalPresentationStyle;

/**
 Whether or not to set ModelPresentationStyle automatically, Default is YES, but UIImagePickerController/UIAlertController is NO.
 是否设置当前类自动设置ModelPresentationStyle, 默认是为 YES; UIImagePickerController/UIAlertController除外, 默认为NO;
 
 @return BOOL
 */
+ (BOOL)mtfy_automaticallySetModalPresentationStyle;

@end
