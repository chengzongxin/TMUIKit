//
//  ShareUtils.h
//  Matafy
//
//  Created by Joe on 2019/6/5.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareKit.h"

typedef NS_ENUM(NSUInteger, TravelType){
    /* 机票 */
    TravelTypeAir   = 0,
    /* 酒店 */
    TravelTypeHotel = 1,
    /* 火车 */
    TravelTypeTrain = 2,
    /* 门票 */
    TravelTypeScenic = 3,
    /* 没有选择 */
    TravelTypeNone  = 4,
    /* 出行 */
    TravelTypeTravel = 5,
    /* 出行行程 */
    TravelTypeTravelTrip = 6
};


NS_ASSUME_NONNULL_BEGIN

@interface ShareUtils : NSObject

+ (void)shareMiniProgramWithType:(TravelType)travelType;

+ (void)shareMiniProgramWithType:(TravelType)travelType title:(NSString *)title imageUrl:(id)imageUrl;

+ (void)shareMiniProgramWithTitle:(NSString *)title imageUrl:(id)imageUrl pathUrl:(NSString *)pathUrl webPageuUrl:(NSString *)webPageUrl;

+ (void)shareMiniProgramWithTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl path:(NSString *)path imageUrl:(id)imageUrl;

+ (void)shareMiniProgramWithTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl path:(NSString *)path imageUrl:(id)imageUrl success:(nullable void (^)(id))success fail:(nullable void (^)(id))fail;

@end

@interface ShareUtilsParaModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) id thumbImage;
@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSString *webUrl;

+ (ShareUtilsParaModel *)defaultParaModelWithType:(TravelType)travelType;

@end

NS_ASSUME_NONNULL_END
