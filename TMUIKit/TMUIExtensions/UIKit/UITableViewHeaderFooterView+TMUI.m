//
//  UITableViewHeaderFooterView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/4/15.
//

#import "UITableViewHeaderFooterView+TMUI.h"
#import "TMUICore.h"
#import "UITableView+TMUI.h"
#import "UIView+TMUI.h"

@implementation UITableViewHeaderFooterView (TMUI)

- (UITableView *)tmui_tableView {
    return [self valueForKey:@"tableView"];
}

@end


@implementation UITableViewHeaderFooterView (TMUI_InsetGrouped)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        // 决定 tableView 赋予 header/footer 的高度
//        OverrideImplementation([UITableViewHeaderFooterView class], @selector(initWithReuseIdentifier:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//            return ^UITableViewHeaderFooterView *(UITableViewHeaderFooterView *selfObject, NSString *firstArgv) {
//
//                // call super
//                UITableViewHeaderFooterView *(*originSelectorIMP)(id, SEL, NSString *);
//                originSelectorIMP = (UITableViewHeaderFooterView * (*)(id, SEL, NSString *))originalIMPProvider();
//                UITableViewHeaderFooterView *result = originSelectorIMP(selfObject, originCMD, firstArgv);
//
//                // iOS 13 系统的 UITableViewHeaderFooterView sizeThatFits: 接收的宽度是整个 tableView 的宽度，内部再根据 layoutMargins 调整 contentView，而为了保证所有 iOS 版本在重写 UITableViewHeaderFooterView sizeThatFits: 时可以用相同的计算方式，这里为 iOS 13 下的子类也调整了 sizeThatFits: 宽度的值，这样子类重写时直接把参数 size.width 当成缩进后的宽度即可。
//                BOOL shouldConsiderSystemClass = YES;
//                if (@available(iOS 13.0, *)) {
//                    shouldConsiderSystemClass = NO;
//                }
//                if (shouldConsiderSystemClass || selfObject.class != UITableViewHeaderFooterView.class) {
//                    [TMUIHelper executeBlock:^{
//                        OverrideImplementation(selfObject.class, @selector(sizeThatFits:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//                            return ^CGSize(UITableViewHeaderFooterView *view, CGSize size) {
//
//                                BOOL shouldChangeWidth = view.tmui_tableView && view.tmui_tableView.tmui_style == TMUITableViewStyleInsetGrouped;
//                                if (shouldChangeWidth) {
//                                    size.width = size.width - UIEdgeInsetsGetHorizontalValue(view.tmui_tableView.tmui_safeAreaInsets) - view.tmui_tableView.tmui_insetGroupedHorizontalInset * 2;
//                                }
//
//                                // call super
//                                CGSize (*originSelectorIMP)(id, SEL, CGSize);
//                                originSelectorIMP = (CGSize (*)(id, SEL, CGSize))originalIMPProvider();
//                                CGSize result = originSelectorIMP(view, originCMD, size);
//
//                                return result;
//                            };
//                        });
//                    } oncePerIdentifier:[NSString stringWithFormat:@"InsetGroupedHeader %@-%@", NSStringFromClass(selfObject.class), NSStringFromSelector(@selector(sizeThatFits:))]];
//                }
//
//                return result;
//            };
//        });
//
//        // iOS 13 都交给系统处理，下面的逻辑不需要
//        if (@available(iOS 13.0, *)) return;
//
//        if (@available(iOS 11.0, *)) {
//            // 系统通过这个方法返回值来决定 contentView 的布局
//            OverrideImplementation([UITableViewHeaderFooterView class], NSSelectorFromString(@"_contentRectForWidth:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//                return ^CGRect(UITableViewHeaderFooterView *selfObject, CGFloat firstArgv) {
//                    BOOL shouldChangeWidth = firstArgv > 0 && selfObject.tmui_tableView && selfObject.tmui_tableView.tmui_style == TMUITableViewStyleInsetGrouped;
//                    if (shouldChangeWidth) {
//                        firstArgv -= UIEdgeInsetsGetHorizontalValue(selfObject.tmui_tableView.tmui_safeAreaInsets) + selfObject.tmui_tableView.tmui_insetGroupedHorizontalInset * 2;
//                    }
//
//                    // call super
//                    CGRect (*originSelectorIMP)(id, SEL, CGFloat);
//                    originSelectorIMP = (CGRect (*)(id, SEL, CGFloat))originalIMPProvider();
//                    CGRect result = originSelectorIMP(selfObject, originCMD, firstArgv);
//
//                    if (shouldChangeWidth) {
//                        result = CGRectSetX(result, selfObject.tmui_tableView.tmui_safeAreaInsets.left + selfObject.tmui_tableView.tmui_insetGroupedHorizontalInset);
//                    }
//                    return result;
//                };
//            });
//        } else {
//            // TODO: molice iOS 10 及以下是另一套实现方式，暂时不知道怎么修改 textLabel 的布局
//            OverrideImplementation([UITableViewHeaderFooterView class], @selector(layoutSubviews), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
//                return ^(UITableViewHeaderFooterView *selfObject) {
//
//                    // call super
//                    void (*originSelectorIMP)(id, SEL);
//                    originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
//                    originSelectorIMP(selfObject, originCMD);
//
//                    if (selfObject.tmui_tableView && selfObject.tmui_tableView.tmui_style == TMUITableViewStyleInsetGrouped) {
//                        selfObject.contentView.frame = CGRectMake(selfObject.tmui_tableView.tmui_safeAreaInsets.left + selfObject.tmui_tableView.tmui_insetGroupedHorizontalInset, CGRectGetMinY(selfObject.contentView.frame), selfObject.tmui_tableView.tmui_validContentWidth, CGRectGetHeight(selfObject.bounds));
//                    }
//                };
//            });
//        }
//    });
//}

@end
