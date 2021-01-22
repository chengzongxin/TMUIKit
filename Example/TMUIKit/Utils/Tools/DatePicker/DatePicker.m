//
//  DatePicker.m
//  Matafy
//
//  Created by Jason on 2018/11/28.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import "DatePicker.h"
#define KWindowWidth   [UIScreen mainScreen].bounds.size.width
#define KWindowHeight   [UIScreen mainScreen].bounds.size.height
#define TitleBtnCOLOR [UIColor colorWithRed:(102)/255.0 green:(102)/255.0 blue:(102)/255.0 alpha:1]
#define zhuBlueCOLOR [UIColor colorWithRed:(0)/255.0 green:(150)/255.0 blue:(255)/255.0 alpha:1]

@interface DatePicker ()
{
    PassValue myBlock;
    UIDatePicker *datePicker;
    UIDatePicker *datePicker1;
    UIButton *viewPandle;
    NSString *string3;
    UIButton *buttonCancle;
    UIButton *buttonSure;
    UIView *viewbottom;
}
@end

@implementation DatePicker

+(instancetype)setDate
{
    return [[self alloc]init];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self windowframe];//显示window
        
        [self twoButton]; //设置取消和确定按钮
        
        [self datePicker];//布局datePicker
    }
    
    return self;
}

#pragma mark  年月日 与  小时
-(void)datePicker
{
    //创建一个UIPickView对象
    datePicker = [[UIDatePicker alloc]init];
    //自定义位置
    datePicker.frame = CGRectMake(0, CGRectGetMaxY(viewbottom.frame), KWindowWidth, 200);
    //设置背景颜色
    datePicker.backgroundColor = [UIColor clearColor];
    //datePicker.center = self.center;
    //设置本地化支持的语言（在此是中文)
//    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:[kMTFYMultiLanguageModule modCurLanguageSourcePathName]];
    
    NSDate *date = datePicker.date;
    datePicker.maximumDate = date;
    //显示方式是只显示年月日
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    [datePicker setDate:date animated:YES];
    //放在盖板上
    [self addSubview:datePicker];
}


-(void)windowframe
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    viewPandle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KWindowWidth, KWindowHeight)];
    
    viewPandle.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    viewPandle.alpha = 0.3;
    [viewPandle addTarget:self action:@selector(clickcancle) forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:viewPandle];
    
    self.frame = CGRectMake(0, KWindowHeight-240, KWindowWidth, 240);
    
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 1.0;
    
    [viewPandle addSubview:self];
    
}

-(void)twoButton
{
    viewbottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWindowWidth, 40)];
    viewbottom.backgroundColor = RGBCOLOR(245, 245, 245);
    //viewbottom.backgroundColor = [UIColor greenColor];
    [self addSubview:viewbottom];
    
    buttonCancle = [[UIButton alloc]initWithFrame:CGRectMake(16,2, 80, 36)];
    buttonCancle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [buttonCancle setTitle:kLStr(@"common_alert_cancel") forState:UIControlStateNormal];
    //buttonCancle.backgroundColor = [UIColor brownColor];
    buttonCancle.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonCancle setTitleColor:TitleBtnCOLOR forState:UIControlStateNormal];
    [buttonCancle addTarget:self action:@selector(clickcancle) forControlEvents:UIControlEventTouchUpInside];
    [viewbottom addSubview: buttonCancle];
    
    buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(KWindowWidth-100,2, 80, 36)];
    buttonSure.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    buttonSure.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonSure setTitleColor:zhuBlueCOLOR forState:UIControlStateNormal];
    [buttonSure setTitle:kLStr(@"common_alert_sure") forState:UIControlStateNormal];
    //buttonSure.backgroundColor = [UIColor whiteColor];
    [buttonSure addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    [viewbottom addSubview: buttonSure];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KWindowWidth/2-75, 2, 150, 36)];
    label.text = kLStr(@"common_date_select");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self addSubview:label];
    
}

-(void)clickcancle
{
    [viewPandle removeFromSuperview];
}

-(void)clickSure
{
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    string3 = [[NSString alloc]init];
    string3 = [dateFormatter stringFromDate:date];
    
    [self clickcancle];
    myBlock(string3);
}

-(void)passvalue:(PassValue)block
{
    
    myBlock = block;
}

@end

