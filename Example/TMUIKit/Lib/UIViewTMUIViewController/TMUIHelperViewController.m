//
//  TMUIHelperViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/6/14.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TMUIHelperViewController.h"

@interface TMUIHelperViewController ()

@end

@implementation TMUIHelperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id l1 = Label.str(self.demoInstructions).styles(h1);
    id a2 = AttStr(
                   AttStr(Str(@"deviceModel = %@\n",TMUIHelper.deviceModel)),
                   AttStr(Str(@"deviceName = %@\n",TMUIHelper.deviceName)),
                   AttStr(Str(@"appName = %@\n",TMUIHelper.appName)),
                   AttStr(Str(@"appVersion = %@\n",TMUIHelper.appVersion)),
                   AttStr(Str(@"ipv4Address = %@\n",TMUIHelper.ipv4Address)),
                   AttStr(Str(@"ipv6Address = %@\n",TMUIHelper.ipv6Address)),
                   AttStr(Str(@"idfa = %@\n",TMUIHelper.idfa)),
                   AttStr(Str(@"idfv = %@\n",TMUIHelper.idfv)),
                   AttStr(Str(@"OSVersion = %@\n",TMUIHelper.OSVersion)),
                   ).styles(body).match(@" .+?\n").color(@"red");
    id l2 = Label.str(a2).multiline;
    
    VerStack(l1,l2,CUISpring).embedIn(self.view, NavigationContentTop + 20,20,0).gap(10);
    
}
@end
