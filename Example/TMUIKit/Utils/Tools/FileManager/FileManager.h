//
//  FileManager.h
//  Matafy
//
//  Created by Jason on 2019/1/11.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileManager : NSObject

SHARED_INSTANCE_FOR_HEADER(FileManager)
// folderSize/1024.0f/1024.0f == MB
- (void)checkCache:(void (^)(float folderSize))completion;

- (void)clearCache;

@end

NS_ASSUME_NONNULL_END
