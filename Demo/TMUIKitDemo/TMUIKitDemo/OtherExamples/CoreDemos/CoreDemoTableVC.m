//
//  CoreDemoTableVC.m
//  TMUIKitDemo
//
//  Created by nigel.ning on 2020/4/15.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "CoreDemoTableVC.h"

@interface CoreDemoTableVC (Test)
TMAssociatedPropertyStrongType(NSString, strValue);
TMAssociatedPropertyWeakType(NSNumber, weakNum);
TMAssociatedPropertyAssignType(NSTimeInterval, timeInterval);
TMAssociatedPropertyAssignStructType(CGPoint, point);
@end
@implementation CoreDemoTableVC (Test)
TMAssociatedPropertyStrongTypeSetterGetter(NSString, strValue);
TMAssociatedPropertyWeakTypeSetterGetter(NSNumber, weakNum);
TMAssociatedPropertyAssignTypeSetterGetter(NSTimeInterval, timeInterval, doubleValue);
TMAssociatedPropertyAssignStructTypeSetterGetter(CGPoint, point);
@end


@interface CoreDemoTableVC ()

@end

@implementation CoreDemoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testAssociatedPropertyMacro];
}

#pragma mark -
- (void)testAssociatedPropertyMacro {
    self.strValue = @"xxx";
    NSLog(@"strValue: %@", self.strValue);
    
    NSNumber *num = @(10);
    self.weakNum = num;
    NSLog(@"weakNum: %@", self.weakNum);
    
    self.timeInterval = 1000;
    NSLog(@"timeInterval: %f", self.timeInterval);
    
    self.point = CGPointMake(10, 10);
    NSLog(@"point: {%f, %f}", self.point.x, self.point.y);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = @"Core库 一般很少有对应的Demo展示";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
