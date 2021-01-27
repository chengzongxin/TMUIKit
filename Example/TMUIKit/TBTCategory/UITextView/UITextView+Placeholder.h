//
//  UITextView+Placeholder.h
//  HouseKeeper
//
//  Created by jerry.jiang on 2017/7/28.
//  Copyright © 2017年 binxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)

@property (nonatomic, copy  ) NSAttributedString *attributePlaceholder;
@property (nonatomic, copy  ) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor  *placeholderColor;

@end
