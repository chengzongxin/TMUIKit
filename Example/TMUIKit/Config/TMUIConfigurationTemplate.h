//
//  TMUIConfigurationTemplate.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/29.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDThemeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  TMUIConfigurationTemplate 是一份配置表，用于配合 TMUIConfiguration 来管理整个 App 的全局样式，使用方式：
 *  在 TMUI 项目代码的文件夹里找到 TMUIConfigurationTemplate 目录，把里面所有文件复制到自己项目里，保证能被编译到即可，不需要在某些地方 import，也不需要手动运行。
 *
 *  @warning 更新 TMUIKit 的版本时，请留意 Release Log 里是否有提醒更新配置表，请尽量保持自己项目里的配置表与 TMUIKit 里的配置表一致，避免遗漏新的属性。
 *  @warning 配置表的 class 名必须以 TMUIConfigurationTemplate 开头，并且实现 <TMUIConfigurationTemplateProtocol>，因为这两者是 TMUI 识别该 NSObject 是否为一份配置表的条件。
 *  @warning TMUI 2.3.0 之后，配置表改为自动运行，不需要再在某个地方手动运行了。
 */
@interface TMUIConfigurationTemplate : NSObject<TDThemeProtocol>

@end

NS_ASSUME_NONNULL_END
