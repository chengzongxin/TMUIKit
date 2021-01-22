//
//  SharePopViewForTravel.h
//  Matafy
//
//  Created by Joe on 2019/4/15.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectBlock)(NSUInteger type);

typedef void(^DismissBlock)(void);

@interface SharePopViewForTravel : UIView

//@param shareTitle 标题
@property (nonatomic, copy) NSString *shareTitle;
//@param shareContent 文本
@property (nonatomic, copy) NSString *shareContent;
//@param shareImg  图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage。如: @"http://www.mob.com/images/logo_black.png" 或 @[@"http://www.mob.com/images/logo_black.png"]
@property (nonatomic, copy) id       shareImg;
//@param shareUrl url
@property (nonatomic, copy) NSString *shareUrl;

@property (nonatomic, strong) UIView           *container;
@property (nonatomic, strong) UIButton         *cancel;

@property(nonatomic, copy) void (^shareSuccessBlock)(void);
@property(nonatomic, copy) void (^shareFailBlock)(NSString *error);

@property (nonatomic, assign) BOOL isBlockoOutside;

/**
 不传block,是用默认实现,否则,自己实现点击回调
 */
@property (nonatomic, copy) SelectBlock selectBlock;

//@property (assign, nonatomic) BOOL isPriceContest; // 是否比码大赛

- (void)show;
- (void)dismiss;

- (void)savedPhotosAlbum:(UIImage *)snapShotImage;

@end


@interface ShareItemForTravel:UIView

@property (nonatomic, strong) UIImageView      *icon;
@property (nonatomic, strong) UILabel          *label;

- (void)startAnimation:(NSTimeInterval)delayTime;

@end


NS_ASSUME_NONNULL_END
