//
//  ListSearchResultVc.h
//  SearchVcTest
//
//  Created by nigel.ning on 2020/8/5.
//  Copyright © 2020 t8t. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListSearchResultVc : UIViewController

@property (nonatomic, copy)NSString *searchStr;

@property (nonatomic, copy)void(^reSearchBlock)(NSString *toSearchStr);

@end

NS_ASSUME_NONNULL_END
