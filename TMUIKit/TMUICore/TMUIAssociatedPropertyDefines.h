//
//  TMUIAssociatedPropertyDefines.h
//  Pods
//
//  Created by nigel.ning on 2020/7/23.
//

#ifndef TMAssociatedPropertyMacro_h
#define TMAssociatedPropertyMacro_h

#import "TMUIWeakObjectContainer.h"
#import "TMUIBasicDefines.h"
#import <objc/runtime.h>

//针对在类型里添加属性的相关便捷宏定义

#pragma mark -  关联的属性声明

///strong修饰的OC类型,会指定setter方法格式为set__propertyName,外部用.操作符赋值即可
#define TMAssociatedPropertyStrongType(Type, propertyName) \
@property (nonatomic, strong, setter=set__##propertyName:, nullable)Type * propertyName;

///weak修饰的OC类型,会指定setter方法格式为set__propertyName,外部用.操作符赋值即可
#define TMAssociatedPropertyWeakType(Type, propertyName) \
@property (nonatomic, weak, setter=set__##propertyName:, nullable)Type * propertyName;

///assign修饰的基础数字类型,会指定setter方法格式为set__propertyName,外部用.操作符赋值即可
#define TMAssociatedPropertyAssignType(Type, propertyName) \
@property (nonatomic, assign, setter=set__##propertyName:)Type propertyName;

///assign修饰的结构体类型的数据类型，比如 CGPoint、CGSize、CGRect等，对应setter, 会指定setter方法格式为set__propertyName,外部用.操作符赋值即可
#define TMAssociatedPropertyAssignStructType(StructType, propertyName) \
@property (nonatomic, assign, setter=set__##propertyName:)StructType propertyName;

#pragma mark -  关联的属性setter\getter方法实现

#define TMAssociatedPropertyStrongTypeSetterGetter(Type, propertyName) \
@dynamic  propertyName; \
- (void)set__##propertyName:(Type *)propertyName \
{ \
    _tmui_setAssociatedStrongObj(self, @selector(propertyName), propertyName);  \
\
} \
  \
- (Type *)propertyName \
{   \
    return _tmui_associatedStrongObj(self, @selector(propertyName));    \
}   \


#define TMAssociatedPropertyWeakTypeSetterGetter(Type, propertyName) \
@dynamic  propertyName; \
- (void)set__##propertyName:(Type *)propertyName \
{ \
    _tmui_setAssociatedWeakObj(self, @selector(propertyName), propertyName);  \
\
} \
  \
- (Type *)propertyName \
{   \
    return _tmui_associatedWeakObj(self, @selector(propertyName));    \
}   \


#define TMAssociatedPropertyAssignTypeSetterGetter(Type, propertyName, numberToAssignValueMethod) \
@dynamic  propertyName; \
- (void)set__##propertyName:(Type)propertyName \
{ \
    _tmui_setAssociatedStrongObj(self, @selector(propertyName), @(propertyName));  \
\
} \
  \
- (Type)propertyName \
{   \
    NSNumber *_##Type##_##propertyName##_number = _tmui_associatedStrongObj(self, @selector(propertyName));    \
    return [_##Type##_##propertyName##_number numberToAssignValueMethod]; \
} \

#define TMAssociatedPropertyAssignStructTypeSetterGetter(Type, propertyName) \
@dynamic  propertyName; \
- (void)set__##propertyName:(Type)propertyName \
{ \
    NSValue *_##Type##_##propertyName##_value = [NSValue valueWith##Type:propertyName]; \
    _tmui_setAssociatedStrongObj(self, @selector(propertyName), _##Type##_##propertyName##_value);  \
\
} \
  \
- (Type)propertyName \
{   \
    NSValue *_##Type##_##propertyName_value = _tmui_associatedStrongObj(self, @selector(propertyName));    \
    return [_##Type##_##propertyName_value Type##Value]; \
} \


#pragma mark - 辅助方法

#pragma mark - strong或assign属性setter&getter的辅助方法
NS_INLINE void _tmui_setAssociatedStrongObj(id _Nonnull self, SEL _Nonnull sel, id _Nullable obj) {
    objc_setAssociatedObject(self, sel, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
};

NS_INLINE id _Nullable _tmui_associatedStrongObj(id _Nonnull self, SEL _Nonnull sel) {
    id obj = objc_getAssociatedObject(self, sel);
    return obj;
};

#pragma mark - weak属性setter&getter的辅助方法
NS_INLINE void _tmui_setAssociatedWeakObj(id _Nonnull self, SEL _Nonnull sel, id _Nullable obj) {
    TMUIWeakObjectContainer *weakObjContainer = objc_getAssociatedObject(self, sel);
    if (obj) {
        if (!weakObjContainer) {
            weakObjContainer = [TMUIWeakObjectContainer containerWithObject:obj];
        }
        weakObjContainer.object = obj;
    }else {
        weakObjContainer = nil;
    }
    
    objc_setAssociatedObject(self, sel, weakObjContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
};

NS_INLINE id _Nullable _tmui_associatedWeakObj(id _Nonnull self, SEL _Nonnull sel) {
    TMUIWeakObjectContainer *weakObjContainer = objc_getAssociatedObject(self, sel);
    if (weakObjContainer.object) {
        return weakObjContainer.object;
    }
    return nil;
};



/**
 以下系列宏用于在 Category 里添加 property 时，可以在 @implementation 里一句代码完成 getter/setter 的声明。暂不支持在 getter/setter 里添加自定义的逻辑，需要自定义的情况请继续使用 Code Snippet 生成的代码。
 使用方式：
 @code
 @interface NSObject (CategoryName)
 @property(nonatomic, strong) type *strongObj;
 @property(nonatomic, weak) type *weakObj;
 @property(nonatomic, assign) CGRect rectValue;
 @end
 
 @implementation NSObject (CategoryName)
 
 // 注意 setter 不需要带冒号
 TMUISynthesizeIdStrongProperty(strongObj, setStrongObj)
 TMUISynthesizeIdWeakProperty(weakObj, setWeakObj)
 TMUISynthesizeCGRectProperty(rectValue, setRectValue)
 
 @end
 @endcode
 */

#pragma mark - Meta Marcos

#define _TMUISynthesizeId(_getterName, _setterName, _policy) \
_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))\
- (void)_setterName:(id)_getterName {\
    objc_setAssociatedObject(self, @selector(_getterName), _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
}\
\
- (id)_getterName {\
    return objc_getAssociatedObject(self, @selector(_getterName));\
}\
_Pragma("clang diagnostic pop")

#define _TMUISynthesizeWeakId(_getterName, _setterName) \
_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))\
- (void)_setterName:(id)_getterName {\
    objc_setAssociatedObject(self, @selector(_getterName), [[TMUIWeakObjectContainer alloc] initWithObject:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (id)_getterName {\
    return (TMUIWeakObjectContainer *)objc_getAssociatedObject(self, @selector(_getterName));\
}\
_Pragma("clang diagnostic pop")

#define _TMUISynthesizeNonObject(_getterName, _setterName, _type, valueInitializer, valueGetter) \
_Pragma("clang diagnostic push") _Pragma(ClangWarningConcat("-Wmismatched-parameter-types")) _Pragma(ClangWarningConcat("-Wmismatched-return-types"))\
- (void)_setterName:(_type)_getterName {\
    objc_setAssociatedObject(self, @selector(_getterName), [NSNumber valueInitializer:_getterName], OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (_type)_getterName {\
    return [(NSNumber *)objc_getAssociatedObject(self, @selector(_getterName)) valueGetter];\
}\
_Pragma("clang diagnostic pop")



#pragma mark - Object Marcos

/// @property(nonatomic, strong) id xxx
#define TMUISynthesizeIdStrongProperty(_getterName, _setterName) _TMUISynthesizeId(_getterName, _setterName, RETAIN)

/// @property(nonatomic, weak) id xxx
#define TMUISynthesizeIdWeakProperty(_getterName, _setterName) _TMUISynthesizeWeakId(_getterName, _setterName)

/// @property(nonatomic, copy) id xxx
#define TMUISynthesizeIdCopyProperty(_getterName, _setterName) _TMUISynthesizeId(_getterName, _setterName, COPY)



#pragma mark - NonObject Marcos

/// @property(nonatomic, assign) Int xxx
#define TMUISynthesizeIntProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, int, numberWithInt, intValue)

/// @property(nonatomic, assign) unsigned int xxx
#define TMUISynthesizeUnsignedIntProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, unsigned int, numberWithUnsignedInt, unsignedIntValue)

/// @property(nonatomic, assign) float xxx
#define TMUISynthesizeFloatProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, float, numberWithFloat, floatValue)

/// @property(nonatomic, assign) double xxx
#define TMUISynthesizeDoubleProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, double, numberWithDouble, doubleValue)

/// @property(nonatomic, assign) BOOL xxx
#define TMUISynthesizeBOOLProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, BOOL, numberWithBool, boolValue)

/// @property(nonatomic, assign) NSInteger xxx
#define TMUISynthesizeNSIntegerProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, NSInteger, numberWithInteger, integerValue)

/// @property(nonatomic, assign) NSUInteger xxx
#define TMUISynthesizeNSUIntegerProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, NSUInteger, numberWithUnsignedInteger, unsignedIntegerValue)

/// @property(nonatomic, assign) CGFloat xxx
#define TMUISynthesizeCGFloatProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, CGFloat, numberWithDouble, doubleValue)

/// @property(nonatomic, assign) CGPoint xxx
#define TMUISynthesizeCGPointProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, CGPoint, valueWithCGPoint, CGPointValue)

/// @property(nonatomic, assign) CGSize xxx
#define TMUISynthesizeCGSizeProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, CGSize, valueWithCGSize, CGSizeValue)

/// @property(nonatomic, assign) CGRect xxx
#define TMUISynthesizeCGRectProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, CGRect, valueWithCGRect, CGRectValue)

/// @property(nonatomic, assign) UIEdgeInsets xxx
#define TMUISynthesizeUIEdgeInsetsProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, UIEdgeInsets, valueWithUIEdgeInsets, UIEdgeInsetsValue)

/// @property(nonatomic, assign) CGVector xxx
#define TMUISynthesizeCGVectorProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, CGVector, valueWithCGVector, CGVectorValue)

/// @property(nonatomic, assign) CGAffineTransform xxx
#define TMUISynthesizeCGAffineTransformProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, CGAffineTransform, valueWithCGAffineTransform, CGAffineTransformValue)

/// @property(nonatomic, assign) NSDirectionalEdgeInsets xxx
#define TMUISynthesizeNSDirectionalEdgeInsetsProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, NSDirectionalEdgeInsets, valueWithDirectionalEdgeInsets, NSDirectionalEdgeInsetsValue)

/// @property(nonatomic, assign) UIOffset xxx
#define TMUISynthesizeUIOffsetProperty(_getterName, _setterName) _TMUISynthesizeNonObject(_getterName, _setterName, UIOffset, valueWithUIOffset, UIOffsetValue)


#endif /* TMAssociatedPropertyMacro_h */
