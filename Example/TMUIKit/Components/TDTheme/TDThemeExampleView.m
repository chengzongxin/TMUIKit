//
//  TDThemeExampleView.m
//  tmuidemo
//
//  Created by MoLice on 2019/J/27.
//  Copyright © 2019 TMUI Team. All rights reserved.
//

#import "TDThemeExampleView.h"
#import "TDThemeManager.h"

@interface TDThemeExampleView ()

@property(nonatomic, assign) CGFloat itemInnerSpacing;
@property(nonatomic, assign) CGFloat itemMarginBottom;
@property(nonatomic, assign) CGFloat barHeight;// bar 高度会受到 safeAreaInsets 的影响，所以搞个固定的高度

@property(nonatomic, strong) UILabel *viewLabel;
@property(nonatomic, strong) UIView *view;

@property(nonatomic, strong) UILabel *textFieldLabel;
@property(nonatomic, strong) UITextField *textField;

@property(nonatomic, strong) UILabel *labelLabel;
@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) UILabel *textViewLabel;
@property(nonatomic, strong) UITextView *textView;

@property(nonatomic, strong) UILabel *sliderLabel;
@property(nonatomic, strong) UISlider *slider;

@property(nonatomic, strong) UILabel *switchLabel;
@property(nonatomic, strong) UISwitch *switchControlOn;
@property(nonatomic, strong) UISwitch *switchControlOff;

@property(nonatomic, strong) UILabel *imageViewLabel;
@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIProgressView *progressView;

@property(nonatomic, strong) UILabel *visualEffectLabel;
@property(nonatomic, strong) UIVisualEffectView *visualEffectView;
@property(nonatomic, strong) UIImageView *visualEffectBackendImageView;

@property(nonatomic, strong) UILabel *navigationBarLabel;
@property(nonatomic, strong) UINavigationBar *navigationBar;

@property(nonatomic, strong) UILabel *tabBarLabel;
@property(nonatomic, strong) UITabBar *tabBar;

@property(nonatomic, strong) UILabel *toolbarLabel;
@property(nonatomic, strong) UIToolbar *toolbar;

@property(nonatomic, strong) UILabel *searchBarLabel;
@property(nonatomic, strong) UISearchBar *searchBar;

@end

@implementation TDThemeExampleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.itemInnerSpacing = 8;
        self.itemMarginBottom = 32;
        self.barHeight = 44;
        
        UIFont *font = UIFontMake(14);
        UIFont *codeFont = CodeFontMake(font.pointSize);
        UIColor *textColor = UIColor.td_descriptionTextColor;
        
        self.viewLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.viewLabel.text = @"UIView";
        [self.viewLabel sizeToFit];
        [self addSubview:self.viewLabel];
        
        self.view = [[UIView alloc] tmui_initWithSize:CGSizeMake(100, 40)];
        self.view.tmui_borderWidth = 3;
        self.view.tmui_borderPosition = TMUIViewBorderPositionTop|TMUIViewBorderPositionLeft|TMUIViewBorderPositionBottom|TMUIViewBorderPositionRight;
        self.view.tmui_borderColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return [theme.themeTintColor colorWithAlphaComponent:.5];
        }];
        self.view.backgroundColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return [theme.themeTintColor colorWithAlphaComponent:.5];
        }];
        [self addSubview:self.view];
        
        self.textFieldLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.textFieldLabel.text = @"UITextField";
        [self.textFieldLabel sizeToFit];
        [self addSubview:self.textFieldLabel];
        
        self.textField = [[UITextField alloc] tmui_initWithSize:self.view.frame.size];
        self.textField.backgroundColor = self.view.backgroundColor;
        self.textField.tintColor = UIColor.td_tintColor;
        self.textField.defaultTextAttributes = @{NSFontAttributeName: UIFontMake(14),
                                                 NSForegroundColorAttributeName: UIColor.td_tintColor};
        self.textField.text = @" example text";
        [self addSubview:self.textField];
        
        self.labelLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.labelLabel.text = @"UILabel";
        [self.labelLabel sizeToFit];
        [self addSubview:self.labelLabel];
        
        self.label = [[UILabel alloc] init];
        self.label.attributedText = ({
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"example text..." attributes:@{NSFontAttributeName: UIFontMake(16),
                                                                                                                                  NSForegroundColorAttributeName: UIColor.td_mainTextColor
                                                                                                                                  }];
            [string addAttribute:NSForegroundColorAttributeName value:UIColor.td_tintColor range:NSMakeRange(0, @"example".length)];
            string.copy;
        });
        self.label.shadowColor = [UIColor tmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return [([identifier isEqualToString:TDThemeIdentifierDark] ? UIColorWhite : UIColorBlack) colorWithAlphaComponent:.5];
        }];
        self.label.shadowOffset = CGSizeMake(1, 1);
        [self.label sizeToFit];
        [self addSubview:self.label];
        
        self.textViewLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.textViewLabel.text = @"UITextView";
        [self.textViewLabel sizeToFit];
        [self addSubview:self.textViewLabel];
        
        self.textView = [[UITextView alloc] tmui_initWithSize:self.textField.frame.size];
        self.textView.backgroundColor = self.view.backgroundColor;
        self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(14),
                                           NSForegroundColorAttributeName: UIColor.td_tintColor};
        self.textView.text = @"example text";
        [self addSubview:self.textView];
        
        self.sliderLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.sliderLabel.text = @"UISlider";
        [self.sliderLabel sizeToFit];
        [self addSubview:self.sliderLabel];
        
        self.slider = [[UISlider alloc] init];
        self.slider.minimumTrackTintColor = UIColor.td_tintColor;
        self.slider.maximumTrackTintColor = UIColor.td_separatorColor;
        self.slider.thumbTintColor = self.slider.minimumTrackTintColor;
        self.slider.value = .3;
        [self.slider sizeToFit];
        [self addSubview:self.slider];
        
        self.switchLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.switchLabel.text = @"UISwitch";
        [self.switchLabel sizeToFit];
        [self addSubview:self.switchLabel];
        
        self.switchControlOn = [[UISwitch alloc] init];
        self.switchControlOn.on = YES;
        [self.switchControlOn sizeToFit];
        self.switchControlOn.onTintColor = UIColor.td_tintColor;
        self.switchControlOn.tintColor = self.switchControlOn.onTintColor;
        [self addSubview:self.switchControlOn];
        
        self.switchControlOff = [[UISwitch alloc] init];
        [self.switchControlOff sizeToFit];
        self.switchControlOff.onTintColor = self.switchControlOn.onTintColor;
        self.switchControlOff.tintColor = self.switchControlOff.onTintColor;
        [self addSubview:self.switchControlOff];
        
        self.imageViewLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.imageViewLabel.text = @"UIImage";
        [self.imageViewLabel sizeToFit];
        [self addSubview:self.imageViewLabel];
        
        UIImage *image = [UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<TDThemeProtocol> * _Nullable theme) {
            return [UIImageMake(@"icon_grid_assetsManager") tmui_imageWithTintColor:theme.themeTintColor];
        }];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.imageView];
        
        self.progressLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.progressLabel.text = @"UIProgressView";
        [self.progressLabel sizeToFit];
        [self addSubview:self.progressLabel];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.progressTintColor = UIColor.td_tintColor;
        self.progressView.trackTintColor = UIColor.td_separatorColor;
        self.progressView.progress = .3;
        [self addSubview:self.progressView];
        
        self.visualEffectLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.visualEffectLabel.text = @"UIVisualEffectView";
        [self.visualEffectLabel sizeToFit];
        [self addSubview:self.visualEffectLabel];
        
        self.visualEffectBackendImageView = [[UIImageView alloc] initWithImage:[UIImage tmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof TMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<TDThemeProtocol> * _Nullable theme) {
            return [UIImageMake(@"icon_grid_pieProgressView") tmui_imageWithTintColor:theme.themeTintColor];
        }]];
        [self addSubview:self.visualEffectBackendImageView];
        
        self.visualEffectView = [[UIVisualEffectView alloc] init];
        self.visualEffectView.effect = UIVisualEffect.td_standardBlurEffect;
        [self addSubview:self.visualEffectView];
        
        self.navigationBarLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.navigationBarLabel.text = @"UINavigationBar";
        [self.navigationBarLabel sizeToFit];
        [self addSubview:self.navigationBarLabel];
        
        self.navigationBar = [[UINavigationBar alloc] init];
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.barTintColor = UIColor.td_tintColor;
        [self addSubview:self.navigationBar];
        
        self.tabBarLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.tabBarLabel.text = @"UITabBar";
        [self.tabBarLabel sizeToFit];
        [self addSubview:self.tabBarLabel];
        
        self.tabBar = [[UITabBar alloc] init];
        self.tabBar.backgroundImage = nil;
        self.tabBar.barTintColor = UIColor.td_tintColor;
        [self addSubview:self.tabBar];
        
        self.toolbarLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.toolbarLabel.text = @"UIToolbar";
        [self.toolbarLabel sizeToFit];
        [self addSubview:self.toolbarLabel];
        
        self.toolbar = [[UIToolbar alloc] init];
        [self.toolbar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.toolbar.barTintColor = UIColor.td_tintColor;
        [self addSubview:self.toolbar];
        
        self.searchBarLabel = [[UILabel alloc] tmui_initWithFont:codeFont textColor:textColor];
        self.searchBarLabel.text = @"UISearchBar";
        [self.searchBarLabel sizeToFit];
        [self addSubview:self.searchBarLabel];
        
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.barTintColor = UIColor.td_tintColor;
        self.searchBar.tintColor = UIColor.td_tintColor;
        [self.searchBar sizeToFit];
        [self addSubview:self.searchBar];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat height = self.viewLabel.tmui_height + self.itemInnerSpacing + self.view.tmui_height + self.itemMarginBottom;
    height += self.labelLabel.tmui_height + self.itemInnerSpacing + self.label.tmui_height + self.itemMarginBottom;
    height += self.sliderLabel.tmui_height + self.itemInnerSpacing + self.slider.tmui_height + self.itemMarginBottom;
    height += self.switchLabel.tmui_height + self.itemInnerSpacing + self.switchControlOn.tmui_height + self.itemMarginBottom;
    height += self.progressLabel.tmui_height + self.itemInnerSpacing + self.progressView.tmui_height + self.itemMarginBottom;
    height += self.visualEffectLabel.tmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.navigationBarLabel.tmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.tabBarLabel.tmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.toolbarLabel.tmui_height + self.itemInnerSpacing + self.barHeight + self.itemMarginBottom;
    height += self.searchBarLabel.tmui_height + self.itemInnerSpacing + self.searchBar.tmui_height + self.itemMarginBottom;
    size.height = height;
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.view.tmui_top = self.viewLabel.tmui_bottom + self.itemInnerSpacing;
    
    self.textField.tmui_top = self.view.tmui_top;
    self.textField.tmui_right = self.tmui_width;
    self.textFieldLabel.tmui_left = self.textField.tmui_left;
    
    self.labelLabel.tmui_top = self.view.tmui_bottom + self.itemMarginBottom;
    self.label.tmui_top = self.labelLabel.tmui_bottom + self.itemInnerSpacing;
    
    self.textView.tmui_top = self.label.tmui_top;
    self.textView.tmui_right = self.tmui_width;
    self.textViewLabel.tmui_left = self.textView.tmui_left;
    self.textViewLabel.tmui_top = self.labelLabel.tmui_top;
    
    self.sliderLabel.tmui_top = self.label.tmui_bottom + self.itemMarginBottom;
    self.slider.tmui_top = self.sliderLabel.tmui_bottom + self.itemInnerSpacing;
    self.slider.tmui_width = self.tmui_width * 2 / 3;
    
    self.switchLabel.tmui_top = self.slider.tmui_bottom + self.itemMarginBottom;
    self.switchControlOn.tmui_top = self.switchLabel.tmui_bottom + self.itemInnerSpacing;
    self.switchControlOff.tmui_top = self.switchControlOn.tmui_top;
    self.switchControlOff.tmui_left = self.switchControlOn.tmui_right + 36;
    
    self.imageViewLabel.tmui_left = self.textViewLabel.tmui_left;
    self.imageViewLabel.tmui_top = self.switchLabel.tmui_top;
    self.imageView.tmui_top = self.imageViewLabel.tmui_bottom + self.itemInnerSpacing;
    self.imageView.tmui_left = self.imageViewLabel.tmui_left;
    
    self.progressLabel.tmui_top = self.switchControlOn.tmui_bottom + self.itemMarginBottom;
    self.progressView.tmui_top = self.progressLabel.tmui_bottom + self.itemInnerSpacing;
    
    self.visualEffectLabel.tmui_top = self.progressView.tmui_bottom + self.itemMarginBottom;
    self.visualEffectView.tmui_top = self.visualEffectLabel.tmui_bottom + self.itemInnerSpacing;
    self.visualEffectView.tmui_width = self.tmui_width;
    self.visualEffectView.tmui_height = self.barHeight;
    self.visualEffectBackendImageView.center = self.visualEffectView.center;
    
    self.navigationBarLabel.tmui_top = self.visualEffectView.tmui_bottom + self.itemMarginBottom;
    self.navigationBar.tmui_top = self.navigationBarLabel.tmui_bottom + self.itemInnerSpacing;
    self.navigationBar.tmui_width = self.tmui_width;
    self.navigationBar.tmui_height = self.barHeight;
    
    self.tabBarLabel.tmui_top = self.navigationBar.tmui_bottom + self.itemMarginBottom;
    self.tabBar.tmui_top = self.tabBarLabel.tmui_bottom + self.itemInnerSpacing;
    self.tabBar.tmui_width = self.tmui_width;
    self.tabBar.tmui_height = self.barHeight;
    
    self.toolbarLabel.tmui_top = self.tabBar.tmui_bottom + self.itemMarginBottom;
    self.toolbar.tmui_top = self.toolbarLabel.tmui_bottom + self.itemInnerSpacing;
    self.toolbar.tmui_width = self.tmui_width;
    self.toolbar.tmui_height = self.barHeight;
    
    self.searchBarLabel.tmui_top = self.toolbar.tmui_bottom + self.itemMarginBottom;
    self.searchBar.tmui_top = self.searchBarLabel.tmui_bottom + self.itemInnerSpacing;
    self.searchBar.tmui_width = self.tmui_width;
}

@end
