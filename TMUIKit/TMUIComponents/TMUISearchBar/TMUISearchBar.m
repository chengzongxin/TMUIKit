//
//  TMUISearchBar.m
//  Demo
//
//  Created by 程宗鑫 on 2022/3/15.
//

#import "TMUISearchBar.h"

CGFloat const TMUISearchBarHeight = 36;

NS_INLINE UIImage *kImgName(NSString *imageName) {
    return [NSBundle tmui_imageName:imageName bundleName:@"TMUISearchBarUIAssets"]; // 位于pod中使用
//     [UIImage tmui_imageInBundleWithName:imgName];  // 位于项目中使用
}

@interface TMUISearchBar () <TMUITextFieldDelegate>

@property (nonatomic, assign) TMUISearchBarStyle style;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) TMUIButton *cityBtn;

@property (nonatomic, strong) UIView *seperator;

@property (nonatomic, strong) UIImageView *searchIcon;

@property (nonatomic, strong) TMUITextField *textField;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, assign) BOOL isUseSystemNavBar;

@end

@implementation TMUISearchBar

#pragma mark - 初始化
+ (instancetype)searchBarForSystemNavigationBar{
    TMUISearchBar *searchBar = [[TMUISearchBar alloc] initWithStyle:TMUISearchBarStyle_Normal frame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH - 20, TMUISearchBarHeight)];
    searchBar.isUseSystemNavBar = YES;
    [searchBar.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
    }];
    return searchBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithStyle:TMUISearchBarStyle_Normal frame:frame];
}

- (instancetype)initWithStyle:(TMUISearchBarStyle)style {
    return [self initWithStyle:style frame:CGRectZero];
}

- (instancetype)initWithStyle:(TMUISearchBarStyle)style frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.isCanInput = YES;
        self.showsCancelButton = NO;
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.layer.cornerRadius = TMUISearchBarHeight/2;
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    // normal style
    if (self.style == TMUISearchBarStyle_Normal) {
        [self.contentView addSubview:self.searchIcon];
        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(12);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [self.contentView addSubview:self.textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(TMUISearchBarHeight);
            make.left.equalTo(_searchIcon.mas_right).with.offset(8);
            make.right.equalTo(self.contentView);
        }];
    }else if (self.style == TMUISearchBarStyle_City) {
        // city style, left city ,right search
        [self.contentView addSubview:self.cityBtn];
        [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(self.contentView);
            make.width.mas_equalTo(80);
        }];
        
        [self.contentView addSubview:self.seperator];
        [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_cityBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(1, 14));
        }];
        
        [self.contentView addSubview:self.searchIcon];
        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_cityBtn.mas_right).offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [self.contentView addSubview:self.textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(TMUISearchBarHeight);
            make.left.equalTo(_searchIcon.mas_right).with.offset(8);
            make.right.equalTo(self.contentView);
        }];
    }
}

#pragma mark - Public
- (void)setText:(NSString *)text{
//    _text = text;
    _textField.text = text;
}

- (NSString *)text{
//    _text = _textField.text;
    return _textField.text;
}

- (void)setCurrentCity:(NSString *)currentCity{
    _currentCity = currentCity;
    _cityBtn.tmui_text = currentCity;
}

- (void)setMaxTextLength:(NSInteger)maxTextLength{
    _textField.maximumTextLength = maxTextLength;
}

- (void)setPlaceholder:(NSString *)placeHolder{
    _placeholder = placeHolder;
    _textField.placeholder = placeHolder;
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton{
    _showsCancelButton = showsCancelButton;
    
    CGFloat cancelW = _isUseSystemNavBar ? 38 : 58;
    CGFloat offsetCancelW = _isUseSystemNavBar ? 10 : 0;
    
    if (showsCancelButton) {
        [self addSubview:self.cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_textField);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(cancelW);
            make.height.equalTo(_textField);
        }];
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-cancelW-offsetCancelW);
        }];
    }else{
        [_cancelBtn removeFromSuperview];
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
    }
    
    if (self.window) {
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - Responder
- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    return [self.textField becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.textField resignFirstResponder];
}
- (BOOL)isFirstResponder {
    return [self.textField isFirstResponder];
}

#pragma mark - Action
/// 城市按钮点击
- (void)cityBtnClick:(UIButton *)btn{
    !_cityClick?:_cityClick(btn);
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCityClick:cityBtn:)]) {
        [self.delegate searchBarCityClick:self cityBtn:btn];
    }
}

/// 文字发生改变
- (void)textDidChange:(UITextField *)textField{
    !_textChange?:_textChange(textField,textField.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextChange:textField:)]) {
        [self.delegate searchBarTextChange:self textField:textField];
    }
}

/// 文本框被点击
- (void)textFieldDidClick:(UITapGestureRecognizer *)tap{
    !_textBegin?:_textBegin(_textField);
}

/// 点击取消按钮
- (void)cancelBtnClick:(UIButton *)btn{
    if (_cancelClick) {
        _cancelClick(btn);
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelClick:cancelBtn:)]) {
        [self.delegate searchBarCancelClick:self cancelBtn:btn];
    }else{
        [[UIViewController.new tmui_topViewController] tmui_navBackAction:nil];
    }
}

#pragma mark - Delegate
/// 输入框是否可点击
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    !_textBegin?:_textBegin(_textField);
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSholdBegin:textField:)]) {
        return [self.delegate searchBarSholdBegin:self textField:textField];
    }
    return self.isCanInput;
}

/// 输入达到最大长度
- (void)textField:(TMUITextField *)textField didPreventTextChangeInRange:(NSRange)range replacementString:(NSString *)replacementString{
    !_maxLength?:_maxLength(textField,range,replacementString);
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextMaxLength:textField:range:replacementString:)]) {
        [self.delegate searchBarTextMaxLength:self textField:textField range:range replacementString:replacementString];
    }
}

/// 输入完成，点击完成事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    !_textDone?:_textDone(textField,textField.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDone:textField:)]) {
        [self.delegate searchBarTextDone:self textField:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

/// 输入完成事件
- (void)textFieldDidEndEditing:(UITextField *)textField{
    !_textEnd?:_textEnd(textField,textField.text);
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextEnd:textField:)]) {
        [self.delegate searchBarTextEnd:self textField:textField];
    }
}

/// 点击清除按钮
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    !_clearClick?:_clearClick();
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarClearClick:)]) {
        [self.delegate searchBarClearClick:self];
    }
    return YES;
}

- (void)setIsCanInput:(BOOL)isCanInput{
    _isCanInput = isCanInput;
}

#pragma mark - Getter & Setter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = UIColorHex(F9FAF9);
        _contentView.layer.borderColor = UIColorHex(ECEEEC).CGColor;
        _contentView.layer.cornerRadius = TMUISearchBarHeight/2;
        _contentView.layer.borderWidth = .5;
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIButton *)cityBtn{
    if (!_cityBtn) {
        _cityBtn = [TMUIButton tmui_button];
        _cityBtn.spacingBetweenImageAndTitle = 9;
        _cityBtn.imagePosition = TMUIButtonImagePositionRight;
        _cityBtn.tmui_text = @"深圳";
        _cityBtn.tmui_image = kImgName(@"tmui_searchBar_arrow");
        _cityBtn.tmui_titleColor = UIColorHex(1A1C1A);
        _cityBtn.tmui_font = UIFont(14);
        [_cityBtn tmui_addTarget:self action:@selector(cityBtnClick:)];
    }
    return _cityBtn;
}

- (UIView *)seperator{
    if (!_seperator) {
        _seperator = [[UIView alloc] init];
        _seperator.backgroundColor = UIColorHex(E2E4E2);
    }
    return _seperator;
}

- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.backgroundColor = [UIColor clearColor];
        _searchIcon.image = kImgName(@"tmui_searchBar_magnifier");
    }
    return _searchIcon;
}

- (TMUITextField *)textField{
    if (!_textField) {
        _textField = [[TMUITextField alloc] init];
        _textField.tintColor = UIColorHex(22C77D);
        _textField.textColor = UIColorHex(1A1C1A);
        _textField.placeholderColor = UIColorHex(7E807E);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.clipsToBounds = YES;
        _textField.font = UIFont(14);
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = UIFont(14);
        [_cancelBtn setTitleColor:UIColorHex(1A1C1A) forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(0, 0, 44, 44);
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

#pragma mark - NSObject

/// 当作为titleView时，在iOS11中导航栏上会缩成一团，需要重写这个方法解决
/// 可通过调用,invalidateIntrinsicContentSize方法，再次计算内置size
- (CGSize)intrinsicContentSize{
    if (CGSizeIsEmpty(self.bounds.size)) {
        return CGSizeMake(UILayoutFittingExpandedSize.width, TMUISearchBarHeight);
    }else{
        return self.bounds.size;
    }
}



@end


@implementation UIBarButtonItem (TMUI_EX)


// [UIBarButtonItem itemWithTitle:@" 取消 " font:UIFont(14) titleColor:UIColorFromRGB(0x111111) target:self action:@selector(cancelClick)
+ (NSArray <UIBarButtonItem *> *)cancelItemWithTarget:(id)target action:(SEL)action{
    UIBarButtonItem *space = [UIBarButtonItem tmui_fixedSpaceItemWithWidth:10];
    UIBarButtonItem *item = [UIBarButtonItem tmui_itemWithTitle:@"取消" color:UIColorHex(0x1A1C1A) font:UIFont(14) size:CGSizeMake(44, 44) target:target action:action];
    return @[item,space];
}

+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
    return [[self alloc] tmui_initWithTitle:title color:color font:font size:CGSizeZero target:target action:action];
}

- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action{
    return [self tmui_initWithTitle:title color:color font:font size:CGSizeZero target:target action:action];
}

+ (instancetype)tmui_itemWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font size:(CGSize)size target:(nonnull id)target action:(nonnull SEL)action {
    return [[self alloc] tmui_initWithTitle:title color:color font:font size:size target:target action:action];
}

- (instancetype)tmui_initWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font size:(CGSize)size target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:color forState:UIControlStateNormal];
    if (!CGSizeIsEmpty(size)) {
        btn.frame = CGRectMake(0, 0, size.width, size.height);
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [self initWithCustomView:btn];
}

@end
