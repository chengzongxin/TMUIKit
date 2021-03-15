//
//  UISlider+associateObject.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/22.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UISlider+associateObject.h"
#import <objc/runtime.h>
#import <TMUICommonDefines.h>

#define TMUISETTER(_getterName) NSSelectorFromString([NSString stringWithFormat:@"set%@:",NSStringFromSelector(_getterName).tmui_capitalizedString])
#define TMUICopySynthesizeId1(_getterName) _TMUISynthesizeId(_getterName,TMUISETTER(_getterName), COPY)

#define TMUISETTER2(_getterName) [NSString stringWithFormat:@"set%@:",NSStringFromSelector(_getterName).tmui_capitalizedString]
#define TMUICopySynthesizeId2(_getterName) _TMUISynthesizeId(_getterName,TMUISETTER2(_getterName), COPY)
//#define TMUICopySynthesizeId1(_getterName) _TMUISynthesizeId(_getterName,setterWithGetter(_getterName), COPY)

@implementation UISlider (associateObject)

- (void)dd:(SEL)getter{
    NSSelectorFromString([NSString stringWithFormat:@"set%@:",NSStringFromSelector(getter).tmui_capitalizedString]);
}

//    NSMutableString *setterString = [[NSMutableString alloc] initWithString:@"set"];\
//    [setterString appendString:NSStringFromSelector(getter).tmui_capitalizedString];\
//    [setterString appendString:@":"];\
//    SEL setter = NSSelectorFromString(setterString);\
//return setter;}

//- (void (^)(float))slideBlock
//- (void)setSlideBlock:(void (^)(float))slideBlock
//TMUICopySynthesizeId2(slideBlock);


//#define _TMUISynthesizeId(_getterName, _setterName, _policy) \
//_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))\
//- (void)_setterName:(id)_getterName {\
//    objc_setAssociatedObject(self, @selector(_getterName), _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
//}\
//\
//- (id)_getterName {\
//    return objc_getAssociatedObject(self, @selector(_getterName));\
//}\
//_Pragma("clang diagnostic pop")

//_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))
TMUISynthesizeIdCopyProperty(slideBlock, setSlideBlock);
//_Pragma("clang diagnostic pop")
- (void)ddd{
    
//    NSSelectorFromString([NSString stringWithFormat:@"set%@:",NSStringFromSelector(@selector(ddd)).tmui_capitalizedString]);
//    TMUISETTER2(@selector(ddd));
}

//TMUISynthesizeIdCopyProperty(slideBlock, setSlideBlock)

//- (void (^)(float))slideBlock{
//
//}

//TMUICopySynthesizeId1(slideBlock)

//#define _TMUISynthesizeId(_getterName, _setterName, COPY) \
//- (void)_setterName:(id)_getterName {\
//    objc_setAssociatedObject(self, @selector(_getterName), _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
//}\
//\
//- (id)_getterName {\
//    return objc_getAssociatedObject(self, @selector(_getterName));\
//}\

//- (void)setSlideBlock:(void (^)(float))slideBlock{
//    NSLog(@"set ... %s",setterWithGetter(_cmd));
//    objc_setAssociatedObject(self, @selector(slideBlock), slideBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//
//- (void (^)(float))slideBlock{
//    NSLog(@"get ... %s",_cmd);
//    return objc_getAssociatedObject(self, _cmd);
//}

@end

