//
//  TMUICycleView.h
//  TMUIKit
//
//  Created by Joe.cheng on 2022/1/27.
//

#import <UIKit/UIKit.h>
#import "TMUIPageControl.h"
NS_ASSUME_NONNULL_BEGIN

@class TMUICycleView;
@class TMUICycleViewCell;

typedef void (^TMUIConfigCycleCell)(TMUICycleViewCell *cell, id model);
typedef void (^TMUISelectCycleCell)(TMUICycleViewCell *cell, id model);
typedef void (^TMUIScrollCycleCell)(TMUICycleView *cycleView, NSInteger index);

@interface TMUICycleViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

@interface TMUICycleView : UIView

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, copy) TMUIConfigCycleCell configCell;

@property (nonatomic, copy) TMUISelectCycleCell selectCell;

@property (nonatomic, copy) TMUIScrollCycleCell scrollCell;


/// 页面控制器
@property (nonatomic, strong, readonly) TMUIPageControl *pageControl;
/// 底部距离，默认20
@property (nonatomic, assign) CGFloat pageControlPaddingBottom;

@end

NS_ASSUME_NONNULL_END
