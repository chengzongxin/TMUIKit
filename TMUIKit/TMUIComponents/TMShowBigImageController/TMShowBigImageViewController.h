//
//  THKShowBigImageViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "TMShowImageAnimatorTransition.h"
NS_ASSUME_NONNULL_BEGIN

/// 大图浏览组件，提供基础的转场动画和大图切换功能
@interface TMShowBigImageViewController : UIViewController

/// 显示单张大图
+ (void)showBigImageWithImageView:(UIImageView *)imageView
                  transitionStyle:(THKTransitionStyle)transitionStyle;
/// 显示一组大图
+ (void)showBigImageWithImageView:(NSArray *)images
                           frames:(NSArray <NSValue *>*)frames
                            index:(NSInteger)index
                  transitionStyle:(THKTransitionStyle)transitionStyle
                           fromVC:(UIViewController *)fromVC;

// 单张大图，给动画转场使用
@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
