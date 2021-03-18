//
//  TMRsaTool.m
//  TMUIKit
//
//  Created by nigel.ning on 2020/12/28.
//

#import "TMRsaTool.h"
#import <OpenSSL-Universal/openssl/rsa.h>
#import <OpenSSL-Universal/openssl/pem.h>
#import <OpenSSL-Universal/openssl/err.h>

typedef NS_ENUM(NSInteger, RSA_PADDING_TYPE) {
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING,
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING,
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
};

#define PADDING RSA_PADDING_TYPE_PKCS1


@interface TMRsaTool() {
    RSA *_rsa;
}
@property(nonatomic, copy)NSString *RSAKeyTypePublic;
@property(nonatomic, copy)NSString *RSAKeyTypePrivate;
@end

@implementation TMRsaTool

- (instancetype)initRsaWithPublicKey:(NSString *)keyStr {
    self = [super init];
    if (self) {
        [self setKey:keyStr keyType:TMRsaKeyTypePublic];
    }
    return self;
}

- (instancetype)initRsaWithKey:(NSString *)keyStr keyType:(TMRsaKeyType)keyType {
    self = [super init];
    if (self) {
        [self setKey:keyStr keyType:keyType];
    }
    return self;
}

- (void)setKey:(NSString *)keyStr keyType:(TMRsaKeyType)keyType {
    switch (keyType) {
        case TMRsaKeyTypePublic:
            self.RSAKeyTypePublic = keyStr;
            break;
        case TMRsaKeyTypePrivate:
            self.RSAKeyTypePrivate = keyStr;
            break;
        default:
            break;
    }
}

#pragma mark - public api- 分段-加解密

- (NSString *)encryptByRsa:(NSString*)content withKeyType:(TMRsaKeyType)keyType {
    NSMutableArray *mutableArray = [self mbstringToArray:content length:39];
    NSUInteger length = [mutableArray count];
    NSMutableArray *encryptArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < length; i++) {
        NSString *encryString = [self encrypt:mutableArray[i] withKeyType:keyType];
        [encryptArray addObject:encryString];
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:encryptArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        //[jsonData base64EncodedString];末尾不需要自动添加换行符-对应系统base64方法options参数传0即可
        NSString *ret = [jsonData base64EncodedStringWithOptions:0];
        return ret;
    }
    return nil;
}

- (NSString *)decryptByRsa:(NSString*)content withKeyType:(TMRsaKeyType)keyType {
    //[content base64DecodedData];
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSError *error = nil;
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:base64Data options:NSJSONReadingMutableContainers error:&error];
    
    NSUInteger length=[jsonArray count];
    NSMutableString *decryString=[NSMutableString string];
    
    if ([jsonArray count] > 0 && error == nil){
        for (NSInteger i = 0; i < length; i++) {
            NSString *str = [self decrypt:jsonArray[i] withKeyType:keyType];
            [decryString appendString:str];
        }
        
        return decryString;
    }
    return nil;
}

#pragma mark - private 加解密

- (NSString *_Nullable)encrypt:(NSString*)content withKeyType:(TMRsaKeyType)keyType{
    if (![self readRsaStructWithKeyType:keyType]) {
        return nil;
    }
    
    int status;
    const char * input = [content cStringUsingEncoding:NSUTF8StringEncoding];
    int length = (int)strlen(input);
    
    NSInteger  flen = RSA_size(_rsa);
    
    char *encData = (char*)malloc(flen);
    bzero(encData, flen);
    switch (keyType) {
        case TMRsaKeyTypePublic:
            status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
        default:
            status = RSA_private_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
    }
    
    if (status){
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
                
        //ret = [returnData base64EncodedString]; 末尾不需要自动添加换行符-对应系统base64方法options参数传0即可
        NSString *ret = [returnData base64EncodedStringWithOptions:0];
        return ret;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}

- (NSString *_Nullable)decrypt:(NSString*)content withKeyType:(TMRsaKeyType)keyType{
    if (![self readRsaStructWithKeyType:keyType]) {
        return nil;
    }
    
    int status;
    
    //data = [content base64DecodedData];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    int length = (int)[data length];
    
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    char* decData = (char*)malloc(flen);
    bzero(decData, flen);
    
    switch (keyType) {
        case TMRsaKeyTypePublic:
            status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
        default:
            status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
    }
    
    if (status){
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSUTF8StringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
}

- (BOOL)readRsaStructWithKeyType:(TMRsaKeyType)type{
    if (type == TMRsaKeyTypePublic){
        if(self.RSAKeyTypePublic.length == 0) {
            return NO;
        }
        
        BIO *bp = BIO_new(BIO_s_mem());
        BIO_puts(bp, [self.RSAKeyTypePublic cStringUsingEncoding:NSUTF8StringEncoding]);
        _rsa = PEM_read_bio_RSA_PUBKEY(bp, NULL, NULL, NULL);
        BIO_free(bp);
        assert(_rsa != NULL);
    }else{
        if(self.RSAKeyTypePrivate.length == 0) {
            return NO;
        }
        
        BIO *bp = BIO_new(BIO_s_mem());
        BIO_puts(bp, [self.RSAKeyTypePrivate cStringUsingEncoding:NSUTF8StringEncoding]);
        _rsa = PEM_read_bio_RSAPrivateKey(bp, NULL, NULL, NULL);
        BIO_free(bp);
        assert(_rsa != NULL);
    }
    return (_rsa != NULL) ? YES : NO;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type{
    int len = RSA_size(_rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    
    return len;
}

- (NSMutableArray *)mbstringToArray:(NSString *)string length:(NSUInteger)splitLength{
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSUInteger length = string.length;
    NSUInteger max = length/splitLength;
    NSUInteger reminder = length%splitLength;
    
    reminder > 0 ? max++ : max;
    for (NSUInteger i = 0; i < max; i++) {
        NSRange range = NSMakeRange(i*splitLength, splitLength);
        if(i == max-1 && (reminder != 0) ){
            range = NSMakeRange(i*splitLength, reminder);
        }
        
        NSString *str = [string substringWithRange:range];
        [mutableArray addObject:str];
    }
    
    return mutableArray;
}

@end
