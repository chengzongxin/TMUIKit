//
//  MTFYTextField.m
//  Matafy
//
//  Created by silkents on 2019/9/2.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYTextField.h"

@implementation MTFYTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    self.leftSpacing?(iconRect.origin.x += self.leftSpacing):(iconRect.origin.x += 15)
    ; 
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 45, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 45, 0);
}
@end
