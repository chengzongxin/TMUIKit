//
//  BaseDataModel.h
//  Matafy
//
//  Created by Jason on 2018/11/28.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShareCommunityModel;
@class  PlatformContent;
@class PlatformContentList;
NS_ASSUME_NONNULL_BEGIN

@interface BaseDataModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSObject * data;
@property (nonatomic, strong) NSString * message;

@end


#pragma mark -分享社区 Model
@interface ShareCommunityModel : NSObject

@property (nonatomic, strong) PlatformContent * content;
@property (nonatomic, assign) NSInteger isVisibility;
@property (nonatomic, strong) NSString * typeFrom;
@property (nonatomic, strong) NSString * url;
@end

@interface PlatformContent : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSArray< PlatformContentList *> * contentList;
@property (nonatomic, assign) NSInteger costOff;
@property (nonatomic, strong) NSString * date;
@property (nonatomic, strong) NSString * hotelName;
@property (nonatomic, strong) NSString * hotelEnName;
@property (nonatomic, assign) NSInteger nights;
@property (nonatomic, strong) NSArray * urls;
@end

@interface PlatformContentList : NSObject

@property (nonatomic, strong) NSString * platformName;

@property (nonatomic, assign) double platformPrice;

@end
NS_ASSUME_NONNULL_END
