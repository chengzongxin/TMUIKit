//
//  MTFYMultiLanguageConstant.h
//  Matafy
//
//  Created by Tiaotiao on 2019/6/18.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MTFYMultiLanguageType) {
    MTFYMultiLanguageTypeSystem = 0,                    // 随系统
    MTFYMultiLanguageTypeChineseSimplify,           // 简体中文
    MTFYMultiLanguageTypeChineseTraditional,            // 繁体中文
    MTFYMultiLanguageTypeEnglish,                       // 英文
    MTFYMultiLanguageTypeFrench                         // 法语
};


NS_ASSUME_NONNULL_BEGIN

@interface MTFYMultiLanguageConstant : NSObject

FOUNDATION_EXTERN NSString *const MTFYMultiLanguageModuleName;
FOUNDATION_EXTERN NSString *const MTFYMultiLanguageModuleKey;

@end

NS_ASSUME_NONNULL_END
