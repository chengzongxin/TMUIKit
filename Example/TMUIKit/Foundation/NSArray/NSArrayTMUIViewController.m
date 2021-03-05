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
    
    id l1 = Label.str(@"处理了__NSArray0、__NSSingleObjectArrayI、__NSArrayI、__NSArrayM几种情况的数组越界访问").fixWidth(self.view.width - 40).styles(@"h1").multiline;
    
    id scrollView = [UIScrollView new].embedIn(self.view);
    VerStack(l1).gap(10).embedIn(scrollView, 20, 20, 80);
    
    [self beyondBoundsAccess];
    
    [self addNullObject];
    
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

@end
