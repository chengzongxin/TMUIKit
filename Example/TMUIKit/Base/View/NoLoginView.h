//
//  NoLoginView.h
//  Matafy
//
//  Created by Jason on 2018/11/26.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapNoLoginView)(void);
@interface NoLoginView : UIView

@property (copy, nonatomic) TapNoLoginView tapView;

+ (instancetype)xibView;

@end

NS_ASSUME_NONNULL_END
