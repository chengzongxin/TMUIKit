//
//  ViewController.m
//  TMEmptyView-Demo
//
//  Created by kevin.huang on 2021/3/19.
//  Copyright © 2021 to8to. All rights reserved.
//

#import "ViewController.h"
#import <TMEmptyView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [TMEmptyView showEmptyInView:self.view contentType:TMEmptyContentTypeNoData];
}


@end
