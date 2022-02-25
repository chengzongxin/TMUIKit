//
//  THKFloatImagesViewModel.h
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/11/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THKFloatImageModel;
NS_ASSUME_NONNULL_BEGIN

@interface TMUIFloatImagesViewModel : NSObject

@property (nonatomic, strong, readonly) NSArray <THKFloatImageModel *> *model;

@property (nonatomic, assign) NSInteger maxShowNum;
@property (nonatomic, assign) NSInteger imageNum;
@property (nonatomic, assign) NSInteger minimumInteritemSpacing;
@property (nonatomic, assign) NSInteger minimumLineSpacing;
@property (nonatomic, assign) NSInteger itemCornerRadius;

- (instancetype)initWithModel:(id)model;

//viewModel动态设置model
- (void)bindWithModel:(id)model;

@end



@interface THKFloatImageModel :NSObject
@property (nonatomic , assign) NSInteger              imageWidth;
@property (nonatomic , assign) NSInteger              imageHeight;
@property (nonatomic , copy) NSString              * originUrl;
@property (nonatomic , copy) NSString              * thumbnailUrl;

@end


NS_ASSUME_NONNULL_END
