//
//  TMUIPickerView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/12.
//

#import "TMUIPickerView.h"
#import "TMUIPicker.h"
#import <TMUIExtensions/TMUIExtensions.h>
#import <Masonry/Masonry.h>
#import <TMUICore/TMUICore.h>
#import "TMUIPickerViewController.h"
#import "TMUICustomCornerRadiusView.h"
#import "TMUIMultiDatePickerViewController.h"

static CGFloat const kContentH = 282;
static CGFloat const kTitleH = 44;
static CGFloat const kButtonW = 70;

@interface TMUIPickerView ()

@property (nonatomic, strong) TMUIPickerViewConfig *config;

@property (nonatomic, strong) UIControl *maskView;

@property (nonatomic, strong) TMUICustomCornerRadiusView *contentView;

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) TMUIPicker *picker;

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, assign) CGFloat animateContentHeight;

@property (nonatomic, copy) TMUIPickerSelectRowBlock selectBlock;

@property (nonatomic, copy) TMUIPickerSelectDateBlock selectDateBlock;


/// 视图将要出现、已经出现(动画过渡完成)、将要消失、已经消失(动画过渡完成)的相关时机事件回调
@property (nonatomic, copy, nullable)void(^willShowBlock)(void);///<将要出现的回调
@property (nonatomic, copy, nullable)void(^didShowBlock)(void);///<视图显示的动画效果完成后的回调
@property (nonatomic, copy, nullable)void(^willDismissBlock)(void);///<视图将要消失的回调
@property (nonatomic, copy, nullable)void(^didDismissBlock)(void);///<视图消失的动画效果完成后的回调

@end

@implementation TMUIPickerView

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)initDataPickerWithConfigBlock:(TMUIPickerConfigBlock)configBlock
                         numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock)columnsBlock
                            numberOfRowsBlock:(TMUIPickerNumberOfRowInColumnBlock)rowsBlock
                             scrollToRowBlock:(TMUIPickerScrollRowBlock)scrollBlock
                              textForRowBlock:(TMUIPickerTextForRowBlock)textBlock
                               selectRowBlock:(TMUIPickerSelectRowBlock)selectBlock{
    self = [super init];
    if (self) {
        self.config = TMUIPickerViewConfig.defaltConfig;
        if (configBlock) {
            configBlock(self.config);
        }
        [self didInitalize];
        self.picker = [[TMUIPicker alloc] initDataPickerWithType:self.config numberOfColumnsBlock:columnsBlock numberOfRowsBlock:rowsBlock scrollToRowBlock:scrollBlock textForRowBlock:textBlock];
        self.selectBlock = selectBlock;
        [self setupviews];
        [self applyConfig];
    }
    return self;
}

- (instancetype)initDatePickerWithConfigBlock:(TMUIPickerConfigBlock)configBlock
                              selectDateBlock:(TMUIPickerSelectDateBlock)selectDateBlock{
    self = [super init];
    if (self) {
        self.config = TMUIPickerViewConfig.defaltConfig;
        self.config.type = TMUIPickerViewType_Date;
        if (configBlock) {
            configBlock(self.config);
        }
        [self didInitalize];
        self.picker = [[TMUIPicker alloc] initDatePickerWithType:self.config];
        self.selectDateBlock = selectDateBlock;
        [self setupviews];
        [self applyConfig];
    }
    return self;
}


- (void)didInitalize{
//    _autoDismissWhenTapBackground = YES;
    self.maskView.enabled = self.config.autoDismissWhenTapBackground;
}

- (void)setupviews{
    [self addSubview:self.maskView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.confirmBtn];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.picker];
    
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0).priorityHigh();
        make.height.mas_equalTo(kContentH);
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kTitleH);
        make.left.right.equalTo(_contentView).inset(kButtonW);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kButtonW);
        make.height.mas_equalTo(kTitleH);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.width.mas_equalTo(kButtonW);
        make.height.mas_equalTo(kTitleH);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTitleH);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTitleH);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)applyConfig{
    self.titleLbl.text = self.config.title;
}

#pragma mark - Public
#pragma mark 时间选择器
+ (void)showDatePickerWithConfigBlock:(TMUIPickerConfigBlock)configBlock selectDateBlock:(TMUIPickerSelectDateBlock)selectDateBlock{
    TMUIPickerView *pickerView = [[TMUIPickerView alloc] initDatePickerWithConfigBlock:configBlock selectDateBlock:selectDateBlock];
    [pickerView show];
    
}

+ (void)showMultiDatePickerWithConfigBlock:(TMUIPickerConfigBlock)configBlock selectDateBlock:(TMUIPickerMultiDateSelectDateBlock)selectDateBlock{
    [TMUIMultiDatePickerViewController showFromViewController:UIViewController.new.tmui_topViewController configBlock:configBlock callbackBlock:selectDateBlock];
}


#pragma mark 多列选择器
+ (void)showPickerWithConfigBlock:(TMUIPickerConfigBlock _Nullable)configBlock
             numberOfColumnsBlock:(TMUIPickerNumberOfColumnsBlock)columnsBlock
                numberOfRowsBlock:(TMUIPickerNumberOfRowInColumnBlock)rowsBlock
                 scrollToRowBlock:(nonnull TMUIPickerScrollRowBlock)scrollBlock
                  textForRowBlock:(TMUIPickerTextForRowBlock)textBlock
                   selectRowBlock:(TMUIPickerSelectRowBlock)selectBlock{
    TMUIPickerView *pickerView = [[TMUIPickerView alloc] initDataPickerWithConfigBlock:configBlock
                                                                  numberOfColumnsBlock:columnsBlock
                                                                     numberOfRowsBlock:rowsBlock
                                                                      scrollToRowBlock:scrollBlock
                                                                       textForRowBlock:textBlock
                                                                        selectRowBlock:selectBlock];
    [pickerView show];
}

- (void)show{
    @TMUI_weakify(self);
    [TMUIPickerViewController showFromViewController:UIViewController.new.tmui_topViewController loadContentView:^(__kindof UIViewController * _Nonnull toShowVc) {
        @TMUI_strongify(self);
        self.frame = toShowVc.view.bounds;
        [toShowVc.view addSubview:self];
        
        self.animateContentHeight = kContentH + tmui_safeAreaBottomInset();
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.animateContentHeight);
        }];
        self.maskView.alpha = 0;
        self.alpha = 0.6;
        if (self.willShowBlock) {
            self.willShowBlock();
        }
    
    } didShowBlock:^{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.maskView.alpha = 1;
            self.alpha = 1;
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            
            [self.superview setNeedsUpdateConstraints];
            [self.superview updateConstraintsIfNeeded];
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.didShowBlock) {
                self.didShowBlock();
            }
        }];
    }];
}

- (void)showInVC:(UIViewController *)vc{
    
}

- (void)dismiss{
    [self dismissWithFinishBlock:nil];
}

- (void)dismissWithFinishBlock:(void(^_Nullable)(void))finishBlock {
    if (self.willDismissBlock) {
        self.willDismissBlock();
    }
    
    @TMUI_weakify(self);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.maskView.alpha = 0;
        self.alpha = 0.6;
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.animateContentHeight);
        }];
        
        [self.superview setNeedsUpdateConstraints];
        [self.superview updateConstraintsIfNeeded];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [TMUIPickerViewController hiddenContentView:self didHiddenBlock:^{
            @TMUI_strongify(self);
            if (self.didDismissBlock) {
                self.didDismissBlock();
            }
            if (finishBlock) {
                finishBlock();
            }
        }];
    }];
}

#pragma mark - Event Respone
- (void)cancelBtnClick:(UIButton *)btn{
    [self dismiss];
}

- (void)confirmBtnClick:(UIButton *)btn{
    @TMUI_weakify(self);
    [self dismissWithFinishBlock:^{
        @TMUI_strongify(self);
        
        if (self.config.type & (TMUIPickerViewType_MultiColumn | TMUIPickerViewType_MultiColumn | TMUIPickerViewType_MultiColumnConcatenation)) {
            if (self.selectBlock) {
                self.selectBlock(self.picker.selectedIndexPaths,self.picker.selectedTexts);
            }
        }else{
            if (self.selectDateBlock) {
                self.selectDateBlock(self.picker.selectedDate);
            }
        }
    }];
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters
- (UIControl *)maskView{
    if (!_maskView) {
        _maskView = [[UIControl alloc] init];
        _maskView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        [_maskView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
    }
    return _maskView;
}

- (TMUICustomCornerRadiusView *)contentView{
    if (!_contentView) {
        _contentView = [[TMUICustomCornerRadiusView alloc] init];
        _contentView.customCornerRadius = TMUICustomCornerRadiusMake(16, 16, 0, 0);
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = UIColorDark;
        _titleLbl.font = UIFontMedium(15);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.tmui_text = @"取消";
        _cancelBtn.tmui_titleColor = UIColorPlaceholder;
        _cancelBtn.tmui_font = UIFontMedium(15);
        [_cancelBtn tmui_addTarget:self action:@selector(cancelBtnClick:)];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.tmui_text = @"确定";
        _confirmBtn.tmui_titleColor = UIColorDark;
        _confirmBtn.tmui_font = UIFontMedium(15);
        [_confirmBtn tmui_addTarget:self action:@selector(confirmBtnClick:)];
    }
    return _confirmBtn;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = UIColorHexString(@"0xE9E9E9");
    }
    return _line;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end


@implementation TMUIPickerView (TMUIPickerViewAdditions)


+ (void)showSinglePickerWithConfigBlock:(TMUIPickerConfigBlock _Nullable)configBlock texts:(NSArray <NSString *> *)texts selectBlock:(void (^)(NSInteger idx,NSString *text))selectBlock{
//    TMUIPickerView *pickerView = [[TMUIPickerView alloc] initDataPickerWithConfigBlock:configBlock numberOfColumnsBlock:^NSInteger{
//        return 1;
//    } numberOfRowsBlock:^NSInteger(NSInteger columnIndex, NSInteger curSelectedColumn1Row) {
//        return texts.count;
//    } scrollToRowBlock:^(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex) {
//
//    } textForRowBlock:^NSString * _Nullable(NSInteger columnIndex, NSInteger rowIndex, NSInteger curSelectedColumn1Row) {
//        return [texts tmui_safeObjectAtIndex:rowIndex];
//    } selectRowBlock:^(NSArray<NSIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
//        selectBlock(indexPaths.firstObject.row,texts.firstObject);
//    }];
//    [pickerView show];
    
    TMUIPickerView *pickerView = [[TMUIPickerView alloc] initDataPickerWithConfigBlock:configBlock numberOfColumnsBlock:^NSInteger(UIPickerView * _Nonnull pickerView) {
        return 1;
    } numberOfRowsBlock:^NSInteger(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSArray <NSNumber *>*selectRows) {
        return texts.count;
    } scrollToRowBlock:^(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray <NSNumber *>*selectRows) {
        
    } textForRowBlock:^NSString * _Nullable(UIPickerView * _Nonnull pickerView, NSInteger columnIndex, NSInteger rowIndex, NSArray <NSNumber *>*selectRows) {
        return [texts tmui_safeObjectAtIndex:rowIndex];
    } selectRowBlock:^(NSArray<TMUIPickerIndexPath *> * _Nonnull indexPaths, NSArray<NSString *> * _Nonnull texts) {
        selectBlock(indexPaths.firstObject.row,texts.firstObject);
    }];
    [pickerView show];
}


@end
