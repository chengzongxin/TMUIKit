//
//  BaseModel.m
//  silu
//
//  Created by Sawyerzhang on 20/11/2015.
//  Copyright © 2015 upintech. All rights reserved.
//

//#import <AVOSCloud/AVOSCloud.h>
#import "BaseModel.h"
#import "AppDelegate.h"
@implementation BaseModel


//Realm
+ (NSArray *)ignoredProperties {
    return @[@"imageUrls", @"image_urls", @"paths",@"support"];
}
+ (NSString *)primaryKey {
    return @"Id";
}

//MJ
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id",
             @"en_title" : @"enTitle",
             @"cn_title" : @"cnTitle",
             };
}

//don't know how to store imags_urls and paths yet.
-(void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls_data = [imageUrls mj_JSONData];
    
}

-(NSArray*)imageUrls{
    NSMutableArray *result = [[self.imageUrls_data mj_JSONObject] mutableCopy];
    return [result copy];
}

-(void)setImage_urls:(NSArray *)image_urls
{
    
    _image_urls_data = [image_urls mj_JSONData];
    
}

-(NSArray*)image_urls{
    NSMutableArray *result = [[self.image_urls_data mj_JSONObject] mutableCopy];
    if (result.count==0) {
        [result addObject:@"加载图"];
    }
    return [result copy];
}


-(void)setPaths:(NSArray *)paths{


    _paths_data = [paths mj_JSONData];
}


-(NSArray*)paths{
    
    
    return [self.paths_data mj_JSONObject];
}




+(NSString *)resourceNames{

    return [NSString stringWithFormat:@"%@s",[NSStringFromClass(self) lowercaseString]];


}


@end
