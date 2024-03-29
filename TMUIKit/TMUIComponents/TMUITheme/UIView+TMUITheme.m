//
//  UIView+TMUITheme.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//


#import "UIView+TMUITheme.h"
#import <TMUICore/TMUIKitDefines.h>
#import <TMUICore/TMUIAssociatedPropertyDefines.h>
#import <TMUICore/TMUICommonDefines.h>
#import <TMUIExtensions/UIView+TMUI.h>
#import <TMUIExtensions/UIColor+TMUI.h>
#import <TMUIExtensions/UIImage+TMUI.h>
#import "UIImage+TMUITheme.h"
#import "UIVisualEffect+TMUITheme.h"
#import "TMUIThemeManagerCenter.h"
#import <TMUIExtensions/CALayer+TMUI.h>
#import "TMUIThemeManager.h"
#import "TMUIThemePrivate.h"
#import <TMUIExtensions/NSObject+TMUI.h>
#import <TMUIExtensions/UITextInputTraits+TMUI.h>
#import <TMUICore/TMUIRuntime.h>
#import <TMUICore/TMUIConfigurationMacros.h>
@implementation UIView (TMUITheme)

TMUISynthesizeIdCopyProperty(tmui_themeDidChangeBlock, setTmui_themeDidChangeBlock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        OverrideImplementation([UIView class], @selector(setHidden:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, BOOL firstArgv) {
                
                BOOL valueChanged = selfObject.hidden != firstArgv;
                
                // call super
                void (*originSelectorIMP)(id, SEL, BOOL);
                originSelectorIMP = (void (*)(id, SEL, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (valueChanged) {
                    // UIView.tmui_currentThemeIdentifier 只是为了实现判断当前的 theme 是否有发生变化，所以可以构造成一个 string，但怎么避免每次 hidden 切换时都要遍历所有的 subviews？
                    [selfObject _tmui_themeDidChangeByManager:nil identifier:nil theme:nil shouldEnumeratorSubviews:YES];
                }
            };
        });
        
        OverrideImplementation([UIView class], @selector(setAlpha:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UIView *selfObject, CGFloat firstArgv) {
                
                BOOL willShow = selfObject.alpha <= 0 && firstArgv > 0.01;
                
                // call super
                void (*originSelectorIMP)(id, SEL, CGFloat);
                originSelectorIMP = (void (*)(id, SEL, CGFloat))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (willShow) {
                    // 只设置 identifier 就可以了，内部自然会去同步更新 theme
                    [selfObject _tmui_themeDidChangeByManager:nil identifier:nil theme:nil shouldEnumeratorSubviews:YES];
                }
            };
        });
        
        // 这几个 class 实现了自己的 didMoveToWindow 且没有调用 super，所以需要每个都替换一遍方法
        NSArray<Class> *classes = @[UIView.class,
                                    UICollectionView.class,
                                    UITextField.class,
                                    UISearchBar.class,
                                    NSClassFromString(@"UITableViewLabel")];
        if (NSClassFromString(@"WKWebView")) {
            classes = [classes arrayByAddingObject:NSClassFromString(@"WKWebView")];
        }
        [classes enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
            ExtendImplementationOfVoidMethodWithoutArguments(class, @selector(didMoveToWindow), ^(UIView *selfObject) {
                // enumerateSubviews 为 NO 是因为当某个 view 的 didMoveToWindow 被触发时，它的每个 subview 的 didMoveToWindow 也都会被触发，所以不需要遍历 subview 了
                if (selfObject.window) {
                    [selfObject _tmui_themeDidChangeByManager:nil identifier:nil theme:nil shouldEnumeratorSubviews:NO];
                }
            });
        }];
    });
}

- (void)tmui_registerThemeColorProperties:(NSArray<NSString *> *)getters {
    [getters enumerateObjectsUsingBlock:^(NSString * _Nonnull getterString, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL getter = NSSelectorFromString(getterString);
        SEL setter = setterWithGetter(getter);
        NSString *setterString = NSStringFromSelector(setter);
        NSAssert([self respondsToSelector:getter], @"register theme color fails, %@ does not have method called %@", NSStringFromClass(self.class), getterString);
        NSAssert([self respondsToSelector:setter], @"register theme color fails, %@ does not have method called %@", NSStringFromClass(self.class), setterString);
        
        if (!self.tmuiTheme_themeColorProperties) {
            self.tmuiTheme_themeColorProperties = NSMutableDictionary.new;
        }
        self.tmuiTheme_themeColorProperties[getterString] = setterString;
    }];
}

- (void)tmui_unregisterThemeColorProperties:(NSArray<NSString *> *)getters {
    if (!self.tmuiTheme_themeColorProperties) return;
    
    [getters enumerateObjectsUsingBlock:^(NSString * _Nonnull getterString, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tmuiTheme_themeColorProperties removeObjectForKey:getterString];
    }];
}

- (void)tmui_themeDidChangeByManager:(TMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    if (![self _tmui_visible]) return;
    
    if (self.tag == 999) {
        NSLog(@"%@",self);
    }
    
    // 常见的 view 在 TMUIThemePrivate 里注册了 getter，在这里被调用
    [self.tmuiTheme_themeColorProperties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull getterString, NSString * _Nonnull setterString, BOOL * _Nonnull stop) {
        
        SEL getter = NSSelectorFromString(getterString);
        SEL setter = NSSelectorFromString(setterString);
        
        // 由于 tintColor 属性自带向下传递的性质，并且当值为 nil 时会自动从 superview 读取值，所以不需要在这里遍历修改，否则取出 tintColor 后再设置回去，会打破这个传递链
        if (getter == @selector(tintColor)) {
            if (!self.tmui_tintColorCustomized) return;
        }
        
        // 如果某个 UITabBarItem 处于选中状态，此时发生了主题变化，执行了 UITabBarSwappableImageView.image = image 的动作，就会把 selectedImage 设置为 normal image，无法恢复。所以对 UITabBarSwappableImageView 屏蔽掉 setImage 的刷新操作
        // https://github.com/Tencent/TMUI_iOS/issues/1122
        if ([self isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")] && getter == @selector(image)) {
            return;
        }
        
        // 注意，需要遍历的属性不一定都是 UIColor 类型，也有可能是 NSAttributedString，例如 UITextField.attributedText
        BeginIgnorePerformSelectorLeaksWarning
        id value = [self performSelector:getter];
        if (!value) return;
        BOOL isValidatedColor = [value isKindOfClass:TMUIThemeColor.class] && (!manager || [((TMUIThemeColor *)value).managerName isEqual:manager.name]);
        BOOL isValidatedImage = [value isKindOfClass:TMUIThemeImage.class] && (!manager || [((TMUIThemeImage *)value).managerName isEqual:manager.name]);
        BOOL isValidatedEffect = [value isKindOfClass:TMUIThemeVisualEffect.class] && (!manager || [((TMUIThemeVisualEffect *)value).managerName isEqual:manager.name]);
        BOOL isOtherObject = ![value isKindOfClass:UIColor.class] && ![value isKindOfClass:UIImage.class] && ![value isKindOfClass:UIVisualEffect.class];// 支持所有非 color、image、effect 的其他对象，例如 NSAttributedString
        if (isOtherObject || isValidatedColor || isValidatedImage || isValidatedEffect) {
            
            
            // 修复 iOS 12 及以下版本，TMUIThemeImage 在搭配 resizable 使用的情况下可能无法跟随主题刷新的 bug
            // https://github.com/Tencent/TMUI_iOS/issues/971
            if (@available(iOS 13.0, *)) {
            } else {
                if (isValidatedImage) {
                    TMUIThemeImage *image = (TMUIThemeImage *)value;
                    if (image.tmui_resizable) {
                        value = image.copy;
                    }
                }
            }
            
            [self performSelector:setter withObject:value];
        }
        EndIgnorePerformSelectorLeaksWarning
    }];
    
    // 特殊的 view 特殊处理
    // iOS 10-11 里当 UILabel.attributedText 的文字颜色都相同时，也无法使用 setNeedsDisplay 刷新样式，但只要某个 range 颜色不同就没问题，iOS 9、12-13 也没问题，这个通过 UILabel (TMUIThemeCompatibility) 兼容。
    // iOS 9-13，当 UITextField 没有聚焦时，不需要调用 setNeedsDisplay 系统都可以自动更新文字样式，但聚焦时调用 setNeedsDisplay 也无法更新样式，这里依赖了 UITextField (TMUIThemeCompatibility) 对 setNeedsDisplay 做的兼容实现了更新
    // 注意，iOS 11 及以下的 UITextView 直接调用 setNeedsDisplay 是无法刷新文字样式的，这里依赖了 UITextView (TMUIThemeCompatibility) 里通过 swizzle 实现了兼容，iOS 12 及以上没问题。
    static NSArray<Class> *needsDisplayClasses = nil;
    if (!needsDisplayClasses) needsDisplayClasses = @[UILabel.class, UITextField.class, UITextView.class];
    [needsDisplayClasses enumerateObjectsUsingBlock:^(Class  _Nonnull class, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isKindOfClass:class]) {
            
            [self setNeedsDisplay];
            
        }
    }];
    
    // 输入框、搜索框的键盘跟随主题变化
    if (TMUICMIActivated && [self conformsToProtocol:@protocol(UITextInputTraits)]) {
        NSObject<UITextInputTraits> *input = (NSObject<UITextInputTraits> *)self;
        if ([input respondsToSelector:@selector(keyboardAppearance)]) {
            if (input.keyboardAppearance != KeyboardAppearance && !input.tmui_hasCustomizedKeyboardAppearance) {
                input.tmui_keyboardAppearance = KeyboardAppearance;
            }
        }
    }
    
    /** 这里去掉动画有 2 个原因：
     1. iOS 13 进入后台时会对 currentTraitCollection.userInterfaceStyle 做一次取反进行截图，以便在后台切换 Drak/Light 后能够更新 app 多任务缩略图，TMUI 响应了这个操作去调整取反后的 layer 的颜色，而在对 layer 设置属性的时候，如果包含了动画会导致截图不到最终的状态，这样会导致在后台切换 Drak/Light 后多任务缩略图无法及时更新。
     2. 对于 UIView 层，修改 backgroundColor 默认是没有动画的，而 CALayer 修改 backgroundColor 会有隐式动画，这里为了在响应主题变化时颜色同步更新，统一把 CALayer 的动画去掉
     */
    [CALayer tmui_performWithoutAnimation:^{
        [self.layer tmui_setNeedsUpdateDynamicStyle];
    }];
    
    if (self.tmui_themeDidChangeBlock) {
        self.tmui_themeDidChangeBlock();
    }
}

@end

@implementation UIView (TMUITheme_Private)

TMUISynthesizeIdStrongProperty(tmuiTheme_themeColorProperties, setTmuiTheme_themeColorProperties)

- (BOOL)_tmui_visible {
    BOOL hidden = self.hidden;
    if ([self respondsToSelector:@selector(prepareForReuse)]) {
        hidden = NO;// UITableViewCell 在 prepareForReuse 前会被 setHidden:YES，然后再被 setHidden:NO，然而后者是无效的，执行完之后依然是 hidden 为 YES，导致认为非 visible 而无法触发 themeDidChange，所以这里对 UITableViewCell 做特殊处理
    }
    return !hidden && self.alpha > 0.01 && self.window;
}

- (void)_tmui_themeDidChangeByManager:(TMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme shouldEnumeratorSubviews:(BOOL)shouldEnumeratorSubviews {
    [self tmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    if (shouldEnumeratorSubviews) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
            [subview _tmui_themeDidChangeByManager:manager identifier:identifier theme:theme shouldEnumeratorSubviews:YES];
        }];
    }
}

@end
