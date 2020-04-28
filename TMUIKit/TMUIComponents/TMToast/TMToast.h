//
//  TMToast.h
//  Masonry
//
//  Created by nigel.ning on 2020/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMToast : NSObject

@property (nonatomic, assign, class)NSTimeInterval duration;///< 视图出现后存在的时长，默认1秒，1秒后视图会自动消失

/**统一在顶部位置，动画过渡显示最后自动渐变消失，存在时长1秒
 @warning 显式1行，超出...
 */
+ (void)toast:(NSString *)str;

/**扩展方法，支持直接传入富文本串
 @warning 显式1行，超出...
 */
+ (void)toastAttributedString:(NSAttributedString *)attrStr;

@end

@interface TMToast(ScoreToast)

/**
 显示加兔币积分的提示视图的扩展方法
 @warning 若score<=0且content串长度为0，则内部会不作处理直接返回nil
 */
+ (void)toastScore:(NSInteger)score content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
