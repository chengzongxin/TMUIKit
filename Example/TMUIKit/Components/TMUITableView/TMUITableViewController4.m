//
//  TMUITableViewController2.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITableViewController4.h"



@interface TMUITableViewInsetDebugPanelView : UIView

- (void)renderWithTableView:(UITableView *)tableView;
@end


@interface TMUITableViewController4 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UISegmentedControl *segmentedTitleView;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) TMUITableViewInsetDebugPanelView *debugView;
@end

@implementation TMUITableViewController4

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    [self handleTableViewStyleChanged:0];
    
    self.debugView = [[TMUITableViewInsetDebugPanelView alloc] init];
    [self.view addSubview:self.debugView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets margins = UIEdgeInsetsZero;
    CGFloat debugViewWidth = fmin(self.view.width, [TMUIHelper screenSizeFor55Inch].width) - UIEdgeInsetsGetHorizontalValue(margins);
    CGFloat debugViewHeight = 126;
    CGFloat debugViewMinX = CGFloatGetCenter(self.view.width, debugViewWidth);
    self.debugView.frame = CGRectMake(debugViewMinX, self.view.height - margins.bottom - debugViewHeight, debugViewWidth, debugViewHeight);
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.debugView renderWithTableView:self.tableView];
}



#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    TMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString tmui_stringWithNSInteger:indexPath.row];
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section%@", @(section)];
}

- (UIView *)supertableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView realTitleForHeaderInSection:section];
    if (title) {
        TMUITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerViewID"];
        headerView.parentTableView = tableView;
        headerView.type = TMUITableViewHeaderFooterViewTypeHeader;
        headerView.titleLabel.text = title;
        return headerView;
    }
    return nil;
}

// 是否有定义某个section的header title
- (NSString *)tableView:(UITableView *)tableView realTitleForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        NSString *sectionTitle = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
        if (sectionTitle && sectionTitle.length > 0) {
            return sectionTitle;
        }
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TMUITableViewHeaderFooterView *headerView = (TMUITableViewHeaderFooterView *)[self supertableView:tableView viewForHeaderInSection:section];
    TMUIButton *button = (TMUIButton *)headerView.accessoryView;
    if (!button) {
        button = [self generateLightBorderedButton];
        [button setTitle:@"Button" forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(14);
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 12, 4, 12);
        [button sizeToFit];
//        button.tmui_automaticallyAdjustTouchHighlightedInScrollView = YES;
        button.tmui_outsideEdge = UIEdgeInsetsMake(-8, -8, -8, -8);
        [button addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        headerView.accessoryView = button;
    }
    return headerView;
}

- (void)handleButtonEvent:(UIView *)view {
    // 通过这个方法获取到点击的按钮所处的 sectionHeader，可兼容 sectionHeader 停靠在列表顶部的场景
    NSInteger sectionIndexForView = [self.tableView tmui_indexForSectionHeaderAtView:view];
    [TMToast toast:Str(@"点击了第%d个section",sectionIndexForView)];
}


- (void)setupNavigationItems {
//    [super setupNavigationItems];
    if (!self.segmentedTitleView) {
        self.segmentedTitleView = [[UISegmentedControl alloc] initWithItems:@[
            @"Plain",
            @"Grouped",
            @"InsetGrouped"
        ]];
        [self.segmentedTitleView addTarget:self action:@selector(handleTableViewStyleChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIColor *tintColor = self.navigationController.navigationBar.tintColor;
        if (@available(iOS 13.0, *)) {
            self.segmentedTitleView.selectedSegmentTintColor = tintColor;
        } else {
            self.segmentedTitleView.tintColor = tintColor;
        }
        [self.segmentedTitleView setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor} forState:UIControlStateNormal];
        [self.segmentedTitleView setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.tmui_randomColor} forState:UIControlStateSelected];
    }
    self.segmentedTitleView.selectedSegmentIndex = self.tableView.tmui_style;
    self.navigationItem.titleView = self.segmentedTitleView;
}

- (void)handleTableViewStyleChanged:(UISegmentedControl *)segmentedControl {
    [self.tableView removeFromSuperview];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:segmentedControl.selectedSegmentIndex];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColor.tmui_randomColor;
    [self.tableView registerClass:TMUITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"headerViewID"];
    [self.view addSubview:self.tableView];
}

- (TMUIButton *)generateLightBorderedButton {
    TMUIButton *button = [[TMUIButton alloc] tmui_initWithSize:CGSizeMake(200, 40)];
    button.titleLabel.font = UIFontBoldMake(14);
    button.tintColorAdjustsTitleAndImage = UIColor.tmui_randomColor;
    button.backgroundColor = [UIColor.tmui_randomColor tmui_transitionToColor:UIColorWhite progress:.9];
    button.highlightedBackgroundColor = [UIColor.tmui_randomColor tmui_transitionToColor:UIColorWhite progress:.75];// 高亮时的背景色
    button.layer.borderColor = [button.backgroundColor tmui_transitionToColor:UIColor.tmui_randomColor progress:.5].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 4;
    button.highlightedBorderColor = [button.backgroundColor tmui_transitionToColor:UIColor.tmui_randomColor progress:.9];// 高亮时的边框颜色
    return button;
}

@end


@interface TMUITableViewInsetDebugPanelView ()

// 可视范围内的 sectionHeader 列表
@property(nonatomic, strong) UILabel *visibleHeadersLabel;
@property(nonatomic, strong) UILabel *visibleHeadersValue;

// 当前 pinned 的那个 section 序号
@property(nonatomic, strong) UILabel *pinnedHeaderLabel;
@property(nonatomic, strong) UILabel *pinnedHeaderValue;

// 某个指定的 section 的 pinned 状态
@property(nonatomic, strong) UILabel *headerPinnedLabel;
@property(nonatomic, strong) UILabel *headerPinnedValue;
@end

@implementation TMUITableViewInsetDebugPanelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, .7);
        
        self.visibleHeadersLabel = [self generateTitleLabel];
        self.visibleHeadersLabel.text = @"可视的 sectionHeaders";
        self.visibleHeadersValue = [self generateValueLabel];
        
        self.pinnedHeaderLabel = [self generateTitleLabel];
        self.pinnedHeaderLabel.text = @"正在 pinned（悬浮）的 header";
        self.pinnedHeaderValue = [self generateValueLabel];
        
        self.headerPinnedLabel = [self generateTitleLabel];
        self.headerPinnedLabel.text = @"section0 和 section1 的 pinned";
        self.headerPinnedValue = [self generateValueLabel];
    }
    return self;
}

- (UILabel *)generateTitleLabel {
    UILabel *label = [[UILabel alloc] tmui_initWithFont:UIFontMake(12) textColor:UIColorWhite];
    [label tmui_calculateHeightAfterSetAppearance];
    [self addSubview:label];
    return label;
}

- (UILabel *)generateValueLabel {
    UILabel *label = [[UILabel alloc] tmui_initWithFont:UIFontMake(12) textColor:UIColorWhite];
    label.textAlignment = NSTextAlignmentRight;
    [label tmui_calculateHeightAfterSetAppearance];
    [self addSubview:label];
    return label;
}

- (void)renderWithTableView:(UITableView *)tableView {
    self.visibleHeadersValue.text = [tableView.tmui_indexForVisibleSectionHeaders componentsJoinedByString:@", "];
    
    NSInteger indexOfPinnedSectionHeader = tableView.tmui_indexOfPinnedSectionHeader;
    NSString *pinnedHeaderString = [NSString tmui_stringWithNSInteger:indexOfPinnedSectionHeader];
    self.pinnedHeaderValue.text = pinnedHeaderString;
    self.pinnedHeaderValue.textColor = indexOfPinnedSectionHeader == -1 ? UIColorRed : UIColorWhite;
    
    BOOL isSectionHeader0Pinned = [tableView tmui_isHeaderPinnedForSection:0];
    BOOL isSectionHeader1Pinned = [tableView tmui_isHeaderPinnedForSection:1];
    NSMutableAttributedString *headerPinnedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"0: %@ | 1: %@", StringFromBOOL(isSectionHeader0Pinned), StringFromBOOL(isSectionHeader1Pinned)] attributes:@{NSFontAttributeName: self.pinnedHeaderValue.font, NSForegroundColorAttributeName: UIColorWhite}];
    
    NSRange range0 = isSectionHeader0Pinned ? NSMakeRange(3, 3) : NSMakeRange(3, 2);
    NSRange range1 = isSectionHeader1Pinned ? NSMakeRange(headerPinnedString.length - 3, 3) : NSMakeRange(headerPinnedString.length - 2, 2);
    [headerPinnedString addAttribute:NSForegroundColorAttributeName value:isSectionHeader0Pinned ? UIColorGreen : UIColorRed range:range0];
    [headerPinnedString addAttribute:NSForegroundColorAttributeName value:isSectionHeader1Pinned ? UIColorGreen : UIColorRed range:range1];
    self.headerPinnedValue.attributedText = headerPinnedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsConcat(UIEdgeInsetsMake(24, 24, 24, 24), self.tmui_safeAreaInsets);
    NSArray<UILabel *> *leftLabels = @[self.visibleHeadersLabel, self.pinnedHeaderLabel, self.headerPinnedLabel];
    NSArray<UILabel *> *rightLabels = @[self.visibleHeadersValue, self.pinnedHeaderValue, self.headerPinnedValue];
    
    CGFloat contentWidth = self.width - UIEdgeInsetsGetHorizontalValue(padding);
    CGFloat labelHorizontalSpacing = 16;
    CGFloat labelVerticalSpacing = 16;
    CGFloat minY = padding.top;
    
    // 左边的 label
    CGFloat leftLabelWidth = flat((contentWidth - labelHorizontalSpacing) * 3 / 5);
    for (NSInteger i = 0; i < leftLabels.count; i++) {
        UILabel *label = leftLabels[i];
        label.frame = CGRectFlatMake(padding.left, minY, leftLabelWidth, label.height);
        minY = label.bottom + labelVerticalSpacing;
    }
    
    // 右边的 label
    minY = padding.top;
    CGFloat rightLabelMinX = leftLabels.firstObject.right + labelHorizontalSpacing;
    CGFloat rightLabelWidth = flat(contentWidth - leftLabelWidth - labelHorizontalSpacing);
    for (NSInteger i = 0; i < rightLabels.count; i++) {
        UILabel *label = rightLabels[i];
        label.frame = CGRectFlatMake(rightLabelMinX, minY, rightLabelWidth, label.height);
        minY = label.bottom + labelVerticalSpacing;
    }
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
}

@end
