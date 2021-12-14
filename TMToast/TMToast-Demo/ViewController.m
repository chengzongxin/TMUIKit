//
//  ViewController.m
//  TMToast-Demo
//
//  Created by kevin.huang on 2021/3/18.
//  Copyright © 2021 to8to. All rights reserved.
//

#import "ViewController.h"
#import <TMToast/TMToast.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TMToast toast:@"this is a totast message"];
    // Do any additional setup after loading the view, typically from a nib.
}


@end
