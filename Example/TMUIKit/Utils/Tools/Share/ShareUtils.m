//
//  ShareUtils.m
//  Matafy
//
//  Created by Joe on 2019/6/5.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "ShareUtils.h"

@implementation ShareUtils

+ (ShareUtilsParaModel *)defaultParameters:(TravelType)travelType{
    return [ShareUtilsParaModel defaultParaModelWithType:travelType];
}

+ (void)shareMiniProgramWithType:(TravelType)travelType{
    ShareUtilsParaModel *para = [self defaultParameters:travelType];
    [self shareMiniProgramWithTitle:para.title imageUrl:para.thumbImage pathUrl:para.path webPageuUrl:para.webUrl];
}

+ (void)shareMiniProgramWithType:(TravelType)travelType title:(NSString *)title imageUrl:(id)imageUrl{
    ShareUtilsParaModel *para = [self defaultParameters:travelType];
    [self shareMiniProgramWithTitle:title imageUrl:imageUrl pathUrl:para.path webPageuUrl:para.webUrl];
}

+ (void)shareMiniProgramWithTitle:(NSString *)title imageUrl:(id)imageUrl pathUrl:(NSString *)pathUrl webPageuUrl:(NSString *)webPageUrl{
    [self shareMiniProgramWithTitle:title description:title webpageUrl:webPageUrl path:pathUrl imageUrl:imageUrl];
}

+(void)shareMiniProgramWithTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl path:(NSString *)path imageUrl:(id)imageUrl {
    [self shareMiniProgramWithTitle:title description:description webpageUrl:webpageUrl path:path imageUrl:imageUrl success:nil fail:nil];
    
}

+ (void)shareMiniProgramWithTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl path:(NSString *)path imageUrl:(id)imageUrl success:(void (^)(id))success fail:(void (^)(id))fail {
    
    NSString *titleToShare = title;
    if (!NULLString([User sharedInstance].username)){
        titleToShare = [title stringByReplacingOccurrencesOfString:@"我" withString:[User sharedInstance].username];
    }
    
    [ShareKit shareWeixinMiniProgram:titleToShare image:imageUrl pathUrl:path webPageuUrl:webpageUrl success:^{
        if (success) {
            success(@"");
        }
    } fail:^{
        if (fail) {
            fail(@"");
        }
    }];
}

@end


@implementation ShareUtilsParaModel

+ (ShareUtilsParaModel *)defaultParaModelWithType:(TravelType)travelType{
    ShareUtilsParaModel *model = [ShareUtilsParaModel new];
    
    switch (travelType) {
        case TravelTypeAir:
        {
            model.path = @"pages/webview/webview";
            model.webUrl = WX_MINI_PROGRAM_AIR;
            model.title = @"我发现了一个很厉害的机票预订小程序";
            model.thumbImage = [UIImage imageNamed:@"机票分享图"];
        }
            break;
        case TravelTypeHotel:
        {
            model.path = @"pages/webviewHotel/webviewHotel";
            model.webUrl = WX_MINI_PROGRAM_HOTEL;
            model.title = @"我发现了一个很厉害的酒店预订小程序";
            model.thumbImage = [UIImage imageNamed:@"酒店分享图"];
        }
            break;
        case TravelTypeTrain:
        {
            model.path = @"pages/webviewTrain/webviewTrain";
            model.webUrl = WX_MINI_PROGRAM_TRAIN;
            model.title = @"我发现了一个很厉害的火车票预订小程序";
            model.thumbImage = [UIImage imageNamed:@"火车票分享图"];
        }
            break;
        case TravelTypeScenic:
        {
            model.path = @"pages/webviewScenic/webviewScenic";
            model.webUrl = WX_MINI_PROGRAM_SCENIC;
            model.title = @"我发现了一个很厉害的门票预订小程序";
            model.thumbImage = [UIImage imageNamed:@"门票分享图"];
        }
            break;
        case TravelTypeNone:
        {
            model.path = @"pages/home/home";
            model.webUrl = WX_MINI_PROGRAM_AIR;
            model.title = @"我发现了一个很厉害的旅行预订小程序";
            model.thumbImage = [UIImage imageNamed:@"旅行分享图"];
        }
            break;
        case TravelTypeTravel:
        {
            model.path = @"pages/home/home?toIndex=1&type=17";
            model.webUrl = WX_MINI_PROGRAM_HOTEL;
            model.title = kLStr(@"share_travel_title");
            model.thumbImage = [UIImage imageNamed:@"travelshare"];
        }
            break;
            
        case TravelTypeTravelTrip: {
            model.path = @"pages/home/home?toIndex=1&type=17";
            model.webUrl = WX_MINI_PROGRAM_HOTEL;
            model.title = kLStr(@"share_travel_title_2");
            model.thumbImage = [UIImage imageNamed:@"travelshare"];
        }
            break;
        default:
            break;
    }
    
    return model;
    
}

@end
