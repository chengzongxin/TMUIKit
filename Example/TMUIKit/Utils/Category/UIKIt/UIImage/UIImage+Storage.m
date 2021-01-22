//
//  UIImage+Storage.m
//  Matafy
//
//  Created by Cheng on 2018/2/2.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "UIImage+Storage.h"

@implementation UIImage (Storage)

- (void)saveImage{
    //拿到图片
    NSString *path_document = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
    NSLog(@"%@",imagePath);
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(self) writeToFile:imagePath atomically:YES];
}

- (UIImage *)readImage{
    NSString *path_document = NSHomeDirectory();
    NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}
@end
