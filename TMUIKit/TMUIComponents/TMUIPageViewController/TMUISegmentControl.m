//
//  TMUISegmentControl.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/7/20.
//

#import "TMUISegmentControl.h"
#import <TMUIExtensions/TMUIExtensions.h>
#import <TMUICore/TMUICore.h>
//#import <GECommonEventTracker.h>

@interface TMUISegmentControl ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView      *scrollView;//add by amby.qin。把按钮放到scrollView中，超出范围时，支持左右滑动
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleBtns;
@property (nonatomic, copy) NSArray *titles;
/**
 记录上一次被选中的按钮
 */
@property (nonatomic, strong)   UIButton          *lastSelectedButton;

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIColor *> *titleColorAttributes;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIFont  *> *titleFontAttributes;

@property (nonatomic, strong) void(^animationBlock)(UIView *indicator, CGRect targetFrame);

@property (nonatomic, assign)   NSInteger exposeButtonIndex;//最后一次曝光的button序号
@property (nonatomic, assign)   CGFloat exposeButtonWidth;//曝光的按钮总长度

@end

@implementation TMUISegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = NO;
        
        [self addSubview:self.scrollView];
        self.scrollView.frame = self.bounds;
    }
    return self;
    
    return [self initWithFrame:frame titles:@[]];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {

    if (self = [self initWithFrame:frame]) {
        [self setSegmentTitles:titles];
    }
    return self;
}

- (void)setSegmentTitles:(NSArray *)segmentTitles {

    self.titles = segmentTitles;
    [self setupDefaultTransitionAnimation];
    [self loadButtonsWithTitles];
}

// 默认indicator过渡动画
- (void)setupDefaultTransitionAnimation {
    [self setTransitionAnimation:^(UIView *indicator, CGRect targetFrame) {
        [UIView animateWithDuration:0.08 animations:^{
            indicator.frame = CGRectMake(MIN(indicator.left, targetFrame.origin.x),
                                         targetFrame.origin.y,
                                         fabs(indicator.left-targetFrame.origin.x)+targetFrame.size.width,
                                         targetFrame.size.height);
        } completion:nil];
        [UIView animateWithDuration:0.15 delay:0.075 options:UIViewAnimationOptionCurveEaseOut animations:^{
            indicator.frame = targetFrame;
        } completion:nil];
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
}

- (void)setFrame:(CGRect)frame
{
    BOOL refresh = NO;
    if (frame.size.height != self.height || frame.size.width != self.width) {
        refresh = YES;
    }
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
    if (refresh) {
        [self loadButtonsWithTitles];
    }
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    [self setFrame:rect];
}

- (void)setContentLeftMargin:(CGFloat)contentLeftMargin {
    BOOL refresh = (contentLeftMargin != _contentLeftMargin);
    _contentLeftMargin = contentLeftMargin;
    if (refresh) {
        [self loadButtonsWithTitles];
    }
}

- (void)loadButtonsWithTitles
{
    [self.scrollView tmui_removeAllSubviews];
    if (self.titles == nil || self.titles.count == 0) {
        return;
    }
    self.titleBtns = [NSMutableArray arrayWithCapacity:self.titles.count];
    CGFloat btnH = self.height;
    self.indicatorView.y = btnH - 4;
    [self.scrollView addSubview:self.indicatorView];
    
    __block CGFloat totalWidth = self.contentLeftMargin;
    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self createButtonWithObject:obj index:idx offsetX:totalWidth];
        if (button) {
            [self.scrollView addSubview:button];
            [self.titleBtns tmui_safeAddObject:button];
            
            if (totalWidth + button.width <= self.width) {//曝光
                if (self.itemExposeBlock) {
                    self.itemExposeBlock(button,idx);
                }
                self.exposeButtonIndex = idx;
                self.exposeButtonWidth = totalWidth + button.width;
            }
            totalWidth += button.width;
            
            button.tag = BUTTON_START_INDEX + idx;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (idx == self.selectedIndex) {
                button.selected = YES;
                self.lastSelectedButton = button;
                if (_animationBlock) {
                    CGRect frame = [self getButtonRect:button index:idx];
                    _animationBlock(self.indicatorView, frame);
                } else {
                    [self setIndicatorViewCenterXBasedOnView:button];
                }
                
                //[self.scrollView bringSubviewToFront:self.indicatorView];
            } else {
                button.selected = NO;
            }
        }
    }];
    
    //如果所有按钮宽度小于容器宽度，则把多余的宽度均分给所有按钮，保证按钮居中显示
    if (self.autoAlignmentCenter && totalWidth < self.width) {
        CGFloat perExtra = (self.width - totalWidth) / self.titles.count;
        [self.titleBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(obj.origin.x + perExtra * idx, obj.origin.y, obj.size.width + perExtra, obj.size.height);
        }];
        totalWidth = self.width;
    }
    self.scrollView.contentSize = CGSizeMake(totalWidth, 0);
    
    [self setScale:self.scale];
    
    [self.scrollView bringSubviewToFront:self.indicatorView];
}

- (UIButton *)createButtonWithObject:(NSString *)title index:(NSInteger)index offsetX:(CGFloat)offsetX {
    if (![title isKindOfClass:[NSString class]]) {
        return nil;
    }
    UIFont *selectedFont = self.titleFontAttributes[@(UIControlStateSelected)];
    CGFloat textWidth = [title boundingRectWithSize:CGSizeMake(FLT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:selectedFont} context:nil].size.width + 20;
    CGFloat tempWidth = MAX(textWidth,self.minItemWidth);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, tempWidth, self.height)];
    button.titleLabel.font =  self.titleFontAttributes[@(UIControlStateNormal)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.titleColorAttributes[@(UIControlStateNormal)] forState:UIControlStateNormal];
    [button setTitleColor:self.titleColorAttributes[@(UIControlStateSelected)] forState:UIControlStateSelected];
    if (index == self.selectedIndex) {
        button.titleLabel.font =  selectedFont;
    }
    
    return button;
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    if (_selectedBackgroundColor != selectedBackgroundColor) {
        _selectedBackgroundColor = selectedBackgroundColor;
        UIButton * btn = [self segmentButtonAtIndex:self.selectedIndex];
        btn.backgroundColor = selectedBackgroundColor;
    }
}

- (void)buttonAction:(UIButton *)btn
{
    if ([_lastSelectedButton isEqual:btn]) {
        if (self.repeatClickItemBlock) {
            self.repeatClickItemBlock(self.selectedIndex);
        }
        return;
    }
    
    [self changeValueToIndex:btn.tag - BUTTON_START_INDEX animated:YES];
    if (self.itemClickBlock) {//这个一定要放在后面，否则self.selectedIndex的值会不对
        self.itemClickBlock(btn, self.selectedIndex);
    }
}

- (void)changeValueToIndex:(NSInteger)index animated:(BOOL)animated {
    [self setSelectedIndex:index animated:animated];
    !_blockValueChanged ?: _blockValueChanged(self.selectedIndex);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    if (selectedIndex == _lastSelectedButton.tag - BUTTON_START_INDEX) {
        return;
    }
    if (selectedIndex < 0) {
        _selectedIndex = selectedIndex;
        return;
    }
    
    UIButton *btn = [self viewWithTag:selectedIndex + BUTTON_START_INDEX];
    if (_animationBlock) {
        CGRect frame = [self getButtonRect:btn index:selectedIndex];
        _animationBlock(self.indicatorView, frame);
    } else {
        CGFloat duration = animated ? 0.25 : 0.0;
        [UIView animateWithDuration:duration animations:^{
            [self setIndicatorViewCenterXBasedOnView:btn];
        }];
    }
    self.lastSelectedButton.backgroundColor = nil;
    self.lastSelectedButton.selected = NO;
    btn.selected = YES;
    btn.backgroundColor = self.selectedBackgroundColor;
    self.lastSelectedButton.titleLabel.font = self.titleFontAttributes[@(UIControlStateNormal)];
    btn.titleLabel.font = self.titleFontAttributes[@(UIControlStateSelected)];
    [self scaleFontForSelectedButton:btn normalButton:self.lastSelectedButton];
    self.lastSelectedButton = btn;
    _selectedIndex = selectedIndex;
    [self scrollToolBar];
}

- (CGRect)getButtonRect:(UIButton *)button index:(NSInteger)index {
//    CGRect rect = [self convertRect:button.frame toView:self];
    return CGRectMake(button.centerX - self.indicatorView.width / 2, self.indicatorView.top, self.indicatorView.width, self.indicatorView.height);
}

/**
 如果要滑向的目标button为不可见，则需要滚动scrollview到目标button的位置
 */
- (void)scrollToolBar {
    
    CGFloat insetX = self.scrollView.contentInset.left + self.scrollView.contentInset.right;
    CGFloat cWidth = self.scrollView.width - insetX;
    if (self.scrollView.contentSize.width > cWidth) { //只有指定了按钮宽度才可能存在滑动

        CGFloat preWidth = 0;
        for (NSInteger i = 0; i < self.selectedIndex; i++) {
            UIButton *tempButton = [self.titleBtns tmui_safeObjectAtIndex:i];
            preWidth += tempButton.bounds.size.width;
        }
        
        UIButton *button = [self.titleBtns tmui_safeObjectAtIndex:self.selectedIndex];
        CGFloat centerX = self.scrollView.width / 2;
        CGFloat buttonAbsoluteCenterX = button.x + button.width  / 2;//按钮的绝对位置，在scrollView中的实际位置
        CGFloat buttonRelativeCenterX = buttonAbsoluteCenterX - self.scrollView.contentOffset.x;//按钮的相对位置，相对于scrollView左边的距离
        if (buttonRelativeCenterX > centerX) {//从右往左滑动
            if (self.scrollView.contentSize.width - buttonAbsoluteCenterX < centerX - self.scrollView.contentInset.right) {//考虑右边右内边距的情况
                    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.width + self.scrollView.contentInset.right, 0) animated:YES];
            } else {
                    [self.scrollView setContentOffset:CGPointMake(buttonAbsoluteCenterX - centerX, 0) animated:YES];
            }
        } else {//从左往右滑动
            if (buttonAbsoluteCenterX < centerX - self.scrollView.contentInset.left) {//考虑左边有内边距的情况
                    [self.scrollView setContentOffset:CGPointMake(-self.scrollView.contentInset.left, 0) animated:YES];
            } else {
                    [self.scrollView setContentOffset:CGPointMake(buttonAbsoluteCenterX - centerX, 0) animated:YES];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.contentSize.width > self.scrollView.width) { //滑动曝光
        if (scrollView.contentOffset.x <= 0) {
            return;
        }
        
        CGFloat offsetX = scrollView.contentOffset.x + scrollView.width;
        CGFloat totalWidth = self.exposeButtonWidth;
        NSInteger i = self.exposeButtonIndex + 1;
        UIButton *button = [self.segmentButtons tmui_safeObjectAtIndex:i];
        if (button) {
            if (offsetX >= (totalWidth + button.width/2.f)) {
                if (self.itemExposeBlock) {
                    self.itemExposeBlock(button, i);
                }
                self.exposeButtonIndex = i;
                self.exposeButtonWidth = totalWidth + button.width;
            }
        }
    }
}

- (void)scaleFontForSelectedButton:(UIButton *)selectedButton normalButton:(UIButton *)normalButton {
    if (self.scale <= 0) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        selectedButton.transform = CGAffineTransformIdentity;
        normalButton.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    }];
}

- (void)setAutoAlignmentCenter:(BOOL)autoAlignmentCenter {
    if (autoAlignmentCenter == _autoAlignmentCenter) {
        return;
    }
    _autoAlignmentCenter = autoAlignmentCenter;
    CGFloat totalWidth = self.scrollView.contentSize.width;
    if (totalWidth == 0) {
        return;
    }
    if (_autoAlignmentCenter && totalWidth < self.width) { //如果所有按钮宽度小于容器宽度，则把多余的宽度均分给所有按钮，保证按钮居中显示
        CGFloat perExtra = (self.width - totalWidth) / self.titles.count;
        [self.titleBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(obj.origin.x + perExtra * idx, obj.origin.y, obj.size.width + perExtra, obj.size.height);
        }];
        totalWidth = self.width;
    }
    self.scrollView.contentSize = CGSizeMake(totalWidth, 0);
    [self setIndicatorViewCenterXBasedOnView:self.lastSelectedButton];
}

- (void)setIndicatorViewCenterXBasedOnView:(UIButton *)view {
    self.indicatorView.centerX = view.centerX;
}

- (void)setMinItemWidth:(CGFloat)minItemWidth {
    
    if (minItemWidth == _minItemWidth) {
        return;
    }
    
    _minItemWidth = minItemWidth;
    if (!self.titleBtns || self.titleBtns.count == 0) {
        return;
    }
    [self loadButtonsWithTitles];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (self.titleColorAttributes == nil) {
        return;
    }
    if (!color) {
        [self.titleColorAttributes removeObjectForKey:@(state)];
        return;
    }
    self.titleColorAttributes[@(state)] = color;
    [self.titleBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:color forState:state];
    }];
}

- (void)setTitleFont:(UIFont *)font forState:(UIControlState)state
{
    if (self.titleFontAttributes == nil) {
        return;
    }
    if (!font) {
        [self.titleFontAttributes removeObjectForKey:@(state)];
        return;
    }
    self.titleFontAttributes[@(state)] = font;
    [self.titleBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (state == obj.state) {
            obj.titleLabel.font = font;
        }
    }];
    
    [self loadButtonsWithTitles];//字体发生变化后，按钮的宽度会发生变化，所以需要重新布局
}

- (NSMutableDictionary <NSNumber *, UIFont *> *)titleFontAttributes {
    if (_titleFontAttributes == nil || _titleFontAttributes.count == 0) {
        _titleFontAttributes = [@{@(UIControlStateNormal):[UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium], @(UIControlStateSelected):[UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium]} mutableCopy];
    }
    
    return _titleFontAttributes;
}

- (NSMutableDictionary <NSNumber *, UIColor *> *)titleColorAttributes {
    if (_titleColorAttributes == nil || _titleColorAttributes.count == 0) {
        _titleColorAttributes = [@{@(UIControlStateNormal):UIColorHexString(@"878B99"), @(UIControlStateSelected):UIColorHexString(@"111111")} mutableCopy];
    }
    return _titleColorAttributes;
}

- (void)setTransitionAnimation:(void(^)(UIView *indicator, CGRect targetFrame))amimation
{
    _animationBlock = amimation;
}

- (UIButton *)segmentButtonAtIndex:(NSInteger)index {
    if (index < 0) {
        return [self.titleBtns tmui_safeObjectAtIndex:self.selectedIndex];
    }
    return [self.titleBtns tmui_safeObjectAtIndex:index];
}

- (NSArray<UIButton *> *)segmentButtons {
    return self.titleBtns;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    if (scale <= 0) {
        return;
    }
    for (UIButton *button in self.titleBtns) {
        button.transform = CGAffineTransformIdentity;
        if (button == self.lastSelectedButton) {
            [self scaleFontForSelectedButton:self.lastSelectedButton normalButton:nil];
        } else {
            button.transform = CGAffineTransformMakeScale(self.scale, self.scale);
        }
    }
}

- (NSString *)titleForSelected {
    return self.titles[self.selectedIndex];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 4, 16, 4)];
        _indicatorView.backgroundColor = UIColorHexString(@"22C787");
        _indicatorView.layer.cornerRadius = 1.5;
        _indicatorView.layer.masksToBounds = YES;
    }
    return _indicatorView;
}

@end
