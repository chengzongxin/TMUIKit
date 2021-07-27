//
//  UITextView+TMUIPlaceholder.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (TMUIPlaceholder)
// 和TCategory冲突了，后面删掉Tcategory再放开
@property (nonatomic, copy  ) NSAttributedString *attributePlaceholder;
@property (nonatomic, copy  ) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor  *placeholderColor;

@end

NS_ASSUME_NONNULL_END
