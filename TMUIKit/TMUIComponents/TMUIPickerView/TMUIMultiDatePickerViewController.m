//
//  TMUIMultiDatePickerViewController.m
//  TMUIKit
//
//  Created by Joe.cheng on 2022/4/15.
//

#import "TMUIMultiDatePickerViewController.h"
#import "TMUIPickerView.h"
#import "TMUICustomDatePicker.h"
#import "TMUICore.h"
#import "TMUIKitDefines.h"
#import "TMUIExtensions.h"

@interface TMUIMultiDatePickerViewController ()
<TMUICustomDatePickerDelegate>
@property (nonatomic, assign)int actionFlag;///< 0-当前为月选择器，1为日选择中的开始时间，2为日选择中的结束时间，用于datePicker的显示内容
@property (nonatomic, strong)void (^dateCallback)(TMUIMultiDatePickerResult *result);

@property (nonatomic, strong)UIView *bgAlphaView;
@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, strong)UIView *contentTopBar;
@property (nonatomic, strong)UISegmentedControl *segmengtControl;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *okBtn;

@property (nonatomic, strong)TMUICustomDatePicker *datePicker;

@property (nonatomic, strong)UIView *monthBgView;
@property (nonatomic, strong)UILabel *monthLabel;
@property (nonatomic, strong)UIView *monthLine;

@property (nonatomic, strong)UIView *dayBgView;
@property (nonatomic, strong)UIButton *dayBeginBtn;
@property (nonatomic, strong)UIView *dayBeginLine;
@property (nonatomic, strong)UIButton *dayEndBtn;
@property (nonatomic, strong)UIView *dayEndLine;

@property (nonatomic, strong) TMUIPickerViewConfig *config;
//
//@property (nonatomic, strong)NSDate *monthDate, *dayBeginDate, *dayEndDate;
//@property (nonatomic, assign)TMUIMultiDatePickerViewControllerType type;

@property (nonatomic, strong)NSDateFormatter *dateFormatter;///< 用于格式化日期


@end

@implementation TMUIMultiDatePickerViewController

+ (void)showFromViewController:(UIViewController *)fromVC configBlock:(TMUIPickerConfigBlock)configBlock callbackBlock:(TMUIPickerMultiDateSelectDateBlock)callback{
    TMUIMultiDatePickerViewController *vc = [[TMUIMultiDatePickerViewController alloc] init];
    // 配置config
    TMUIPickerViewConfig *config = TMUIPickerViewConfig.defaltConfig;
    config.multiDateType = TMUIMultiDatePickerViewControllerType_Month;
    config.monthDate = NSDate.date;
    config.dayBeginDate = NSDate.date;
    config.dayEndDate = [[NSDate date] tmui_dateByAddingYears:1];
    vc.dateCallback = callback;
    vc.config = config;
    if (configBlock) {
        configBlock(vc.config);
    }
    UIViewController *pVC = fromVC;
    if (pVC.tabBarController) {
        pVC = pVC.tabBarController;
    }else if ([pVC isKindOfClass:[UINavigationController class]]) {
        
    }else if (pVC.navigationController) {
        pVC = pVC.navigationController;
    }
    while (pVC.presentedViewController) {
        pVC = pVC.presentedViewController;
    }
    vc.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [pVC presentViewController:vc animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showWithAnimate:YES];
}

- (void)showWithAnimate:(BOOL)animate
{
    if (animate) {
        CGRect rt = self.contentView.frame;
        rt.origin.y = TMUI_SCREEN_HEIGHT - rt.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.bgAlphaView.alpha = 1;
            self.contentView.frame = rt;
            [self.contentView tmui_cornerDirect:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
            [self.view layoutSubviews];
        }];
    }else {
        self.bgAlphaView.alpha = 1;
        CGRect rt = self.contentView.frame;
        rt.origin.y = TMUI_SCREEN_WIDTH - rt.size.height;
        self.contentView.frame = rt;
        [self.contentView tmui_cornerDirect:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
    }
    //若有初始参数值则调整UI显示
//    if (self.recordObject) {
//        self.type = self.recordObject.type;
//        self.dayBeginDate = self.recordObject.dayDateBegin;
//        self.dayEndDate = self.recordObject.dayDateEnd;
//        self.monthDate = self.recordObject.monthDate;
//        NSInteger toIndex = self.type == TMUIMultiDatePickerViewControllerType_Month ? 0 : 1;
//        [self.segmengtControl setSelectedSegmentIndex:toIndex];
//        [self switchContentViewToIndex:toIndex];
//    }
    
    
//    self.type = self.config.multiDateType;
//    self.dayBeginDate = self.config.minimumDate;
//    self.monthDate = self.config.minimumDate;
//    self.dayEndDate = self.config.maximumDate;
    NSInteger toIndex = self.config.multiDateType == TMUIMultiDatePickerViewControllerType_Month ? 0 : 1;
    [self.segmengtControl setSelectedSegmentIndex:toIndex];
    self.datePicker.date = self.config.date;
    [self switchContentViewToIndex:toIndex];
    
}

- (void)hideWithAnimate:(BOOL)animate{
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgAlphaView.alpha = 0;
            self.contentView.y = TMUI_SCREEN_HEIGHT;
            [self.view layoutSubviews];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)segmengtChanged:(UISegmentedControl *)seg
{
    NSInteger toIndex = seg.selectedSegmentIndex;
    self.config.multiDateType = toIndex == 0 ? TMUIMultiDatePickerViewControllerType_Month : TMUIMultiDatePickerViewControllerType_Day;
    [self switchContentViewToIndex:toIndex];
}

- (void)switchContentViewToIndex:(NSInteger)index
{
    if (index == 0) {
        self.monthBgView.alpha = 1;
        self.dayBgView.alpha = 0;
        self.datePicker.minimumDate = nil;
        [self.datePicker setDate:self.config.monthDate];
        _datePicker.datePickerMode = TMUIDatePickerMode_YearMonth;
        self.actionFlag = 0;
    }else {
        self.monthBgView.alpha = 0;
        self.dayBgView.alpha = 1;
        self.datePicker.minimumDate = nil;
        [self.datePicker setDate:self.config.dayBeginDate];
        _datePicker.datePickerMode = TMUIDatePickerMode_YearMonthDay;
        self.actionFlag = 1;
        [self updateDayContentViewLabelAndButtons];
        
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [self.dateFormatter stringFromDate:self.config.dayBeginDate];
        [self.dayBeginBtn setTitle:dateStr forState:UIControlStateNormal];
        dateStr = @"结束时间";
        if (self.config.dayEndDate) {
            dateStr = [self.dateFormatter stringFromDate:self.config.dayEndDate];
        }
        [self.dayEndBtn setTitle:dateStr forState:UIControlStateNormal];
    }
}
- (void)updateDayContentViewLabelAndButtons
{
    if (self.actionFlag == 1) {
        [self.dayBeginBtn setTitleColor:UIColorHex(1A1C1A) forState:UIControlStateNormal];
//        [self.dayBeginLine setBackgroundColor:UIColorHex(24C77E)];
        [self.dayEndBtn setTitleColor:UIColorHex(C1C1C1) forState:UIControlStateNormal];
//        [self.dayEndLine setBackgroundColor:UIColorHex(24C1C1C1)];
    }else if (self.actionFlag == 2) {
        [self.dayBeginBtn setTitleColor:UIColorHex(C1C1C1) forState:UIControlStateNormal];
//        [self.dayBeginLine setBackgroundColor:UIColorHex(24C1C1C1)];
        [self.dayEndBtn setTitleColor:UIColorHex(1A1C1A) forState:UIControlStateNormal];
//        [self.dayEndLine setBackgroundColor:UIColorHex(24C77E)];
    }
}

- (void)cancelClick
{
    [self hideWithAnimate:YES];
}
- (void)okClick
{
    if (self.dateCallback) {
        TMUIMultiDatePickerResult *result = [[TMUIMultiDatePickerResult alloc] init];
        result.type = self.config.multiDateType;
        result.monthDate = self.config.monthDate;
        result.dayDateBegin = self.config.dayBeginDate;
        result.dayDateEnd = self.config.dayEndDate;
        if (result.type == TMUIMultiDatePickerViewControllerType_Day && !result.dayDateEnd) {
            result.dayDateEnd = [NSDate date];
        }
        self.dateCallback(result);
    }
    [self hideWithAnimate:YES];
}

- (void)dayBeginBtnClick
{
    if (self.actionFlag == 1) {
        return;
    }
    self.actionFlag = 1;
    [self updateDayContentViewLabelAndButtons];
    self.datePicker.minimumDate = nil;
    [self.datePicker setDate:self.config.dayBeginDate];
}

- (void)dayEndBtnClick
{
    if (self.actionFlag == 2) {
        return;
    }
    self.actionFlag = 2;
    [self updateDayContentViewLabelAndButtons];
    self.datePicker.minimumDate = self.config.dayBeginDate;
    if (!self.config.dayEndDate) {
        self.config.dayEndDate = [NSDate date];
    }
    if (self.config.dayEndDate) {
        [self.datePicker setDate:self.config.dayEndDate];
        
        //点击后自动填写当前结束日期(默认当前时间或上一次记录的日期值)
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [self.dateFormatter stringFromDate:self.config.dayEndDate];
        [self.dayEndBtn setTitle:dateStr forState:UIControlStateNormal];
    }
}

#pragma mark - getter
- (UIView *)bgAlphaView
{
    if (!_bgAlphaView) {
        _bgAlphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT)];
        _bgAlphaView.alpha = 0;
        _bgAlphaView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self.view insertSubview:_bgAlphaView atIndex:0];
    }
    return _bgAlphaView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        float h = self.contentTopBar.frame.size.height + 297 + tmui_safeAreaBottomInset();
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, TMUI_SCREEN_HEIGHT, TMUI_SCREEN_WIDTH, h)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        [self.view addSubview:_contentView];
        //
        [_contentView addSubview:self.contentTopBar];
        
        CGRect rt = self.monthBgView.frame;
        rt.origin.y = self.contentTopBar.bounds.size.height;
        self.monthBgView.frame = rt;
        [_contentView addSubview:self.monthBgView];
        
        rt = self.dayBgView.frame;
        rt.origin.y = self.contentTopBar.bounds.size.height;
        self.dayBgView.frame = rt;
        [_contentView addSubview:self.dayBgView];
        
        rt = self.datePicker.frame;
        rt.origin.y = CGRectGetMaxY(self.monthBgView.frame);
        self.datePicker.frame = rt;
        [_contentView addSubview:self.datePicker];
        
        if (self.config.multiDateType == TMUIMultiDatePickerViewControllerType_Month) {
            [self.segmengtControl setSelectedSegmentIndex:0];
            self.monthBgView.alpha = 1;
            self.dayBgView.alpha = 0;
        }else {
            [self.segmengtControl setSelectedSegmentIndex:1];
            self.monthBgView.alpha = 0;
            self.dayBgView.alpha = 1;
        }
    }
    return _contentView;
}

- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter) {
        _dateFormatter = [NSDate tmui_sharedDateFormatter];
    }
    return _dateFormatter;
}

- (UIView *)contentTopBar
{
    if (!_contentTopBar) {
        _contentTopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, 44*1)];
        _contentTopBar.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _contentTopBar.bounds.size.height-0.5, _contentTopBar.bounds.size.width, 0.5)];
        line.backgroundColor = UIColorHex(E9E9E9);
        [_contentTopBar addSubview:line];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15,(_contentTopBar.bounds.size.height-36)/2, 40, 36)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex(979997) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        self.cancelBtn = btn;
        [_contentTopBar addSubview:btn];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(_contentTopBar.bounds.size.width-15-40,(_contentTopBar.bounds.size.height-36)/2, 40, 36)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex(1A1C1A) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
        self.okBtn = btn;
        [_contentTopBar addSubview:btn];
        
        CGRect rt = CGRectMake(0, 0, 152*1, 30*1);
        rt.origin.x = (_contentTopBar.bounds.size.width-rt.size.width)/2;
        rt.origin.y = (_contentTopBar.bounds.size.height-rt.size.height)/2;
        self.segmengtControl = [[UISegmentedControl alloc] initWithItems:@[@"按月选择",@"按日选择"]];
        [self.segmengtControl setTintColor:UIColorHex(F6F8F6)];
        [self.segmengtControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(979997),
                                                       NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]} forState:UIControlStateNormal];
        [self.segmengtControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorHex(1A1C1A),
            NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightMedium]} forState:UIControlStateSelected];
        [self.segmengtControl setFrame:rt];
        [self.segmengtControl addTarget:self action:@selector(segmengtChanged:) forControlEvents:UIControlEventValueChanged];
        [_contentTopBar addSubview:self.segmengtControl];
        
    }
    return _contentTopBar;
}

- (UIView *)monthBgView
{
    if (!_monthBgView) {
        _monthBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*1, TMUI_SCREEN_WIDTH, 60 * 1)];
        self.monthLine = [[UIView alloc] initWithFrame:CGRectMake(0, _monthBgView.bounds.size.height-1, 140*1, 1)];
        CGRect rt = self.monthLine.frame;
        rt.origin.x = (_monthBgView.bounds.size.width-rt.size.width)/2;
        self.monthLine.frame = rt;
        self.monthLine.backgroundColor = UIColorHex(E9E9E9);
        [_monthBgView addSubview:self.monthLine];
        
        rt.size.height = 24*1;
        rt.origin.y = _monthBgView.bounds.size.height - 5 - rt.size.height;
        self.monthLabel = [[UILabel alloc] initWithFrame:rt];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        [self.monthLabel setTextColor:UIColorHex(1A1C1A)];
        [self.monthLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
        
        [self.dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *dateStr = [self.dateFormatter stringFromDate:self.config.monthDate];
        [self.monthLabel setText:dateStr];
        
        [_monthBgView addSubview:self.monthLabel];
    }
    return _monthBgView;
}

- (UIView *)dayBgView
{
    if (!_dayBgView) {
        _dayBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*1, TMUI_SCREEN_WIDTH, 60 * 1)];
        self.dayBeginLine = [[UIView alloc] initWithFrame:CGRectMake(15, _dayBgView.bounds.size.height - 1, 140*1, 1)];
        self.dayBeginLine.backgroundColor = UIColorHex(E9E9E9);
        [_dayBgView addSubview:self.dayBeginLine];
        
        CGRect rt = self.dayBeginLine.frame;
        rt.size.height = 24*1;
        rt.origin.y = _dayBgView.bounds.size.height - 5 - rt.size.height;
        self.dayBeginBtn = [[UIButton alloc] initWithFrame:rt];
        [self.dayBeginBtn setTitleColor:UIColorHex(1A1C1A) forState:UIControlStateNormal];
        [self.dayBeginBtn.titleLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightRegular]];
        [self.dayBeginBtn addTarget:self action:@selector(dayBeginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_dayBgView addSubview:self.dayBeginBtn];
        
        rt = self.dayBeginLine.frame;
        rt.size.height = 24*1;
        rt.origin.y = _dayBgView.bounds.size.height - 5 - rt.size.height;
        UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake((_dayBgView.bounds.size.width-rt.size.height)/2, rt.origin.y, rt.size.height, rt.size.height)];
        centerLabel.textAlignment = NSTextAlignmentCenter;
        centerLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        centerLabel.textColor = UIColorHex(C1C1C1);
        centerLabel.text = @"至";
        [_dayBgView addSubview:centerLabel];
        
        self.dayEndLine = [[UIView alloc] initWithFrame:CGRectMake(_dayBgView.bounds.size.width - 15 - 140*1, _dayBgView.bounds.size.height - 1, 140*1, 1)];
        self.dayEndLine.backgroundColor = UIColorHex(E9E9E9);
        [_dayBgView addSubview:self.dayEndLine];
        
        rt = self.dayEndLine.frame;
        rt.size.height = 24*1;
        rt.origin.y = _dayBgView.bounds.size.height - 5 - rt.size.height;
        self.dayEndBtn = [[UIButton alloc] initWithFrame:rt];
        [self.dayEndBtn setTitleColor:UIColorHex(C1C1C1) forState:UIControlStateNormal];
        [self.dayEndBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
        [self.dayEndBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        [self.dayEndBtn addTarget:self action:@selector(dayEndBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_dayBgView addSubview:self.dayEndBtn];
    }
    return _dayBgView;
}

- (TMUICustomDatePicker *)datePicker
{
    
    if (!_datePicker) {
        _datePicker = [[TMUICustomDatePicker alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, 257)];
        _datePicker.date = NSDate.date;
        _datePicker.datePickerMode = TMUIDatePickerMode_YearMonth;
        _datePicker.delegate = _datePicker;
        _datePicker.dataSource = _datePicker;
        _datePicker.changedDelegate = self;
    }
    return _datePicker;
}

- (void)datePickerDidChanged:(TMUICustomDatePicker *)picker
{
    if (self.actionFlag == 0) {
        self.config.monthDate = picker.date;
        [self.dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *dateStr = [self.dateFormatter stringFromDate:self.config.monthDate];
        [self.monthLabel setText:dateStr];
    }else if (self.actionFlag == 1) {
        self.config.dayBeginDate = picker.date;
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [self.dateFormatter stringFromDate:self.config.dayBeginDate];
        [self.dayBeginBtn setTitle:dateStr forState:UIControlStateNormal];
    }else if (self.actionFlag == 2) {
        self.config.dayEndDate = picker.date;
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [self.dateFormatter stringFromDate:self.config.dayEndDate];
        [self.dayEndBtn setTitle:dateStr forState:UIControlStateNormal];
    }
}


@end
