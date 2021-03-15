//
//  NSString+Modify.m
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "NSFileManager+TMUI.h"

@implementation NSFileManager (TMUI)

- (NSString *)tmui_sandboxRootDir
{
    return NSHomeDirectory();
}

- (NSString *)tmui_sandboxDocDir
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)tmui_sandboxCachesDir
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)tmui_sandboxTmpDir
{
    return NSTemporaryDirectory();
}

- (BOOL)tmui_createFileAtSandboxRootDirWithPathComponent:(NSString *)pathComponent isDirectory:(BOOL)isDir removeOldFile:(BOOL)removeOld
{
    if (pathComponent.length==0) {
        return NO;
    }
    pathComponent = [self modifyPathComponentIfNeeded:pathComponent];
    NSString *fileFullPath = [[self tmui_sandboxRootDir] stringByAppendingString:pathComponent];
    BOOL isDir_ = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileFullPath isDirectory:&isDir_]) {
        if (removeOld) {
            if (isDir == isDir_) {
                [[NSFileManager defaultManager] removeItemAtPath:fileFullPath error:nil];
            }
        }
        else {
            if (isDir == isDir_) {
                return YES;
            }
        }
    }
    if (isDir) {
        NSError *error = nil;
        BOOL createDir = [[NSFileManager defaultManager] createDirectoryAtPath:fileFullPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!createDir) {
            NSLog(@"创建目录失败：%@",error.description?:@"");
        }
        return createDir;
    }
    BOOL createFile = [[NSFileManager defaultManager] createFileAtPath:fileFullPath contents:nil attributes:nil];
    NSError *error = nil;
    if (!createFile) {
        NSLog(@"创建文件失败：%@",error.description?:@"");
    }
    return createFile;
}

- (BOOL)tmui_createFileAtSandboxDocumentsDirWithPathComponent:(NSString *)pathComponent isDirectory:(BOOL)isDir removeOldFile:(BOOL)removeOld
{
    if (pathComponent.length==0) {
        return NO;
    }
    return [self tmui_createFileAtSandboxRootDirWithPathComponent:[NSString stringWithFormat:@"/Documents/%@",pathComponent] isDirectory:isDir removeOldFile:removeOld];
}

- (BOOL)tmui_createFileAtSandboxCachesDirWithPathComponent:(NSString *)pathComponent isDirectory:(BOOL)isDir removeOldFile:(BOOL)removeOld
{
    if (pathComponent.length==0) {
        return NO;
    }
    return [self tmui_createFileAtSandboxRootDirWithPathComponent:[NSString stringWithFormat:@"/Library/Caches/%@",pathComponent] isDirectory:isDir removeOldFile:removeOld];
}

- (BOOL)tmui_createFileAtSandboxTmpDirWithPathComponent:(NSString *)pathComponent
                                            isDirectory:(BOOL)isDir
                                          removeOldFile:(BOOL)removeOld
{
    if (pathComponent.length==0) {
        return NO;
    }
    return [self tmui_createFileAtSandboxRootDirWithPathComponent:[NSString stringWithFormat:@"/tmp/%@",pathComponent] isDirectory:isDir removeOldFile:removeOld];
}

- (NSString *)modifyPathComponentIfNeeded:(NSString *)pathComponent
{
    if ([pathComponent hasPrefix:[self tmui_sandboxRootDir]]) {
        pathComponent = [pathComponent stringByReplacingOccurrencesOfString:[self tmui_sandboxRootDir] withString:@""];
    }
    if (![pathComponent hasPrefix:@"/"]) {
        pathComponent = [NSString stringWithFormat:@"/%@",pathComponent];
    }
    if ([pathComponent hasSuffix:@"/"]) {
        pathComponent = [pathComponent substringToIndex:pathComponent.length-1];
    }
    pathComponent = [pathComponent stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    return pathComponent;
}

- (NSString *)tmui_pathByReplacingSandboxDir:(NSString *)filePath
{
    NSString *detailPath = [filePath componentsSeparatedByString:@"Application/"].lastObject;
    NSString *sanboxDir = [detailPath componentsSeparatedByString:@"/"].firstObject;
    NSString *prefix = [filePath componentsSeparatedByString:sanboxDir].firstObject;
    NSString *sandboxFullDir = [NSString stringWithFormat:@"%@%@",prefix,sanboxDir];
    NSString *returnStr = [filePath stringByReplacingOccurrencesOfString:sandboxFullDir withString:[self tmui_sandboxRootDir]];
    return returnStr;
}

@end
