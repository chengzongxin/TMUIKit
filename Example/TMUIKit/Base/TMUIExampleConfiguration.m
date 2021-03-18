//
//  TMUIConfiguration.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/12.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUIExampleConfiguration.h"


NSString *const h1 = @"h1";
NSString *const h2 = @"h2";
NSString *const h3 = @"h3";
NSString *const body = @"body";
NSString *const button = @"button";

@interface TMUIExampleConfiguration ()
// 强持有，避免样式被释放
@property (nonatomic, strong) CUIStyle *h1;
@property (nonatomic, strong) CUIStyle *h2;
@property (nonatomic, strong) CUIStyle *h3;
@property (nonatomic, strong) CUIStyle *body;
@property (nonatomic, strong) CUIStyle *button;

@end

@implementation TMUIExampleConfiguration

SHARED_INSTANCE_FOR_CLASS

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self didInitialize];
        
    }
    return self;
}

- (void)didInitialize {
    _h1 = Style(h1).fnt(@16).color(Color(@"black")).lineGap(10).multiline;
    _h2 = Style(h2).fnt(@12).color(Color(@"black")).lineGap(10).multiline;
    _h3 = Style(h3).fnt(12).color(Color(@"black")).lineGap(10).multiline;
    _body = Style(body).fnt(12).color(Color(@"gray")).lineGap(15).multiline;
    _button = Style(button).bgColor(@"#178BFB").fnt(@15).color(@"white").borderRadius(4);
}

@end
