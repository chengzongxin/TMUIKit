//
//  ChainStyleConfigViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/25.
//  Copyright © 2021 chengzongxin. All rights reserved.
//



@interface CUIStyle (private)

@property (nonatomic, strong) NSMutableArray *chainableProperties;


@end

#import "ChainStyleConfigViewController.h"


typedef ChainStyleConfigViewController *(^bgblock)(UIColor *color);
typedef void (^bgblock2)(UIColor *color);

@interface ChainStyleConfigViewController ()

@property (nonatomic, strong) UILabel *h11;
@property (nonatomic, strong) UILabel *h22;
@property (nonatomic, strong) UILabel *h33;
@property (nonatomic, strong) UILabel *body1;
@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *b1;
@property (nonatomic, strong) UIButton *b2;
@property (nonatomic, strong) UIButton *b3;
@property (nonatomic, strong) UIButton *b4;
@property (nonatomic, strong) UIButton *b5;

@property (nonatomic, strong) UILabel *styleColor;
@property (nonatomic, strong) UILabel *styleFont;
@property (nonatomic, strong) UIView *styleCV;
@property (nonatomic, strong) UILabel * styleLf;


@property (nonatomic, strong) UILabel *rl;
@property (nonatomic, strong) TMUISlider *rs;
@property (nonatomic, strong) UILabel *gl;
@property (nonatomic, strong) TMUISlider *gs;
@property (nonatomic, strong) UILabel *bl;
@property (nonatomic, strong) TMUISlider *bs;
@property (nonatomic, strong) UILabel *fl;
@property (nonatomic, strong) TMUISlider *fs;

@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) CUIStyle *selectedStyle;
@property (nonatomic, assign) BOOL isSemibold;


@property (nonatomic, assign) BOOL isSliderByUser;

@property (nonatomic, strong) bgblock bgcolor1;
@property (nonatomic, strong) bgblock2 bgcolor2;

@property(nonatomic, copy) void (^hahaha)(void);
@end

@implementation ChainStyleConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.bgColor(@"white");
    
    id l1 = Label.str(@"样式显示效果：").styles(body);
    
    _h11 = Label.str(@"H1标题").styles(h1);
    
    _h22 = Label.str(@"H2标题").styles(h2);
    
    _h33 = Label.str(@"H3标题").styles(h3);
    
    _body1 = Label.str(@"body正文").styles(body);
    
    _button1 = Button.str(@"button按钮").styles(button).fixWH(300,44);
    
    id l2 = Label.str(@"设置样式：").styles(body);
    
    id b1 = Button.str(@"设置H1样式").styles(button).onClick(^{
        _selectedButton = _b1;
        [self setStyle:TMUIExampleConfiguration.sharedInstance.h1];
    });
    
    id b2 = Button.str(@"设置H2样式").styles(button).onClick(^{
        _selectedButton = _b2;
        [self setStyle:TMUIExampleConfiguration.sharedInstance.h2];
    });
    
    id b3 = Button.str(@"设置H3样式").styles(button).onClick(^{
        _selectedButton = _b3;
        [self setStyle:TMUIExampleConfiguration.sharedInstance.h3];
    });
    
    id b4 = Button.str(@"设置body样式").styles(button).onClick(^{
        _selectedButton = _b4;
        [self setStyle:TMUIExampleConfiguration.sharedInstance.body];
    });
    
    id b5 = Button.str(@"设置button样式").styles(button).onClick(^{
        _selectedButton = _b5;
        [self setStyle:TMUIExampleConfiguration.sharedInstance.button];
    });
    
    id l3 = Label.str(@"设置颜色：").styles(body);
    
    id rl = Label.str(@"red").styles(body).fixWidth(88);
    TMUISlider *rs = (TMUISlider *)[[TMUISlider alloc] init].fixWidth(250);
    [rs addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    rs.minimumValue = 0;
    rs.maximumValue = 255.0;
    
    id gl = Label.str(@"green").styles(body).fixWidth(88);
    TMUISlider *gs = (TMUISlider *)[[TMUISlider alloc] init].fixWidth(250);
    [gs addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    gs.minimumValue = 0;
    gs.maximumValue = 255.0;
    
    id bl = Label.str(@"blue").styles(body).fixWidth(88);
    TMUISlider *bs = (TMUISlider *)[[TMUISlider alloc] init].fixWidth(250);
    [bs addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    bs.minimumValue = 0;
    bs.maximumValue = 255.0;
    
    id l4 = Label.str(@"设置字体：").styles(body);
    
    id fl = Label.str(@"Font").styles(body).fixWidth(88);
    TMUISlider *fs = (TMUISlider *)[[TMUISlider alloc] init].fixWidth(250);
    [fs addTarget:self action:@selector(slide:) forControlEvents:UIControlEventValueChanged];
    fs.minimumValue = 0;
    fs.maximumValue = 30;
    
    id l5 = Label.str(@"设置结果展示：").styles(body);
    
    id styleColor = Label.styles(body);
    id styleCV = View.fixWH(50,50).borderRadius(25);
    
    id styleFont = Label.styles(body);
    id styleLf = Label;
    
    UIScrollView *scroll = UIScrollView.new;
    scroll.embedIn(self.view);
    VerStack(l1,
             _h11,
             _h22,
             _h33,
             _body1,
             _button1,
             @20,
             l2,
             HorStack(b1,b2,b3).gap(20),
             HorStack(b4,b5).gap(20),
             @20,
             l3,
             HorStack(rl,rs),
             HorStack(gl,gs),
             HorStack(bl,bs),
             @20,
             l4,
             HorStack(fl,fs),
             @20,
             l5,
             HorStack(styleColor,styleCV).gap(44),
             HorStack(styleFont,styleLf).gap(44),
             )
    .embedIn(scroll,20)
    .gap(15);
    
    _b1 = b1;
    _b2 = b2;
    _b3 = b3;
    _b4 = b4;
    _b5 = b5;
    
    _styleColor = styleColor;
    _styleCV = styleCV;
    _styleFont = styleFont;
    _styleLf = styleLf;
    
    
    _rl = rl;
    _gl = gl;
    _bl = bl;
    _fl = fl;
    
    _rs = rs;
    _gs = gs;
    _bs = bs;
    _fs = fs;
}


//    _h1 = Style(h1).fnt(@16).color(@"black").lineGap(10).multiline;
//    _h2 = Style(h2).fnt(@12).color(@"black").lineGap(10).multiline;
//    _h3 = Style(h3).fnt(12).color(@"black").lineGap(10).multiline;
//    _body = Style(body).fnt(12).color(Color(@"93,100,110")).lineGap(15).multiline;
//    _button = Style(button).bgColor(@"#178BFB").fnt(@15).color(@"white").borderRadius(4);


- (void)setStyle:(CUIStyle *)style{
    _selectedStyle = style;
    Log(style.chainableProperties);
    
    UIFont *fnt;
    UIColor *color;
    CGFloat lineGap;
    NSString *fntKey = @"fnt";
    NSString *colorKey = @"color";
    NSString *lineGapKey = @"lineGap";
    for (NSDictionary *dict in style.chainableProperties) {
        
        if ([dict[@"key"] isEqualToString:fntKey]) {
            fnt = Fnt(dict[@"value"]);
        }
        
        if ([dict[@"key"] isEqualToString:colorKey]) {
            color = Color(dict[@"value"]);
        }
        
        if ([dict[@"key"] isEqualToString:lineGapKey]) {
            lineGap = [dict[@"value"] doubleValue];
        }
    }
    
    CGFloat r = [color tmui_red]*255.0;
    CGFloat g = [color tmui_green]*255.0;
    CGFloat b = [color tmui_blue]*255.0;
    CGFloat a = [color tmui_alpha];
    
    // slider
    _rs.value = r;
    _gs.value = g;
    _bs.value = b;
    _fs.value = fnt.pointSize;
    
    _rl.str(@"red:%0.f",r);
    _gl.str(@"green:%0.f",g);
    _bl.str(@"blue:%0.f",b);
    _fl.str(@"Font:%0.f",fnt.pointSize);
    
    // hint
    
    _styleColor.str(_selectedButton.currentTitle.a(@"颜色 RGBA:(%0.f,%0.f,%0.f,%0.1f)",r,g,b,a));
    _styleCV.bgColor(color);
    _styleFont.str(_selectedButton.currentTitle.a(@"字体"));
    NSString *txt = Str(@"%0.f%@",fnt.pointSize,fnt.fontName);
    _styleLf.str(txt).fnt(fnt);
    
    _isSemibold = [fnt.fontName containsString:@"Semibold"];
}

- (void)slide:(TMUISlider *)slider{
//    _selectedStyle.chainableProperties;
    
    
    ChainStyleConfigViewController *vc = ChainStyleConfigViewController.new;
    vc.view.backgroundColor = UIColor.whiteColor;
    vc.hahaha = ^{
        Log(@"gggg");
    };
    
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:vc.bgcolor1];
    [array addObject:vc.bgcolor2];
    
//    vc = nil;
    vc.view.backgroundColor = UIColor.redColor;
//    vc.hahaha;
    [vc bgcolor1](UIColor.whiteColor);
    NSLog(@"%@",vc.bgcolor1(UIColor.whiteColor));
    vc.bgcolor2(UIColor.whiteColor);
    
    
    
    
    
//    [(NSString *)vc length];
    
//    vc.bgcolor2(UIColor.whiteColor);
//
//    vc.bgcolor1(UIColor.redColor);
    Log(vc.bgcolor1);
    Log(vc.bgcolor2);
    
    
    if (vc.bgcolor2) {
        vc.bgcolor2(UIColor.whiteColor);
    }
    
    if (vc.bgcolor1) {
        vc.bgcolor1(UIColor.whiteColor);
    }
    
    
    
    UILabel *lbl = Label.str(@"dddd");
    lbl = nil;
    
//    NSLog(@"%@",lbl.text);
//
//    NSLog(@"%@",lbl.textColor);
    
//    lbl.bgColor;
//    lbl.str(@"111");
//    lbl.bgColor(@"white");
    if (_selectedStyle == nil) {
        return;
    }
    
    
    NSString *colorStr = Str(@"%0.f,%0.f,%0.f,1",_rs.value,_gs.value,_bs.value);
    Log(colorStr);
    UIColor *color = Color(colorStr);
    _selectedStyle.color(color);
    
    int pointSize = (int)_fs.value;
    UIFont *font = _isSemibold ? Fnt(@(pointSize)) : Fnt(pointSize);
    _selectedStyle.fnt(font);
    
    _styleCV.bgColor(color);
    NSString *txt = Str(@"%0.f%@",font.pointSize,font.fontName);
    _styleLf.str(txt).fnt(font);
    
    _h11.styles(h1);
    _h22.styles(h2);
    _h33.styles(h3);
    _body1.styles(body);
    _button1.styles(button);
}



- (bgblock)bgcolor1{
    return ^(UIColor *color){
        self.view.backgroundColor = color;
        Log(color);
        
        
        return self;
    };
}

- (bgblock2)bgcolor2{
    return ^(UIColor *color){
        self.view.backgroundColor = color;
        Log(color);
    };
}

@end
