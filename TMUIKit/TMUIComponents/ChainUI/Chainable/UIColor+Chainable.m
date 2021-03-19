//
//  UIColor+Chainable.m
//  ChainUI
//
//  Created by Joe.cheng on 2021/2/27.
//

#import "UIColor+Chainable.h"
#import "CUIPrivates.h"


UIColor * CUIColorWithObject(id object){
    if ([object isKindOfClass:[UIColor class]]) {
        return object;
        
    } else if ([object isKindOfClass:[NSString class]]) {
        CGFloat alpha = 1;
        NSArray *componnets = [object componentsSeparatedByString:@","];
        
        //whether the color object contains alpha
        if (componnets.count == 2 || componnets.count == 4) {
            NSRange range = [object rangeOfString:@"," options:NSBackwardsSearch];
            alpha = [[object substringFromIndex:range.location + range.length] floatValue];
            alpha = MIN(alpha, 1);
            object = [object substringToIndex:range.location];
        }
        
        //system color
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", object]);
        if ([UIColor respondsToSelector:sel]) {
            UIColor *color = [UIColor performSelector:sel withObject:nil];
            if (alpha != 1) color = [color colorWithAlphaComponent:alpha];
            return color;
        }
        
        int r = 0, g = 0, b = 0;
        BOOL isRGBColor = NO;
        
        //random
        if ([object isEqualToString:@"random"]) {
            r = arc4random_uniform(256);
            g = arc4random_uniform(256);
            b = arc4random_uniform(256);
            isRGBColor = YES;
            
        } else {
            BOOL isHex = NO;
            
            if ([object hasPrefix:@"#"]) {
                object = [object substringFromIndex:1];
                isHex = YES;
            }
            if ([object hasPrefix:@"0x"]) {
                object = [object substringFromIndex:2];
                isHex = YES;
            }
            
            if (isHex) {
                int result = sscanf([object UTF8String], "%2x%2x%2x", &r, &g, &b);     //#FFFFFF
                
                if (result != 3) {
                    result = sscanf([object UTF8String], "%1x%1x%1x", &r, &g, &b);     //#FFF
                    
                    //convert #FFF to #FFFFFF
                    if (result == 3) {
                        r *= 17; g *= 17; b *= 17;
                    }
                }
                isRGBColor = (result == 3);
                
            } else {
                int result = sscanf([object UTF8String], "%d,%d,%d", &r, &g, &b);       //rgb
                isRGBColor = (result == 3);
            }
        }
        
        if (isRGBColor) {
            return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:alpha];
        }
        
    } else if ([object isKindOfClass:[UIImage class]]) {
        return [UIColor colorWithPatternImage:object];
    }
    
    return nil;
}




UIColor * CUIColorRepresentationOfValueOBJ(const char *type, const void *value){
    id object = *(__strong id *)value;
    return CUIColorWithObject(object);
}


@implementation UIColor (Chainable)

- (CUIChainableUIColorFloatBlock)opacity {
    CUI_FLOAT_BLOCK(return [self colorWithAlphaComponent:value]);
}

- (CUIChainableUIColorFloatBlock)hueOffset {
    CUI_FLOAT_BLOCK(return [self cui_colorWithHueOffset:value saturationOffset:0 brightnessOffset:0]);
}

- (CUIChainableUIColorFloatBlock)saturate {
    CUI_FLOAT_BLOCK(return [self cui_colorWithHueOffset:0 saturationOffset:value brightnessOffset:0];);
}

- (CUIChainableUIColorFloatBlock)desaturate {
    CUI_FLOAT_BLOCK(return [self cui_colorWithHueOffset:0 saturationOffset:-value brightnessOffset:0]);
}

- (CUIChainableUIColorFloatBlock)brighten {
    CUI_FLOAT_BLOCK(return [self cui_colorWithHueOffset:0 saturationOffset:0 brightnessOffset:value]);
}

- (CUIChainableUIColorFloatBlock)darken {
    CUI_FLOAT_BLOCK(return [self cui_colorWithHueOffset:0 saturationOffset:0 brightnessOffset:-value]);
}

- (instancetype)complimentary {
    return self.hueOffset(0.5);
}
@end
