//
//  NoLoginView.m
//  Matafy
//
//  Created by Jason on 2018/11/26.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import "NoLoginView.h"

@implementation NoLoginView

+ (instancetype)xibView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}
- (IBAction)tapView:(id)sender {
    if (self.tapView){
        self.tapView();
    }
}


@end
