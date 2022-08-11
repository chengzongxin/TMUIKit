//
//  NSArrayTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/5.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "NSArrayTMUIViewController.h"

@interface NSArrayTMUIViewController ()

@end

@implementation NSArrayTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l1 = Label.str(@"1.处理了__NSArray0、__NSSingleObjectArrayI、__NSArrayI、__NSArrayM几种情况的数组越界访问").fixWidth(self.view.width - 40).styles(h1).multiline;
    // demo
    [self beyondBoundsAccess];
    
    [self addNullObject];
    
    id l2 = Label.str(@"2.map、filter、reduce等高阶函数").fixWidth(self.view.width - 40).styles(h1).multiline;
    // demo2
    [self higherOrderFunctions];
    
    id l3 = Label.str(@"3.不可变数组增删改操作").fixWidth(self.view.width - 40).styles(h1).multiline;
    // demo3
    [self addAndRemove];
    
    id l4 = Label.str(@"4.打乱，逆置").fixWidth(self.view.width - 40).styles(h1).multiline;
    // demo3
    [self reverse];
    
    
    VerStack(l1,l2,l3,l4,CUISpring).gap(30).embedIn(self.view, tmui_navigationBarHeight()+20, 20, 80);
    
    
}

- (void)beyondBoundsAccess{
    
    
    {
        NSArray *dd = @[];
        NSString *nnn = dd[1];  // -[__NSArray0 objectAtIndex:]
        NSString *nnn2 = [dd objectAtIndex:1];  // -[__NSArray0 objectAtIndex:]
    }
    {
        NSArray *dd = [NSArray array];
        NSString *nnn = dd[1];   // -[__NSArray0 objectAtIndex:]
        NSString *nnn2 = [dd objectAtIndex:1];   // -[__NSArray0 objectAtIndex:]
    }
    {
        NSArray *dd = [[NSArray alloc]init];
        NSString *nnn = dd[1];   // -[__NSArray0 objectAtIndex:]
        NSString *nnn2 = [dd objectAtIndex:1];   // -[__NSArray0 objectAtIndex:]
    }
    {
        NSArray *dd = [NSArray new];
        NSString *nnn = dd[1];   // -[__NSArray0 objectAtIndex:]
        NSString *nnn2 = [dd objectAtIndex:1];   // -[__NSArray0 objectAtIndex:]
    }
    
    {
        NSArray *arr = @[@""];
        NSString *str = arr[1];//-[__NSSingleObjectArrayI objectAtIndex:]
        NSString *str2 = [arr objectAtIndex:1];//-[__NSSingleObjectArrayI objectAtIndex:]
        
    }
    
    {
        NSArray *arr = [[NSArray alloc]initWithObjects:@"d", nil];
        NSString *str = arr[1];//-[__NSArrayI objectAtIndex:]
        NSString *str2 = [arr objectAtIndex:1];//-[__NSArrayI objectAtIndex:]
        
    }
    
    {
        NSArray *arr = @[@"",@"j"];
        NSString *str = arr[4];//-[__NSArrayI objectAtIndexedSubscript:]:
        NSString *str2 = [arr objectAtIndex:4];//--[__NSArrayI objectAtIndex:]:
        
    }
    
    {
        NSArray *arr = @[@"",@"j",@"2",@"4",@"5"];
        NSString *str = arr[14];//-[__NSArrayI objectAtIndexedSubscript:]:
        NSString *str2 = [arr objectAtIndex:14];//--[__NSArrayI objectAtIndex:]:
        
    }
    
    
    {
        NSMutableArray *mutarr = @[].mutableCopy;
        NSString *str = mutarr[1];//-[__NSArrayM objectAtIndexedSubscript:]:
        NSString *str2 = [mutarr objectAtIndex:2];//-[__NSArrayM objectAtIndex:]:
        
    }
    
    {
        NSMutableArray *mutarr = @[@""].mutableCopy;
        NSString *str = mutarr[1];//-[__NSArrayM objectAtIndexedSubscript:]:
        NSString *str2 = [mutarr objectAtIndex:2];//-[__NSArrayM objectAtIndex:]:
        
    }
    
    {
        NSMutableArray *mutarr = @[@"",@"d",@"2",@"4",].mutableCopy;
        NSString *str = mutarr[14];//-[__NSArrayM objectAtIndexedSubscript:]:
        NSString *str2 = [mutarr objectAtIndex:24];//-[__NSArrayM objectAtIndex:]:
        
    }
}


- (void)addNullObject{
    {
        NSString *str = nil;
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:str];
        
    }
    
    {
        NSString *str = nil;
        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
        [array addObject:str];
        
    }
    
    {
        NSString *str = @"3";
        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
        [array insertObject:str atIndex:5];
        
    }
}

- (void)higherOrderFunctions{
    NSArray *arr = @[@1,@2,@3];
    
    NSArray *ma = [arr tmui_map:^id _Nonnull(NSNumber   *item) {
        return @(item.integerValue + 10);
    }];
    
    NSLog(@"%@",ma);
    
    NSArray *fa = [arr tmui_filter:^BOOL(NSNumber   *item) {
        return item.integerValue + 10 > 11;
    }];
    
    NSLog(@"%@",fa);
    
    id redu0 = [@[@"a", @"hello", @"greeting"] tmui_reduce:^id _Nonnull(id  _Nonnull accumulator, id  _Nonnull item) {
        return [NSString stringWithFormat:@"%@%@", accumulator, item];
    } initial:@""];
    
    NSLog(@"redu 0 = %@",redu0);
    
    id redu = @[@"a", @"hello", @"greeting"].reduce(@0, ^(NSNumber *totalLength, NSString *text) {
       return [totalLength integerValue] + text.length;
    });
    
    NSLog(@"redu 1 = %@",redu);
}

- (void)addAndRemove{
    id a1 = [@[@1,@2] tmui_arrayByAddObject:@3];
    Log(a1);
    
    id a2 = [@[@1,@2] tmui_arrayByRemovingObject:@2];
    Log(a2);
    
    id a3 = [@[@1,@2] tmui_arrayByInsertObject:@3 atIndex:1];
    Log(a3);
    
    id a4 = [@[@1,@2] tmui_arrayByRemovingLastObject];
    Log(a4);
}


- (void)reverse{
    id a1 = [@[@1,@2,@3,@4] tmui_reverse];
    Log(a1);
    
    id a2 = [@[@1,@2,@3,@4] tmui_shuffle];
    Log(a2);
}

@end
