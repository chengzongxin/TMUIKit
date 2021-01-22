//
//  BaseWebNoNetworkView.m
//  Matafy
//
//  Created by Fussa on 2019/5/28.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "BaseWebNoNetworkView.h"
@interface BaseWebNoNetworkView()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation BaseWebNoNetworkView

+ (instancetype)xib {
    return [BaseWebNoNetworkView mtfy_viewFromXib];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.backgroundView addGestureRecognizer:tap];
}

- (void)click {
    if (self.clickBlock) {
        self.clickBlock();
    }
    [self removeFromSuperview];
}

@end
