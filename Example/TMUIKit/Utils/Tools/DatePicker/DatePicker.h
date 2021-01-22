//
//  DatePicker.h
//  Matafy
//
//  Created by Jason on 2018/11/28.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PassValue)(NSString *str);

@interface DatePicker : UIView

+(instancetype)setDate;

-(void)passvalue:(PassValue)block;

@end

NS_ASSUME_NONNULL_END
