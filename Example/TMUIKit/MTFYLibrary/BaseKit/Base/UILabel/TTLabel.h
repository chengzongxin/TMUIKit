//
//  TTLabel.h
//  Matafy
//
//  Created by Tiaotiao on 2019/3/29.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

NS_ASSUME_NONNULL_BEGIN

@interface TTLabel : UILabel

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
