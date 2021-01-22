//
//  FileManager.m
//  Matafy
//
//  Created by Jason on 2019/1/11.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "FileManager.h"
#import "WebCacheHelpler.h"

@implementation FileManager

SHARED_INSTANCE_FOR_CLASS(FileManager)

#pragma mark -检查缓存
- (void)checkCache:(void (^)(float folderSize))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        float folderSize = 0.0;
        if ([fileManager fileExistsAtPath:path]) {
            //拿到算有文件的数组
            NSArray *childerFiles = [fileManager subpathsAtPath:path];
            //拿到每个文件的名字,如有有不想清除的文件就在这里判断
            for (NSString *fileName in childerFiles) {
                //将路径拼接到一起
                NSString *fullPath = [path stringByAppendingPathComponent:fileName];
                folderSize += [self fileSizeAtPath:fullPath];
            }
        }
        
        
        //检查video视频缓存
        
        NSString *videoPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject;
        // 保存文件到缓存目录
        NSString *diskCachePath = [NSString stringWithFormat:@"%@%@",videoPath,@"/webCache"];
        
        NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:diskCachePath error:nil];
        NSEnumerator *enumerator = [contents objectEnumerator];
        NSString *fileName;
        CGFloat videoFolderSize = 0.0f;
        
        while((fileName = [enumerator nextObject])) {
            NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
            videoFolderSize += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
            //                [_fileManager removeItemAtPath:filePath error:NULL];
        }
        folderSize += videoFolderSize;
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            if(isnan(folderSize)){      //isnan为系统函数
                
//                self.fileSize.text = @"0.00M";
                completion(0);
            } else {
//                self.fileSize.text = [NSString stringWithFormat:@"%0.2fM",folderSize/1024.0f/1024.0f];
                completion(folderSize);
            }
        });
        
    });
}

//计算单个文件夹的大小
-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        
        return size;
    }
    return 0;
}

#pragma mark - 清理缓存

-(void)clearCache{
    [[WebCacheHelpler sharedWebCache] clearCache:^(NSString *cacheSize) {
        NSLog(@"cache size = %@",cacheSize);
    }];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}


@end
