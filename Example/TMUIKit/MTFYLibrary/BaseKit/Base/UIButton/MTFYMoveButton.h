//
//  MTFYMoveButton.h
//  Matafy
//
//  Created by Tiaotiao on 2019/5/21.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTFYMoveButton : UIButton

@property (nonatomic, strong) RACSubject *clickSubject;

/**
 是否需要拖拽 默认YES
 */
@property (nonatomic, assign) BOOL isNeedMove;


- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
