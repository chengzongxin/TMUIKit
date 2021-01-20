//
//  TMButton.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 控制图片在UIButton里的位置，默认为TMButtonImagePosition_Left
typedef NS_ENUM(NSUInteger, TMButtonImagePosition) {
    TMButtonImagePosition_Top,             // imageView在titleLabel上面
    TMButtonImagePosition_Left,            // imageView在titleLabel左边
    TMButtonImagePosition_Bottom,          // imageView在titleLabel下面
    TMButtonImagePosition_Right,           // imageView在titleLabel右边
};


@interface TMButton : UIButton
- (void)log;
- (void)log123;
@end

NS_ASSUME_NONNULL_END
