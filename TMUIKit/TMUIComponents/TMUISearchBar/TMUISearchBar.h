//
//  TMUISearchBar.h
//  Demo
//
//  Created by 程宗鑫 on 2022/3/15.
//

#import <UIKit/UIKit.h>
#import <TMUICore/TMUICore.h>
#import <TMUIComponents/TMUIButton.h>
#import <TMUIComponents/TMUITextField.h>

NS_ASSUME_NONNULL_BEGIN
///  搜索栏默认高度
UIKIT_EXTERN CGFloat const TMUISearchBarHeight;

@class TMUISearchBar;

typedef void(^TMUISearchBarCityClickBlock)(UIButton *cityBtn);
typedef void(^TMUISearchBarTextBeginBlock)(UITextField *textField);
typedef void(^TMUISearchBarTextChangeBlock)(UITextField *textField,NSString *text);
typedef void(^TMUISearchBarTextDoneBlock)(UITextField *textField,NSString *text);
typedef void(^TMUISearchBarTextEndBlock)(UITextField *textField,NSString *text);
typedef void(^TMUISearchBarTextMaxLengthBlock)(UITextField *textField,NSRange range,NSString *replacementString);
typedef void(^TMUISearchBarCancelClickBlock)(UIButton *btn);
typedef void(^TMUISearchBarClearClickBlock)(void);


@protocol TMUISearchBarDelegate <NSObject>
@optional
/// 点击城市回调
- (void)searchBarCityClick:(TMUISearchBar *)searchBar cityBtn:(UIButton *)cityBtn;
/// 是否开始编辑回调
- (BOOL)searchBarSholdBegin:(TMUISearchBar *)searchBar textField:(UITextField *)textField;
/// 文字发生改变
- (void)searchBarTextChange:(TMUISearchBar *)searchBar textField:(UITextField *)textField;
/// 输入完成，点击完成事件
- (void)searchBarTextDone:(TMUISearchBar *)searchBar textField:(UITextField *)textField;
/// 输入完成事件
- (void)searchBarTextEnd:(TMUISearchBar *)searchBar textField:(UITextField *)textField;
/// 输入达到最大长度
- (void)searchBarTextMaxLength:(TMUISearchBar *)searchBar textField:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)replacementString;
/// 点击取消按钮
- (void)searchBarCancelClick:(TMUISearchBar *)searchBar cancelBtn:(UIButton *)cancelBtn;
/// 点击清除按钮
- (void)searchBarClearClick:(TMUISearchBar *)searchBar;
@end


typedef enum : NSUInteger {
    TMUISearchBarStyle_Normal,  ///< 普通样式搜索，只有一个单独的搜索框
    TMUISearchBarStyle_City,  ///< 城市搜索样式，左边有一个城市选择按钮，右边是搜索框
    TMUISearchBarStyle_City_White,  ///< 城市搜索样式，左边有一个城市选择按钮，右边是搜索框, 白色样式
    TMUISearchBarStyle_City_Black,  ///< 城市搜索样式，左边有一个城市选择按钮，右边是搜索框, 黑色样式
} TMUISearchBarStyle;

/*
 Usage:
 TMUISearchBar *searchBar = [[TMUISearchBar alloc] initWithFrame:CGRectMake(20, 0, TMUI_SCREEN_WIDTH - 20, TMUISearchBarHeight)];
 searchBar.placeHolder = self.placeholder ? : @"城市名";
 @weakify(self);
 searchBar.textChange = ^(UITextField * _Nonnull textField, NSString * _Nonnull text) {
    @strongify(self);
    [self reload];
 }
 */
/// 土巴兔项目通用搜索栏组件，一般只作为单独的搜索使用
/// 如果要在右侧添加取消，或者其他功能，请自行添加，
/// 系统导航栏添加，UIBarButtonItem，使用-[UIBarButtonItem cancelItemWithTarget:...]方法,，并且，在作为系统导航栏titleView时不需要设置frame，因为系统会自动适应titleView
/// 自定义导航栏，TMUINavigationBar，使用内置rightItem
@interface TMUISearchBar : UIView

#pragma mark - 初始化
- (instancetype)initWithStyle:(TMUISearchBarStyle)style;
- (instancetype)initWithStyle:(TMUISearchBarStyle)style frame:(CGRect)frame;
/// 系统导航栏定制，一般在系统导航栏上显示
+ (instancetype)searchBarForSystemNavigationBar;
#pragma mark - 属性成员
@property (nonatomic, assign, readonly) TMUISearchBarStyle      style;

@property (nonatomic, weak, readwrite) id<TMUISearchBarDelegate>delegate;

@property (nonatomic, strong, readonly) TMUIButton              *cityBtn;

@property (nonatomic, strong, readonly) UIView                  *seperator;

@property (nonatomic, strong, readonly) UIImageView             *searchIcon;

@property (nonatomic, strong, readonly) TMUITextField           *textField;

#pragma mark - 方法接口
/// 输入框文本,手动设置会触发事件
@property (nonatomic, strong) NSString                          *text;
/// 输入框占位文字
@property (nonatomic, strong) NSString                          *placeholder;
/// 是否可输入，默认YES
@property (nonatomic, assign) BOOL                              isCanInput;
/// 是否显示取消按钮，默认NO
@property (nonatomic, assign) BOOL                              showsCancelButton;
/// 最大文字长度
@property (nonatomic, assign) NSInteger                         maxTextLength;
/// 当前城市
@property (nonatomic, strong) NSString                          *currentCity;

#pragma mark - 事件响应
/// 点击城市回调
@property (nonatomic, copy) TMUISearchBarCityClickBlock         cityClick;
/// 点击输入框回调
@property (nonatomic, copy) TMUISearchBarTextBeginBlock         textBegin;
/// 文字改变回调
@property (nonatomic, copy) TMUISearchBarTextChangeBlock        textChange;
/// 文字输入点击return回调
@property (nonatomic, copy) TMUISearchBarTextDoneBlock          textDone;
/// 文字输入完成回调
@property (nonatomic, copy) TMUISearchBarTextEndBlock           textEnd;
/// 输入达到最大长度回调
@property (nonatomic, copy) TMUISearchBarTextMaxLengthBlock     maxLength;
/// 点击取消按钮回调（不实现这个方法，会自动返回上一页）
@property (nonatomic, copy) TMUISearchBarCancelClickBlock       cancelClick;
/// 点击清除按钮回调
@property (nonatomic, copy) TMUISearchBarClearClickBlock        clearClick;

#pragma mark - Responder
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;

@end

@interface UIBarButtonItem (TMUI_EX)

/// 创建一个供系统导航栏使用的取消按钮（UIBarButtonItem）
+ (NSArray <UIBarButtonItem *> *)cancelItemWithTarget:(id)target action:(SEL)action;

+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font size:(CGSize)size target:(id)target action:(SEL)action;
- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font size:(CGSize)size target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
