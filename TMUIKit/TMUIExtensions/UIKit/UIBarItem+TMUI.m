//
//  UIBarItem+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/29.
//

#import "UIBarItem+TMUI.h"
#import "NSObject+TMUI.h"
#import "UIView+TMUI.h"
#import "TMUIAssociatedPropertyDefines.h"
#import "TMUICommonDefines.h"
#import "TMUIHelper.h"
#import "TMUIRuntime.h"
//#import "TMUIWeakObjectContainer.h"

@interface UIBarItem ()

@property(nonatomic, copy) NSString *tmuibaritem_viewDidSetBlockIdentifier;
@end

@implementation UIBarItem (TMUI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // UIBarButtonItem -setView:
        // @warning 如果作为 UIToolbar.items 使用，则 customView 的情况下，iOS 10 及以下的版本不会调用 setView:，所以那种情况改为在 setToolbarItems:animated: 时调用，代码见下方
        ExtendImplementationOfVoidMethodWithSingleArgument([UIBarButtonItem class], @selector(setView:), UIView *, ^(UIBarButtonItem *selfObject, UIView *firstArgv) {
            [UIBarItem setView:firstArgv inBarButtonItem:selfObject];
        });
        
        if (IOS_VERSION_NUMBER < 110000) {
            // iOS 11.0 及以上，通过 setView: 调用 tmui_viewDidSetBlock 即可，10.0 及以下只能在 setToolbarItems 的时机触发
            ExtendImplementationOfVoidMethodWithTwoArguments([UIViewController class], @selector(setToolbarItems:animated:), NSArray<__kindof UIBarButtonItem *> *, BOOL, ^(UIViewController *selfObject, NSArray<__kindof UIBarButtonItem *> *firstArgv, BOOL secondArgv) {
                for (UIBarButtonItem *item in firstArgv) {
                    [UIBarItem setView:item.customView inBarButtonItem:item];
                }
            });
        }
        
        
        // UITabBarItem -setView:
        ExtendImplementationOfVoidMethodWithSingleArgument([UITabBarItem class], @selector(setView:), UIView *, ^(UITabBarItem *selfObject, UIView *firstArgv) {
            [UIBarItem setView:firstArgv inBarItem:selfObject];
        });
    });
}

- (UIView *)tmui_view {
    // UIBarItem 本身没有 view 属性，只有子类 UIBarButtonItem 和 UITabBarItem 才有
    if ([self respondsToSelector:@selector(view)]) {
        return [self tmui_valueForKey:@"view"];
    }
    return nil;
}

TMUISynthesizeIdCopyProperty(tmuibaritem_viewDidSetBlockIdentifier, setTmuibaritem_viewDidSetBlockIdentifier)
TMUISynthesizeIdCopyProperty(tmui_viewDidSetBlock, setTmui_viewDidSetBlock)

static char kAssociatedObjectKey_viewDidLayoutSubviewsBlock;
- (void)setTmui_viewDidLayoutSubviewsBlock:(void (^)(__kindof UIBarItem * _Nonnull, UIView * _Nullable))tmui_viewDidLayoutSubviewsBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_viewDidLayoutSubviewsBlock, tmui_viewDidLayoutSubviewsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (self.tmui_view) {
        __weak __typeof(self)weakSelf = self;
        self.tmui_view.tmui_layoutSubviewsBlock = ^(__kindof UIView * _Nonnull view) {
            if (weakSelf.tmui_viewDidLayoutSubviewsBlock) {
                weakSelf.tmui_viewDidLayoutSubviewsBlock(weakSelf, view);
            }
        };
    }
}

- (void (^)(__kindof UIBarItem * _Nonnull, UIView * _Nullable))tmui_viewDidLayoutSubviewsBlock {
    return (void (^)(__kindof UIBarItem * _Nonnull, UIView * _Nullable))objc_getAssociatedObject(self, &kAssociatedObjectKey_viewDidLayoutSubviewsBlock);
}

static char kAssociatedObjectKey_viewLayoutDidChangeBlock;
- (void)setTmui_viewLayoutDidChangeBlock:(void (^)(__kindof UIBarItem * _Nonnull, UIView * _Nullable))tmui_viewLayoutDidChangeBlock {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_viewLayoutDidChangeBlock, tmui_viewLayoutDidChangeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 这里有个骚操作，对于 iOS 11 及以上，item.view 被放在一个 UIStackView 内，而当屏幕旋转时，通过 item.view.tmui_frameDidChangeBlock 得到的时机过早，布局尚未被更新，所以把 tmui_frameDidChangeBlock 放到 stackView 上以保证时机的准确性，但当调用 tmui_viewLayoutDidChangeBlock 时传进去的参数 view 依然要是 item.view
    UIView *view = self.tmui_view;
    if (IOS_VERSION_NUMBER >= 110000 && [view.superview isKindOfClass:[UIStackView class]]) {
        view = self.tmui_view.superview;
    }
    if (view) {
        __weak __typeof(self)weakSelf = self;
        view.tmui_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
            if (weakSelf.tmui_viewLayoutDidChangeBlock){
                weakSelf.tmui_viewLayoutDidChangeBlock(weakSelf, weakSelf.tmui_view);
            }
        };
    }
}

- (void (^)(__kindof UIBarItem * _Nonnull, UIView * _Nullable))tmui_viewLayoutDidChangeBlock {
    return (void (^)(__kindof UIBarItem * _Nonnull, UIView * _Nullable))objc_getAssociatedObject(self, &kAssociatedObjectKey_viewLayoutDidChangeBlock);
}

#pragma mark - Tools

+ (NSString *)identifierWithView:(UIView *)view block:(id)block {
    return [NSString stringWithFormat:@"%p, %p", view, block];
}

+ (void)setView:(UIView *)view inBarItem:(__kindof UIBarItem *)item {
    if (item.tmui_viewDidSetBlock) {
        item.tmui_viewDidSetBlock(item, view);
    }
    
    if (item.tmui_viewDidLayoutSubviewsBlock) {
        item.tmui_viewDidLayoutSubviewsBlock = item.tmui_viewDidLayoutSubviewsBlock;// to call setter
    }
    
    if (item.tmui_viewLayoutDidChangeBlock) {
        item.tmui_viewLayoutDidChangeBlock = item.tmui_viewLayoutDidChangeBlock;// to call setter
    }
}

+ (void)setView:(UIView *)view inBarButtonItem:(UIBarButtonItem *)item {
    if (![[UIBarItem identifierWithView:view block:item.tmui_viewDidSetBlock] isEqualToString:item.tmuibaritem_viewDidSetBlockIdentifier]) {
        item.tmuibaritem_viewDidSetBlockIdentifier = [UIBarItem identifierWithView:view block:item.tmui_viewDidSetBlock];
        
        [self setView:view inBarItem:item];
    }
}

@end
