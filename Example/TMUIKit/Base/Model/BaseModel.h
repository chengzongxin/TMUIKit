//
//  BaseModel.h
//  silu
//
//  Created by Sawyerzhang on 20/11/2015.
//  Copyright © 2015 upintech. All rights reserved.
//

// #import <Realm/Realm.h>

@interface BaseModel : NSObject

@property (nonatomic, copy)   NSString  *Id;
@property (nonatomic, copy)   NSString  *en_title; // 英文
@property (nonatomic, copy)   NSString  *cn_title; // 中文
 

@property (nonatomic, strong) NSArray   *image_urls;
@property (nonatomic, strong) NSArray    *paths;

@property (nonatomic, strong)NSData* image_urls_data;
@property (nonatomic, strong)NSData* paths_data;


@property (nonatomic, strong) NSArray   *imageUrls;
@property (nonatomic, strong)NSData* imageUrls_data;



//+(RLMRealm*)getRealm;


/*
 searched object(which is a Typeobject) doesn't have a id property, so can't be saved, neither can the target

 so,I try to save target on its own, but createOrUpdateInRealm is a Class method. For now, I can't refer the target's
 class. so use this the following instance message to do the magic.
*/
//u-(void)createOrUpdateInRealm:(RLMRealm*)realm;

+(NSString *)resourceNames;
-(void)deleteFromServer;
@end
