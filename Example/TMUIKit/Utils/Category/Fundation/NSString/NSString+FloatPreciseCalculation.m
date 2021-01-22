//
//  NSString+FloatPreciseCalculation.m
//  FloatPreciseCalculation
//
//  Created by Rainy on 2018/3/23.
//  Copyright © 2018年 WealthOnline_iOS_team. All rights reserved.
//

#import "NSString+FloatPreciseCalculation.h"

@implementation NSString (FloatPreciseCalculation)

+ (NSString *)floatOne:(NSString *)floatOne
       calculationType:(CalculationType)calculationType
              floatTwo:(NSString *)floatTwo
{
//    NSLog(@"第一个数:%@   第二个数:%@",floatOne,floatTwo);
    if (floatTwo.length == 0 || [floatTwo isEqualToString:@"(null)"] || [floatTwo isEqualToString:@"null"])
    {
        return @"0";
    }
    else if(floatOne.length == 0 || [floatOne isEqualToString:@"(null)"] || [floatOne isEqualToString:@"null"])
    {
        return @"0";
    }
    NSDecimalNumber *_floatOne = [NSDecimalNumber decimalNumberWithString:floatOne];
    NSDecimalNumber *_floatTwo = [NSDecimalNumber decimalNumberWithString:floatTwo];
    
    NSDecimalNumber *results = nil;
    
    switch (calculationType) {
        case 0:
        {
            results = [_floatOne decimalNumberByAdding:_floatTwo];
        }
            break;
        case 1:
        {
            results = [_floatOne decimalNumberBySubtracting:_floatTwo];
        }
            break;
        case 2:
        {
            results = [_floatOne decimalNumberByMultiplyingBy:_floatTwo];
        }
            break;
        case 3:
        {
            results = [_floatOne decimalNumberByDividingBy:_floatTwo];
        }
            break;
            
        default:
            break;
    }
    
    return results.stringValue;
}


+(NSString*)strmethodComma:(NSString*)str
{
    
    NSString *intStr;
    
    NSString *floStr;
    
    if ([str containsString:@"."]) {
        
        NSRange range = [str rangeOfString:@"."];
        
        floStr = [str substringFromIndex:range.location];
        
        intStr = [str substringToIndex:range.location];
        
    }else{
        
        floStr = @"";
        
        intStr = str;
        
    }
    
    if (intStr.length <=3) {
        
        return [intStr stringByAppendingString:floStr];
        
    }else{
        
        NSInteger length = intStr.length;
        
        NSInteger count = length/3;
        
        NSInteger y = length%3;
        
        
        NSString *tit = [intStr substringToIndex:y] ;
        
        NSMutableString *det = [[intStr substringFromIndex:y] mutableCopy];
        
        
        for (int i =0; i < count; i ++) {
            
            NSInteger index = i + i *3;
            
            [det insertString:@","atIndex:index];
            
        }
        
        if (y ==0) {
            
            det = [[det substringFromIndex:1]mutableCopy];
            
        }
        
        intStr = [tit stringByAppendingString:det];
        
        return [intStr stringByAppendingString:floStr];
        
    }
}

+(NSString*)commentCountWithString:(NSString *)string  isEv:(BOOL)ev
{
    

    if ( string.length > 4)
    {
        NSInteger x = 0;
        switch (string.length) {
            case 5:
                x = 10000;
                break;
            case 6:
                x = 100000;
                break;
            case 7:
                x = 1000000;
                break;
                
        }
        if (ev)
        {
            return @"1w+";
        }
        else
        {
        NSInteger commentCount = ceil([string integerValue] /x);
        return [NSString stringWithFormat:@"%zdw+",commentCount];
        }
    }
    else
    {
        return string;
    }
    
}
@end
