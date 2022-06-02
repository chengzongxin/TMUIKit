//
//  UIColor+TMUI.m
//  Masonry
//
//  Created by nigel.ning on 2020/4/15.
//

#import "UIColor+TMUI.h"
#import "NSObject+TMUI.h"
#import "TMUIRuntime.h"

@implementation UIColor (TMUI)

+ (UIColor *)tmui_colorWithHexString:(NSString *)hexString {
    return tmui_colorWithHexString(hexString);
}


- (CGFloat)tmui_red {
    CGFloat r;
    if ([self getRed:&r green:0 blue:0 alpha:0]) {
        return r;
    }
    return 0;
}

- (CGFloat)tmui_green {
    CGFloat g;
    if ([self getRed:0 green:&g blue:0 alpha:0]) {
        return g;
    }
    return 0;
}

- (CGFloat)tmui_blue {
    CGFloat b;
    if ([self getRed:0 green:0 blue:&b alpha:0]) {
        return b;
    }
    return 0;
}

- (CGFloat)tmui_alpha {
    CGFloat a;
    if ([self getRed:0 green:0 blue:0 alpha:&a]) {
        return a;
    }
    return 0;
}


- (CGFloat)tmui_hue {
    CGFloat h;
    if ([self getHue:&h saturation:0 brightness:0 alpha:0]) {
        return h;
    }
    return 0;
}

- (CGFloat)tmui_saturation {
    CGFloat s;
    if ([self getHue:0 saturation:&s brightness:0 alpha:0]) {
        return s;
    }
    return 0;
}

- (CGFloat)tmui_brightness {
    CGFloat b;
    if ([self getHue:0 saturation:0 brightness:&b alpha:0]) {
        return b;
    }
    return 0;
}

- (UIColor *)tmui_colorWithoutAlpha {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    if ([self getRed:&r green:&g blue:&b alpha:0]) {
        return [UIColor colorWithRed:r green:g blue:b alpha:1];
    } else {
        return nil;
    }
}


- (UIColor *)tmui_transitionToColor:(UIColor *)toColor progress:(CGFloat)progress {
    return [UIColor tmui_colorFromColor:self toColor:toColor progress:progress];
}

- (BOOL)tmui_colorIsDark {
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    if ([self getRed:&red green:&green blue:&blue alpha:0]) {
        float referenceValue = 0.411;
        float colorDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
        
        return 1.0 - colorDelta > referenceValue;
    }
    return YES;
}

- (UIColor *)tmui_inverseColor {
    const CGFloat *componentColors = CGColorGetComponents(self.CGColor);
    UIColor *newColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                               green:(1.0 - componentColors[1])
                                                blue:(1.0 - componentColors[2])
                                               alpha:componentColors[3]];
    return newColor;
}


- (CGFloat)tmui_distanceBetweenColor:(UIColor *)color {
    if (!color) return CGFLOAT_MAX;
    
    UIColor *color1 = self;
    UIColor *color2 = color;
    CGFloat R = 100.0;
    CGFloat angle = 30.0;
    CGFloat h = R * cos(angle / 180 * M_PI);
    CGFloat r = R * sin(angle / 180 * M_PI);
    
    CGFloat hue1 = color1.tmui_hue * 360;
    CGFloat saturation1 = color1.tmui_saturation;
    CGFloat brightness1 = color1.tmui_brightness;
    CGFloat hue2 = color2.tmui_hue * 360;
    CGFloat saturation2 = color2.tmui_saturation;
    CGFloat brightness2 = color2.tmui_brightness;
    
    CGFloat x1 = r * brightness1 * saturation1 * cos(hue1 / 180 * M_PI);
    CGFloat y1 = r * brightness1 * saturation1 * sin(hue1 / 180 * M_PI);
    CGFloat z1 = h * (1 - brightness1);
    CGFloat x2 = r * brightness2 * saturation2 * cos(hue2 / 180 * M_PI);
    CGFloat y2 = r * brightness2 * saturation2 * sin(hue2 / 180 * M_PI);
    CGFloat z2 = h * (1 - brightness2);
    CGFloat dx = x1 - x2;
    CGFloat dy = y1 - y2;
    CGFloat dz = z1 - z2;
    return sqrt(dx * dx + dy * dy + dz * dz);
}

- (UIColor *)tmui_colorWithAlpha:(CGFloat)alpha backgroundColor:(UIColor *)backgroundColor {
    return [UIColor tmui_colorWithBackendColor:backgroundColor frontColor:[self colorWithAlphaComponent:alpha]];
    
}

- (UIColor *)tmui_colorWithAlphaAddedToWhite:(CGFloat)alpha {
    return [self tmui_colorWithAlpha:alpha backgroundColor:UIColor.whiteColor];
}

+ (UIColor *)tmui_colorWithBackendColor:(UIColor *)backendColor frontColor:(UIColor *)frontColor {
    CGFloat bgAlpha = [backendColor tmui_alpha];
    CGFloat bgRed = [backendColor tmui_red];
    CGFloat bgGreen = [backendColor tmui_green];
    CGFloat bgBlue = [backendColor tmui_blue];
    
    CGFloat frAlpha = [frontColor tmui_alpha];
    CGFloat frRed = [frontColor tmui_red];
    CGFloat frGreen = [frontColor tmui_green];
    CGFloat frBlue = [frontColor tmui_blue];
    
    CGFloat resultAlpha = frAlpha + bgAlpha * (1 - frAlpha);
    CGFloat resultRed = (frRed * frAlpha + bgRed * bgAlpha * (1 - frAlpha)) / resultAlpha;
    CGFloat resultGreen = (frGreen * frAlpha + bgGreen * bgAlpha * (1 - frAlpha)) / resultAlpha;
    CGFloat resultBlue = (frBlue * frAlpha + bgBlue * bgAlpha * (1 - frAlpha)) / resultAlpha;
    return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:resultAlpha];
}


+ (UIColor *)tmui_colorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    progress = MIN(progress, 1.0f);
    progress = MAX(progress, 0.0f);
    CGFloat fromRed = fromColor.tmui_red;
    CGFloat fromGreen = fromColor.tmui_green;
    CGFloat fromBlue = fromColor.tmui_blue;
    CGFloat fromAlpha = fromColor.tmui_alpha;
    
    CGFloat toRed = toColor.tmui_red;
    CGFloat toGreen = toColor.tmui_green;
    CGFloat toBlue = toColor.tmui_blue;
    CGFloat toAlpha = toColor.tmui_alpha;
    
    CGFloat finalRed = fromRed + (toRed - fromRed) * progress;
    CGFloat finalGreen = fromGreen + (toGreen - fromGreen) * progress;
    CGFloat finalBlue = fromBlue + (toBlue - fromBlue) * progress;
    CGFloat finalAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    
    return [UIColor colorWithRed:finalRed green:finalGreen blue:finalBlue alpha:finalAlpha];
}

+ (UIColor *)tmui_randomColor {
    CGFloat red = ( arc4random() % 255 / 255.0 );
    CGFloat green = ( arc4random() % 255 / 255.0 );
    CGFloat blue = ( arc4random() % 255 / 255.0 );
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end



NSString *const TMUICGColorOriginalColorBindKey = @"TMUICGColorOriginalColorBindKey";

@implementation UIColor (TMUI_DynamicColor)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 13.0, *)) {
            ExtendImplementationOfNonVoidMethodWithoutArguments([UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trait) {
                return [UIColor clearColor];
            }].class, @selector(CGColor), CGColorRef, ^CGColorRef(UIColor *selfObject, CGColorRef originReturnValue) {
                if (selfObject.tmui_isDynamicColor) {
                    UIColor *color = [UIColor colorWithCGColor:originReturnValue];
                    originReturnValue = color.CGColor;
                    [(__bridge id)(originReturnValue) tmui_bindObject:selfObject forKey:TMUICGColorOriginalColorBindKey];
                }
                return originReturnValue;
            });
        }
    });
}

- (BOOL)tmui_isDynamicColor {
    if ([self respondsToSelector:@selector(_isDynamic)]) {
        return self._isDynamic;
    }
    return NO;
}

- (BOOL)tmui_isTMUIDynamicColor {
    return NO;
}

- (UIColor *)tmui_rawColor {
    if (self.tmui_isDynamicColor) {
        if (@available(iOS 13.0, *)) {
            if ([self respondsToSelector:@selector(resolvedColorWithTraitCollection:)]) {
                UIColor *color = [self resolvedColorWithTraitCollection:UITraitCollection.currentTraitCollection];
                return color.tmui_rawColor;
            }
        }
    }
    return self;
}

@end
