//
//  MTFYMultiLanguageModule.m
//  Matafy
//
//  Created by Tiaotiao on 2019/6/17.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYMultiLanguageModule.h"
static NSString* const kLanguageUserDefaultKey = @"kLanguageUserDefaultKey";

static NSString* const MTFYLanguageZhHans = @"zh-Hans";
static NSString* const MTFYLanguageZhHant = @"zh-Hant";
static NSString* const MTFYLanguageEn = @"en";
static NSString* const MTFYLanguageFr = @"fr";

@interface MTFYMultiLanguageModule ()

/// Current language type
@property (nonatomic, assign) MTFYMultiLanguageType curLanguageType;

/// Current language source path name
@property (nonatomic, copy) NSString *curLanguageSourcePathName;

@end


@implementation MTFYMultiLanguageModule

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark modEvent/modNotice

- (void)modInit
{
    [self configPreferredLanguage];
}

#pragma mark - Public

- (MTFYMultiLanguageType)modCurLanguageType
{
    return self.curLanguageType;
}

- (NSString *)modCurLanguageSourcePathName {
    return [self fetchLanguageSourcePathName:[self modCurLanguageType]];
}

- (void)modMultiLanguageChange:(MTFYMultiLanguageType)type {
    self.curLanguageType = type;
    [self configLanguageSourcePathName:type];
}

- (NSString *)modMultiStringFromKey:(NSString *)key {
    if (!key) {
        return key;
    }
    
    NSString *languageResourceNameStr = self.curLanguageSourcePathName;
    if ([NSString isEmpty:languageResourceNameStr]) {
        languageResourceNameStr = MTFYLanguageZhHans;
    }
    NSString *resultStr = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:languageResourceNameStr ofType:@"lproj"]] localizedStringForKey:key value:@"" table:nil];
    
    if (!resultStr) {
        return key;
    }
    
    return resultStr;
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark YFModuleBaseProtocol

- (MTFYModuleLevel)moduleLevel
{
    return MTFYMModuleLevelHigh;
}

+ (NSString *)moduleKey
{
    return MTFYMultiLanguageModuleKey;
}

#pragma mark - Private

- (void)configPreferredLanguage
{
    NSString *language = UserDefaultObjectForKey(kLanguageUserDefaultKey);
    
    // 默认中文简体
    if ([NSString isEmpty:language]) {
        language = MTFYLanguageZhHans;
    }
    
    MTFYMultiLanguageType languageType = [self fetchLanguageType:language];

//    if (languageType == MTFYMultiLanguageTypeSystem) {
//        language = [NSLocale preferredLanguages].firstObject;
//
//        if ([language hasPrefix:@"en"]) {
//            language = MTFYLanguageEn;
//        } else if ([language hasPrefix:@"zh"]) {
//            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
//                // 简体中文
//                language = MTFYLanguageZhHans;
//            } else {
//                // 繁體中文 zh-Hant\zh-HK\zh-TW
//                language = MTFYLanguageZhHant;
//            }
//        } else if ([language hasPrefix:@"fr"]) {
//            language = MTFYLanguageFr;
//        } else {
//            // 找不到的时候默认中文
//            language = MTFYLanguageZhHans;
//        }
//    }
    
    self.curLanguageSourcePathName = language;
    self.curLanguageType = languageType;
}

- (void)configLanguageSourcePathName:(MTFYMultiLanguageType)languageType {
    NSString *languageName = [self fetchLanguageSourcePathName:languageType];
    if (languageName) {
        self.curLanguageSourcePathName = [self fetchLanguageSourcePathName:languageType];
    } else {
        UserDefaultRemoveObjectForKey(kLanguageUserDefaultKey);
        [self configPreferredLanguage];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@""];
    UserDefaultSetObjectForKey(self.curLanguageSourcePathName, kLanguageUserDefaultKey);
}

- (NSString *)fetchLanguageSourcePathName:(MTFYMultiLanguageType)languageType {
    NSString *languageSourcePathName;
    switch (languageType) {
        case MTFYMultiLanguageTypeChineseSimplify:
            languageSourcePathName = MTFYLanguageZhHans;
            break;
        case MTFYMultiLanguageTypeChineseTraditional:
            languageSourcePathName = MTFYLanguageZhHant;
            break;
        case MTFYMultiLanguageTypeEnglish:
            languageSourcePathName = MTFYLanguageEn;
            break;
        case MTFYMultiLanguageTypeFrench:
            languageSourcePathName = MTFYLanguageFr;
            break;
        default:
            break;
    }
    return languageSourcePathName;
}

- (MTFYMultiLanguageType)fetchLanguageType:(NSString *)languageSourcePathName {
    NSDictionary *languageDict = @{
                                   MTFYLanguageZhHans: @(MTFYMultiLanguageTypeChineseSimplify),
                                   MTFYLanguageZhHant: @(MTFYMultiLanguageTypeChineseTraditional),
                                   MTFYLanguageEn: @(MTFYMultiLanguageTypeEnglish),
                                   MTFYLanguageFr: @(MTFYMultiLanguageTypeFrench),
                                  };
//    MTFYMultiLanguageType type = MTFYMultiLanguageTypeSystem;
    MTFYMultiLanguageType type = MTFYMultiLanguageTypeChineseSimplify;
    id value = [languageDict valueForKey:languageSourcePathName];
    if (value) {
        type = [value integerValue];
    }
    return type;
}

#pragma mark - Getters and Setters

- (void)setCurLanguageType:(MTFYMultiLanguageType)curLanguageType {
    _curLanguageType = curLanguageType;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
