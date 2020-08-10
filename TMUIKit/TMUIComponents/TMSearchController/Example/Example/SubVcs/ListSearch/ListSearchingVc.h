//
//  ListSearchingVc.h
//  SearchVcTest
//
//  Created by nigel.ning on 2020/8/5.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "TMSearchingController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListSearchingVc : TMSearchingController

@property (nonatomic, copy)void(^reSearchBlock)(NSString *toSearchStr);

@end

NS_ASSUME_NONNULL_END
