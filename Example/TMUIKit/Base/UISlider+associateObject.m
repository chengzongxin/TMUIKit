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

//#define TMUICopySynthesizeId1(_getterName) _TMUISynthesizeId(_getterName,SETTER_METHOD(_getterName), COPY)
//#define TMUICopySynthesizeId1(_getterName) _TMUISynthesizeId(_getterName,setterWithGetter(_getterName), COPY)

@implementation UISlider (associateObject)

//- (void (^)(float))slideBlock
//- (void)setSlideBlock:(void (^)(float))slideBlock

TMUISynthesizeIdCopyProperty(slideBlock, setSlideBlock)

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

