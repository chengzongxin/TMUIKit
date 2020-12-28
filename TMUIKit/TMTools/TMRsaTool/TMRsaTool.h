//
//  TMRsaTool.h
//  TMUIKit
//
//  Created by nigel.ning on 2020/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TMRsaKeyType) {
    /// 公钥串类型 [原旧逻辑对应映射：@"to8to_app_public_key"，实际映射串暂未用]
    TMRsaKeyTypePublic,
    
    /// 私钥串类型 [原旧逻辑对应映射：@"to8to_app_private_key"，实际映射串暂未用] | 此类型几乎用不到，但是从原土巴兔工程抽离出来，暂保留定义
    TMRsaKeyTypePrivate
};


@interface TMRsaTool : NSObject

/**
 * 传入公钥key串，生成公钥类型下的对象
 */
- (instancetype)initRsaWithPublicKey:(NSString *)keyStr NS_DESIGNATED_INITIALIZER;

/*
 * 传入相关key串及指定对应的key类型，生成对应类型下的对象
 */
- (instancetype)initRsaWithKey:(NSString *)keyStr keyType:(TMRsaKeyType)keyType NS_DESIGNATED_INITIALIZER;

#pragma mark - 对外方法-rsa 分段加解密 | 为何用分段加解密暂不清楚，此保留原土巴兔工程的调用接口

/// 加密
- (NSString *)encryptByRsa:(NSString*)content withKeyType:(TMRsaKeyType)keyType;
/// 解密
- (NSString *)decryptByRsa:(NSString*)content withKeyType:(TMRsaKeyType)keyType;

#pragma mark -
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
