//
//  Share.h
//  Matafy
//
//  Created by Cheng on 2018/1/25.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareViewController : UIActivityViewController

+ (instancetype)share:(NSString *)textToShare image:(UIImage *)img url:(NSString *)urlToShare success:(void (^)(id data))success fail:(void (^)(id message))fail;

@end
