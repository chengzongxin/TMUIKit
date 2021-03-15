//
//  UINib+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/15.
//

#import "UINib+TMUI.h"

@implementation UINib (TMUI)


+ (UINib *)tmui_nibWithNibClass:(Class)aClass {
    return [UINib nibWithNibName:NSStringFromClass(aClass) bundle:[NSBundle bundleForClass:aClass]];
}


@end
