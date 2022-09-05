//
//  NSString+Modify.h
//  TMUIKit_Example
//
//  Created by cl w on 2021/2/3.
//  Copyright © 2021 chengzongxin. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSFileManager (TMUI)

//沙盒目录结构 xx/Documents xx/tmp xx/Library/Caches

/**沙盒根路径*/
- (NSString *)tmui_sandboxRootDir;

/**沙盒Documents*/
- (NSString *)tmui_sandboxDocDir;

/**沙盒Caches*/
- (NSString *)tmui_sandboxCachesDir;

/**沙盒tmp*/
- (NSString *)tmui_sandboxTmpDir;

/**在沙盒创建文件或目录，
 pathComponent 只需要写沙盒目录下的路径就行，如/Documents/cache.jpg
 isDir 是否是目录
 removeOldFile 如果已经存在该文件或目录，是否删除重建
 */
- (BOOL)tmui_createFileAtSandboxRootDirWithPathComponent:(NSString *)pathComponent
                                             isDirectory:(BOOL)isDir
                                           removeOldFile:(BOOL)removeOld;

/**在沙盒Documents目录下创建文件或目录*/
- (BOOL)tmui_createFileAtSandboxDocumentsDirWithPathComponent:(NSString *)pathComponent
                                                  isDirectory:(BOOL)isDir
                                                removeOldFile:(BOOL)removeOld;

/**在沙盒Caches目录下创建文件或目录*/
- (BOOL)tmui_createFileAtSandboxCachesDirWithPathComponent:(NSString *)pathComponent
                                               isDirectory:(BOOL)isDir
                                             removeOldFile:(BOOL)removeOld;

/**在沙盒tmp目录下创建文件或目录*/
- (BOOL)tmui_createFileAtSandboxTmpDirWithPathComponent:(NSString *)pathComponent
                                            isDirectory:(BOOL)isDir
                                          removeOldFile:(BOOL)removeOld;

/**每次启动app沙盒目录会改变，但是沙盒里面的内容还在，如果上次保存了沙盒里面文件的路径，再次使用该路径会取不到文件，所以需要替换沙盒目录*/
- (NSString *)tmui_pathByReplacingSandboxDir:(NSString *)filePath;

@end
