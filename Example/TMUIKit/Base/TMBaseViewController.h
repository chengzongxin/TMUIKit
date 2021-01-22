//
//  TMBaseViewController.h
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMBaseViewController : UIViewController



- (UISegmentedControl *)addSegmentedWithLabelText:(NSString *)lbltext titles:(NSArray <NSString *>*)titles click:(void(^)(NSInteger index))clickBlock;
- (UISlider *)addSliderWithLabelText:(NSString *)lbltext slide:(void(^)(float padding))sliderBlock;



@end

NS_ASSUME_NONNULL_END
