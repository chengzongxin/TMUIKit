//
//  TMUIThemeManager.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/8.
//


#import "TMUIThemeManager.h"
#import "TMUICore.h"
#import "UIView+TMUITheme.h"
#import "UIViewController+TMUITheme.h"
#import "TMUIThemePrivate.h"
#import "UITraitCollection+TMUI.h"

NSString *const TMUIThemeDidChangeNotification = @"TMUIThemeDidChangeNotification";

@interface TMUIThemeManager ()

@property(nonatomic, strong) NSMutableArray<NSObject<NSCopying> *> *_themeIdentifiers;
@property(nonatomic, strong) NSMutableArray<NSObject *> *_themes;
@end

@implementation TMUIThemeManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, name = %@, themes = %@", [super description], self.name, self.themes];
}

// 这个方法的声明放在 TMUIThemeManagerCenter.m 里，简单实现 private 的效果
- (instancetype)initWithName:(__kindof NSObject<NSCopying> *)name {
    if (self = [super init]) {
        _name = name;
        self._themeIdentifiers = NSMutableArray.new;
        self._themes = NSMutableArray.new;
        if (@available(iOS 13.0, *)) {
            [UITraitCollection tmui_addUserInterfaceStyleWillChangeObserver:self selector:@selector(handleUserInterfaceStyleWillChangeEvent:)];
        }
    }
    return self;
}

- (void)handleUserInterfaceStyleWillChangeEvent:(UITraitCollection *)traitCollection {
    if (!_respondsSystemStyleAutomatically) return;
    if (@available(iOS 13.0, *)) {
        if (traitCollection && self.identifierForTrait) {
            self.currentThemeIdentifier = self.identifierForTrait(traitCollection);
        }
    }
}

- (void)setRespondsSystemStyleAutomatically:(BOOL)respondsSystemStyleAutomatically {
    _respondsSystemStyleAutomatically = respondsSystemStyleAutomatically;
    if (@available(iOS 13.0, *)) {
        if (_respondsSystemStyleAutomatically && self.identifierForTrait) {
             self.currentThemeIdentifier = self.identifierForTrait([UITraitCollection currentTraitCollection]);
        }
    }
}

- (void)setCurrentThemeIdentifier:(NSObject<NSCopying> *)currentThemeIdentifier {
    if (![self._themeIdentifiers containsObject:currentThemeIdentifier] && self.themeGenerator) {
        NSObject *theme = self.themeGenerator(currentThemeIdentifier);
        [self addThemeIdentifier:currentThemeIdentifier theme:theme];
    }
    
    NSAssert([self._themeIdentifiers containsObject:currentThemeIdentifier], @"%@ should be added to TMUIThemeManager.themes before it becomes current theme identifier.", currentThemeIdentifier);
    
    BOOL themeChanged = _currentThemeIdentifier && ![_currentThemeIdentifier isEqual:currentThemeIdentifier];
    
    _currentThemeIdentifier = currentThemeIdentifier;
    _currentTheme = [self themeForIdentifier:currentThemeIdentifier];
    
    if (themeChanged) {
        [self notifyThemeChanged];
    }
}

- (void)setCurrentTheme:(NSObject *)currentTheme {
    if (![self._themes containsObject:currentTheme] && self.themeIdentifierGenerator) {
        __kindof NSObject<NSCopying> *identifier = self.themeIdentifierGenerator(currentTheme);
        [self addThemeIdentifier:identifier theme:currentTheme];
    }
    
    NSAssert([self._themes containsObject:currentTheme], @"%@ should be added to TMUIThemeManager.themes before it becomes current theme.", currentTheme);
    
    BOOL themeChanged = _currentTheme && ![_currentTheme isEqual:currentTheme];
    
    _currentTheme = currentTheme;
    _currentThemeIdentifier = [self identifierForTheme:currentTheme];
    
    if (themeChanged) {
        [self notifyThemeChanged];
    }
}

- (NSArray<NSObject<NSCopying> *> *)themeIdentifiers {
    return self._themeIdentifiers.count ? self._themeIdentifiers.copy : nil;
}

- (NSArray<NSObject *> *)themes {
    return self._themes.count ? self._themes.copy : nil;
}

- (__kindof NSObject *)themeForIdentifier:(__kindof NSObject<NSCopying> *)identifier {
    NSUInteger index = [self._themeIdentifiers indexOfObject:identifier];
    if (index != NSNotFound) return self._themes[index];
    return nil;
}

- (__kindof NSObject<NSCopying> *)identifierForTheme:(__kindof NSObject *)theme {
    NSUInteger index = [self._themes indexOfObject:theme];
    if (index != NSNotFound) return self._themeIdentifiers[index];
    return nil;
}

- (void)addThemeIdentifier:(NSObject<NSCopying> *)identifier theme:(NSObject *)theme {
    NSAssert(![self._themeIdentifiers containsObject:identifier], @"unable to add duplicate theme identifier");
    NSAssert(![self._themes containsObject:theme], @"unable to add duplicate theme");
    
    [self._themeIdentifiers addObject:identifier];
    [self._themes addObject:theme];
}

- (void)removeThemeIdentifier:(NSObject<NSCopying> *)identifier {
    [self._themeIdentifiers removeObject:identifier];
}

- (void)removeTheme:(NSObject *)theme {
    [self._themes removeObject:theme];
}

- (void)notifyThemeChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:TMUIThemeDidChangeNotification object:self];
    
    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!window.hidden && window.alpha > 0.01 && window.rootViewController) {
            [window.rootViewController tmui_themeDidChangeByManager:self identifier:self.currentThemeIdentifier theme:self.currentTheme];
            
            // 某些 present style 情况下，window 上可能存在多个 viewController.view，因此需要遍历所有的 subviews，而不只是 window.rootViewController.view
            [window _tmui_themeDidChangeByManager:self identifier:self.currentThemeIdentifier theme:self.currentTheme shouldEnumeratorSubviews:YES];
        }
    }];
}

@end
