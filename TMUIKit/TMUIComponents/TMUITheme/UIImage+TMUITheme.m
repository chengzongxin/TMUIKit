//
//  UIImage+TMUITheme.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//


#import "UIImage+TMUITheme.h"
#import "TMUIThemeManager.h"
#import "TMUIThemeManagerCenter.h"
#import "TMUIThemePrivate.h"
#import "NSMethodSignature+TMUI.h"
#import "TMUICore.h"
#import "UIImage+TMUI.h"
#import <objc/message.h>

@interface UIImage (TMUITheme)

@property(nonatomic, assign) BOOL tmui_shouldUseSystemIMP;
+ (nullable UIImage *)tmui_dynamicImageWithOriginalImage:(UIImage *)image tintColor:(UIColor *)tintColor originalActionBlock:(UIImage * (^)(UIImage *aImage, UIColor *aTintColor))originalActionBlock;
@end

@interface TMUIThemeImageCache : NSCache

@end

@implementation TMUIThemeImageCache

- (instancetype)init {
    if (self = [super init]) {
        // NSCache 在 app 进入后台时会删除所有缓存，它的实现方式是在 init 的时候去监听 UIApplicationDidEnterBackgroundNotification ，一旦进入后台则调用 removeAllObjects，通过 removeObserver 可以禁用掉这个策略
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

@end

@interface TMUIAvoidExceptionProxy : NSProxy
@end

@implementation TMUIAvoidExceptionProxy

+ (instancetype)proxy {
    static dispatch_once_t onceToken;
    static TMUIAvoidExceptionProxy *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [super alloc];
    });
    return instance;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSMethodSignature tmui_avoidExceptionSignature];
}

@end

@interface TMUIThemeImage()

@property(nonatomic, strong) TMUIThemeImageCache *cachedRawImages;

@end

@implementation TMUIThemeImage

static IMP tmui_getMsgForwardIMP(NSObject *self, SEL selector) {
    
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(self.class, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            // 以下代码参考 JSPatch 的实现，但在 OpenCV 时会抛异常
            NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:encoding];
            if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location == NSNotFound) {
                methodReturnsStructValue = NO;
            }
        } @catch (__unused NSException *e) {
            // 以下代码参考 Aspect 的实现，可以兼容 OpenCV
            @try {
                NSUInteger valueSize = 0;
                NSGetSizeAndAlignment(encoding, &valueSize, NULL);

                if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                    methodReturnsStructValue = NO;
                }
            } @catch (NSException *exception) {}
        }
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}

- (void)dealloc {
    _themeProvider = nil;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (self.tmui_rawImage) {
        // 这里不能加上 [self.tmui_rawImage respondsToSelector:aSelector] 的判断，否则 UIImage 没有机会做消息转发
        return self.tmui_rawImage;
    }
    // 在 dealloc 的时候 UIImage 会调用 _isNamed 是用于判断 image 对象是否由 [UIImage imageNamed:] 创建的，并根据这个结果决定是否缓存 image，但是 TMUIThemeImage 仅仅是一个容器，真正的缓存工作会在 tmui_rawImage 的 dealloc 执行，所以可以忽略这个方法的调用
    NSArray *ignoreSelectorNames = @[@"_isNamed"];
    if (![ignoreSelectorNames containsObject:NSStringFromSelector(aSelector)]) {
//        TMUILogWarn(@"UIImage+TMUITheme", @"TMUIThemeImage 试图执行 %@ 方法，但是 tmui_rawImage 为 nil", NSStringFromSelector(aSelector));
    }
    return [TMUIAvoidExceptionProxy proxy];
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class selfClass = [TMUIThemeImage class];
        UIImage *instance =  UIImage.new;
        // TMUIThemeImage 覆盖重写了大部分 UIImage 的方法，在这些方法调用时，会交给 tmui_rawImage 处理
        // 除此之外 UIImage 内部还有很多私有方法，无法全部在 TMUIThemeImage 重写一遍，这些方法将通过消息转发的形式交给 tmui_rawImage 调用。
        [NSObject tmui_enumrateInstanceMethodsOfClass:instance.class includingInherited:NO usingBlock:^(Method  _Nonnull method, SEL  _Nonnull selector) {
            // 如果 TMUIThemeImage 已经实现了该方法，则不需要消息转发
            if (class_getInstanceMethod(selfClass, selector) != method) return;
            const char * typeDescription = (char *)method_getTypeEncoding(method);
            class_addMethod(selfClass, selector, tmui_getMsgForwardIMP(instance, selector), typeDescription);
        }];
    });
}

// 让 TMUIThemeImage 支持 NSCopying 是为了修复 iOS 12 及以下版本，TMUIThemeImage 在搭配 resizable 使用的情况下可能无法跟随主题刷新的 bug，使用的地方在 UIView+TMUITheme tmui_themeDidChangeByManager:identifier:theme 内。
// https://github.com/Tencent/TMUI_iOS/issues/971
- (id)copyWithZone:(NSZone *)zone {
    TMUIThemeImage *image = (TMUIThemeImage *)[UIImage tmui_imageWithThemeManagerName:self.managerName provider:self.themeProvider];
    image.cachedRawImages = self.cachedRawImages;
    return image;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>, rawImage is %@", NSStringFromClass(self.class), self, self.tmui_rawImage.description];
}

- (instancetype)init {
    return ((id (*)(id, SEL))[NSObject instanceMethodForSelector:_cmd])(self, _cmd);
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [self.tmui_rawImage respondsToSelector:aSelector];
}

- (BOOL)isKindOfClass:(Class)aClass {
    if (aClass == TMUIThemeImage.class) return YES;
    return [self.tmui_rawImage isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    if (aClass == TMUIThemeImage.class) return YES;
    return [self.tmui_rawImage isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [self.tmui_rawImage conformsToProtocol:aProtocol];
}

- (NSUInteger)hash {
    return (NSUInteger)self.themeProvider;
}

- (BOOL)isEqual:(id)object {
    return NO;
}

- (CGSize)size {
    return self.tmui_rawImage.size;
}

- (CGImageRef)CGImage {
    return self.tmui_rawImage.CGImage;
}

- (CIImage *)CIImage {
    return self.tmui_rawImage.CIImage;
}

- (UIImageOrientation)imageOrientation {
    return self.tmui_rawImage.imageOrientation;
}

- (CGFloat)scale {
    return self.tmui_rawImage.scale;
}

- (NSArray<UIImage *> *)images {
    return self.tmui_rawImage.images;
}

- (NSTimeInterval)duration {
    return self.tmui_rawImage.duration;
}

- (UIEdgeInsets)alignmentRectInsets {
    return self.tmui_rawImage.alignmentRectInsets;
}

- (void)drawAtPoint:(CGPoint)point {
    [self.tmui_rawImage drawAtPoint:point];
}

- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    [self.tmui_rawImage drawAtPoint:point blendMode:blendMode alpha:alpha];
}

- (void)drawInRect:(CGRect)rect {
    [self.tmui_rawImage drawInRect:rect];
}

- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
    [self.tmui_rawImage drawInRect:rect blendMode:blendMode alpha:alpha];
}

- (void)drawAsPatternInRect:(CGRect)rect {
    [self.tmui_rawImage drawAsPatternInRect:rect];
}

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets {
    return [self.tmui_rawImage resizableImageWithCapInsets:capInsets];
}

- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode {
    return [self.tmui_rawImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
}

- (UIEdgeInsets)capInsets {
    return [self.tmui_rawImage capInsets];
}

- (UIImageResizingMode)resizingMode {
    return [self.tmui_rawImage resizingMode];
}

- (UIImage *)imageWithAlignmentRectInsets:(UIEdgeInsets)alignmentInsets {
    return [self.tmui_rawImage imageWithAlignmentRectInsets:alignmentInsets];
}

- (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode {
    return [self.tmui_rawImage imageWithRenderingMode:renderingMode];
}

- (UIImageRenderingMode)renderingMode {
    return self.tmui_rawImage.renderingMode;
}

- (UIGraphicsImageRendererFormat *)imageRendererFormat {
    return self.tmui_rawImage.imageRendererFormat;
}

- (UITraitCollection *)traitCollection {
    return self.tmui_rawImage.traitCollection;
}

- (UIImageAsset *)imageAsset {
    return self.tmui_rawImage.imageAsset;
}

- (UIImage *)imageFlippedForRightToLeftLayoutDirection {
    return self.tmui_rawImage.imageFlippedForRightToLeftLayoutDirection;
}

- (BOOL)flipsForRightToLeftLayoutDirection {
    return self.tmui_rawImage.flipsForRightToLeftLayoutDirection;
}

- (UIImage *)imageWithHorizontallyFlippedOrientation {
    return self.tmui_rawImage.imageWithHorizontallyFlippedOrientation;
}

- (BOOL)isSymbolImage {
    return self.tmui_rawImage.isSymbolImage;
}

- (CGFloat)baselineOffsetFromBottom {
    return self.tmui_rawImage.baselineOffsetFromBottom;
}

- (BOOL)hasBaseline {
    return self.tmui_rawImage.hasBaseline;
}

- (UIImage *)imageWithBaselineOffsetFromBottom:(CGFloat)baselineOffset {
    return [self.tmui_rawImage imageWithBaselineOffsetFromBottom:baselineOffset];
}

- (UIImage *)imageWithoutBaseline {
    return self.tmui_rawImage.imageWithoutBaseline;
}

- (UIImageConfiguration *)configuration {
    return self.tmui_rawImage.configuration;
}

- (UIImage *)imageWithConfiguration:(UIImageConfiguration *)configuration {
    return [self.tmui_rawImage imageWithConfiguration:configuration];
}

- (UIImageSymbolConfiguration *)symbolConfiguration {
    return self.tmui_rawImage.symbolConfiguration;
}

- (UIImage *)imageByApplyingSymbolConfiguration:(UIImageSymbolConfiguration *)configuration {
    return [self.tmui_rawImage imageByApplyingSymbolConfiguration:configuration];
}

#pragma mark - <TMUIDynamicImageProtocol>

- (UIImage *)tmui_rawImage {
    if (!_themeProvider) return nil;
    TMUIThemeManager *manager = [TMUIThemeManagerCenter themeManagerWithName:self.managerName];
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@",manager.name, manager.currentThemeIdentifier];
    UIImage *rawImage = [self.cachedRawImages objectForKey:cacheKey];
    if (!rawImage) {
        rawImage = self.themeProvider(manager, manager.currentThemeIdentifier, manager.currentTheme).tmui_rawImage;
        if (rawImage) [self.cachedRawImages setObject:rawImage forKey:cacheKey];
    }
    return rawImage;
}

- (BOOL)tmui_isDynamicImage {
    return YES;
}

#pragma mark - Translator

// 由于 TMUIThemeImage 的实现里，如果某些方法 TMUIThemeImage 本身没实现，那么就会以消息转发的方式转发给 rawImage，这就导致我们无法直接用 method swizzle 的方式去重写 UIImage.class 的 imageWithTintColor 系列方法并期望它能同时作用于 UIImage 和 TMUIThemeImage（后者总是无效的，因为最终接收消息的总是 rawImage 而不是 TMUIThemeImage），所以这里需要这么冗余地显式写一遍

- (UIImage *)imageWithTintColor:(UIColor *)color {
    return [UIImage tmui_dynamicImageWithOriginalImage:self tintColor:color originalActionBlock:^UIImage *(UIImage *aImage, UIColor *aTintColor) {
        aImage.tmui_shouldUseSystemIMP = YES;
        return [aImage imageWithTintColor:color];
    }];
}

- (UIImage *)imageWithTintColor:(UIColor *)color renderingMode:(UIImageRenderingMode)renderingMode {
    return [UIImage tmui_dynamicImageWithOriginalImage:self tintColor:color originalActionBlock:^UIImage *(UIImage *aImage, UIColor *aTintColor) {
        aImage.tmui_shouldUseSystemIMP = YES;
        return [aImage imageWithTintColor:color renderingMode:renderingMode];
    }];
}

- (UIImage *)tmui_imageWithTintColor:(UIColor *)color {
    return [UIImage tmui_dynamicImageWithOriginalImage:self tintColor:color originalActionBlock:^UIImage *(UIImage *aImage, UIColor *aTintColor) {
        aImage.tmui_shouldUseSystemIMP = YES;
        return [aImage tmui_imageWithTintColor:color];
    }];
}

@end

@implementation UIImage (TMUITheme)

TMUISynthesizeBOOLProperty(tmui_shouldUseSystemIMP, setTmui_shouldUseSystemIMP)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 支持用一个动态颜色直接生成一个动态图片
        OverrideImplementation(object_getClass(UIImage.class), @selector(tmui_imageWithColor:size:cornerRadius:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UIImage *(UIImage *selfObject, UIColor *color, CGSize size, CGFloat cornerRadius) {
                
                // call super
                UIImage * (^callSuperBlock)(UIColor *, CGSize, CGFloat) = ^UIImage *(UIColor *aColor, CGSize aSize, CGFloat aCornerRadius) {
                    UIImage * (*originSelectorIMP)(id, SEL, UIColor *, CGSize, CGFloat);
                    originSelectorIMP = (UIImage * (*)(id, SEL, UIColor *, CGSize, CGFloat))originalIMPProvider();
                    UIImage * result = originSelectorIMP(selfObject, originCMD, aColor, aSize, aCornerRadius);
                    return result;
                };
                
                if ([color isKindOfClass:TMUIThemeColor.class]) {
                    return [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
                        return callSuperBlock(((TMUIThemeColor *)color).themeProvider(manager, identifier, theme), size, cornerRadius);
                    }];
                }
                return callSuperBlock(color, size, cornerRadius);
            };
        });
        
        OverrideImplementation(object_getClass(UIImage.class), @selector(tmui_imageWithColor:size:cornerRadiusArray:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UIImage *(UIImage *selfObject, UIColor *color, CGSize size, NSArray<NSNumber *> *cornerRadius) {
                
                // call super
                UIImage * (^callSuperBlock)(UIColor *, CGSize, NSArray<NSNumber *> *) = ^UIImage *(UIColor *aColor, CGSize aSize, NSArray<NSNumber *> * aCornerRadius) {
                    UIImage * (*originSelectorIMP)(id, SEL, UIColor *, CGSize, NSArray<NSNumber *> *);
                    originSelectorIMP = (UIImage * (*)(id, SEL, UIColor *, CGSize, NSArray<NSNumber *> *))originalIMPProvider();
                    UIImage * result = originSelectorIMP(selfObject, originCMD, aColor, aSize, aCornerRadius);
                    return result;
                };
                
                if ([color isKindOfClass:TMUIThemeColor.class]) {
                    return [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
                        return callSuperBlock(((TMUIThemeColor *)color).themeProvider(manager, identifier, theme), size, cornerRadius);
                    }];
                }
                return callSuperBlock(color, size, cornerRadius);
            };
        });
        
        // 令一个静态图片叠加动态颜色可以转换成动态图片
        OverrideImplementation([UIImage class], @selector(tmui_imageWithTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^UIImage *(UIImage *selfObject, UIColor *tintColor) {
                
                UIImage *result = [UIImage tmui_dynamicImageWithOriginalImage:selfObject tintColor:tintColor originalActionBlock:^UIImage *(UIImage *aImage, UIColor *aTintColor) {
                    aImage.tmui_shouldUseSystemIMP = YES;
                    return [aImage tmui_imageWithTintColor:aTintColor];
                }];
                if (!result) {
                    // call super
                    UIImage *(*originSelectorIMP)(id, SEL, UIColor *);
                    originSelectorIMP = (UIImage * (*)(id, SEL, UIColor *))originalIMPProvider();
                    result = originSelectorIMP(selfObject, originCMD, tintColor);
                }
                return result;
            };
        });
        if (@available(iOS 13.0, *)) {
            // 如果一个静态的 UIImage 通过 imageWithTintColor: 传入一个动态的颜色，那么这个 UIImage 也会变成动态的，但这个动态图片是 iOS 13 系统原生的动态图片，无法响应 TMUITheme，所以这里需要为 TMUIThemeImage 做特殊处理。
            // 注意，系统的 imageWithTintColor: 不会调用 imageWithTintColor:renderingMode:，所以要分开重写两个方法
            OverrideImplementation([UIImage class], @selector(imageWithTintColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UIImage *(UIImage *selfObject, UIColor *tintColor) {
                    
                    UIImage *result = [UIImage tmui_dynamicImageWithOriginalImage:selfObject tintColor:tintColor originalActionBlock:^UIImage *(UIImage *aImage, UIColor *aTintColor) {
                        aImage.tmui_shouldUseSystemIMP = YES;
                        return [aImage imageWithTintColor:aTintColor];
                    }];
                    if (!result) {
                        // call super
                        UIImage *(*originSelectorIMP)(id, SEL, UIColor *);
                        originSelectorIMP = (UIImage * (*)(id, SEL, UIColor *))originalIMPProvider();
                        result = originSelectorIMP(selfObject, originCMD, tintColor);
                    }
                    return result;
                };
            });
            OverrideImplementation([UIImage class], @selector(imageWithTintColor:renderingMode:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UIImage *(UIImage *selfObject, UIColor *tintColor, UIImageRenderingMode renderingMode) {
                    
                    UIImage *result = [UIImage tmui_dynamicImageWithOriginalImage:selfObject tintColor:tintColor originalActionBlock:^UIImage *(UIImage *aImage, UIColor *aTintColor) {
                        aImage.tmui_shouldUseSystemIMP = YES;
                        return [aImage imageWithTintColor:aTintColor renderingMode:renderingMode];
                    }];
                    if (!result) {
                        // call super
                        UIImage *(*originSelectorIMP)(id, SEL, UIColor *, UIImageRenderingMode);
                        originSelectorIMP = (UIImage * (*)(id, SEL, UIColor *, UIImageRenderingMode))originalIMPProvider();
                        result = originSelectorIMP(selfObject, originCMD, tintColor, renderingMode);
                    }
                    return result;
                };
            });
        }
    });
}

+ (UIImage *)tmui_imageWithThemeProvider:(UIImage * _Nonnull (^)(__kindof TMUIThemeManager * _Nonnull, __kindof NSObject<NSCopying> * _Nullable, __kindof NSObject * _Nullable))provider {
    return [UIImage tmui_imageWithThemeManagerName:TMUIThemeManagerNameDefault provider:provider];
}

+ (UIImage *)tmui_imageWithThemeManagerName:(__kindof NSObject<NSCopying> *)name provider:(UIImage * _Nonnull (^)(__kindof TMUIThemeManager * _Nonnull, __kindof NSObject<NSCopying> * _Nullable, __kindof NSObject * _Nullable))provider {
    TMUIThemeImage *image = [[TMUIThemeImage alloc] init];
    image.cachedRawImages = [[TMUIThemeImageCache alloc] init];
    image.managerName = name;
    image.themeProvider = provider;
    return (UIImage *)image;
}

+ (nullable UIImage *)tmui_dynamicImageWithOriginalImage:(UIImage *)image tintColor:(UIColor *)tintColor originalActionBlock:(UIImage * (^)(UIImage *aImage, UIColor *aTintColor))originalActionBlock {
    if (image.tmui_shouldUseSystemIMP) {
        image.tmui_shouldUseSystemIMP = NO;
        return nil;
    }
    if ([image isKindOfClass:TMUIThemeImage.class]) {
        // 当前是动态 image，不管 tintColor 是否为动态的，都返回一个动态 image
        TMUIThemeImage *themeImage = (TMUIThemeImage *)image;
        return [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
            return originalActionBlock(themeImage.themeProvider(manager, identifier, theme), tintColor);
        }];
    }
    if ([tintColor isKindOfClass:TMUIThemeColor.class]) {
        // 当前是静态 image，则只有当 tintColor 是动态的时候才将静态 image 转换为动态 image
        return [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
            TMUIThemeColor *themeColor = (TMUIThemeColor *)tintColor;
            return originalActionBlock(image, themeColor.themeProvider(manager, identifier, theme));
        }];
    }
    
    return nil;
}

#pragma mark - <TMUIDynamicImageProtocol>

- (UIImage *)tmui_rawImage {
    return self;
}

- (BOOL)tmui_isDynamicImage {
    return NO;
}

@end
