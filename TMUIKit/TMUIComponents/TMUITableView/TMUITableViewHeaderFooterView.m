//
//  TMUITableViewHeaderFooterView.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import "TMUITableViewHeaderFooterView.h"
#import "TMUICore.h"
#import "UIView+TMUI.h"
#import "UITableView+TMUI.h"
#import "UITableViewHeaderFooterView+TMUI.h"

@implementation TMUITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    _titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    // remove system subviews
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    self.backgroundView = [[UIView alloc] init];// 去掉默认的背景，以便屏蔽系统对背景色的控制
}

// 系统的 UITableViewHeaderFooterView 不允许修改 backgroundColor，都应该放到 backgroundView 里，但却没有在文档中写明，只有不小心误用时才会在 Xcode 控制台里提示，所以这里做个转换，保护误用的情况。
- (void)setBackgroundColor:(UIColor *)backgroundColor {
//    [super setBackgroundColor:backgroundColor];
    self.backgroundView.backgroundColor = backgroundColor;
}

- (UIColor *)backgroundColor {
//    return [super backgroundColor];
    return self.backgroundView.backgroundColor;
}

- (void)updateAppearance {
    if (!TMUICMIActivated || (!self.parentTableView && !self.tmui_tableView) || self.type == TMUITableViewHeaderFooterViewTypeUnknow) return;

    UITableViewStyle style = (self.parentTableView ?: self.tmui_tableView).tmui_style;

    if (self.type == TMUITableViewHeaderFooterViewTypeHeader) {
        self.titleLabel.font = PreferredValueForTableViewStyle(style, TableViewSectionHeaderFont, TableViewGroupedSectionHeaderFont, TableViewInsetGroupedSectionHeaderFont);
        self.titleLabel.textColor = PreferredValueForTableViewStyle(style, TableViewSectionHeaderTextColor, TableViewGroupedSectionHeaderTextColor, TableViewInsetGroupedSectionHeaderTextColor);
        self.contentEdgeInsets = PreferredValueForTableViewStyle(style, TableViewSectionHeaderContentInset, TableViewGroupedSectionHeaderContentInset, TableViewInsetGroupedSectionHeaderContentInset);
        self.accessoryViewMargins = PreferredValueForTableViewStyle(style, TableViewSectionHeaderAccessoryMargins, TableViewGroupedSectionHeaderAccessoryMargins, TableViewInsetGroupedSectionHeaderAccessoryMargins);
        self.backgroundView.backgroundColor = PreferredValueForTableViewStyle(style, TableViewSectionHeaderBackgroundColor, UIColorClear, UIColorClear);
    } else {
        self.titleLabel.font = PreferredValueForTableViewStyle(style, TableViewSectionFooterFont, TableViewGroupedSectionFooterFont, TableViewInsetGroupedSectionFooterFont);
        self.titleLabel.textColor = PreferredValueForTableViewStyle(style, TableViewSectionFooterTextColor, TableViewGroupedSectionFooterTextColor, TableViewInsetGroupedSectionFooterTextColor);
        self.contentEdgeInsets = PreferredValueForTableViewStyle(style, TableViewSectionFooterContentInset, TableViewGroupedSectionFooterContentInset, TableViewInsetGroupedSectionFooterContentInset);
        self.accessoryViewMargins = PreferredValueForTableViewStyle(style, TableViewSectionFooterAccessoryMargins, TableViewGroupedSectionFooterAccessoryMargins, TableViewInsetGroupedSectionFooterAccessoryMargins);
        self.backgroundView.backgroundColor = PreferredValueForTableViewStyle(style, TableViewSectionFooterBackgroundColor, UIColorClear, UIColorClear);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.accessoryView) {
        [self.accessoryView sizeToFit];
        self.accessoryView.right = self.contentView.width - self.contentEdgeInsets.right - self.accessoryViewMargins.right;
        self.accessoryView.top = self.contentEdgeInsets.top + CGFloatGetCenter(self.contentView.height - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets), self.accessoryView.height) + self.accessoryViewMargins.top - self.accessoryViewMargins.bottom;
    }
    
    self.titleLabel.left = self.contentEdgeInsets.left;
    self.titleLabel.extendToRight = self.accessoryView ? self.accessoryView.left - self.accessoryViewMargins.left : self.contentView.width - self.contentEdgeInsets.right;
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(self.titleLabel.width, CGFLOAT_MAX)];
    self.titleLabel.top = self.contentEdgeInsets.top + CGFloatGetCenter(self.contentView.height - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets), titleLabelSize.height);
    self.titleLabel.height = titleLabelSize.height;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = size;
    
    CGSize accessoryViewSize = self.accessoryView ? self.accessoryView.frame.size : CGSizeZero;
    if (self.accessoryView) {
        accessoryViewSize.width = accessoryViewSize.width + UIEdgeInsetsGetHorizontalValue(self.accessoryViewMargins);
        accessoryViewSize.height = accessoryViewSize.height + UIEdgeInsetsGetVerticalValue(self.accessoryViewMargins);
    }
    
    CGFloat titleLabelWidth = size.width - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets) - accessoryViewSize.width;
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(titleLabelWidth, CGFLOAT_MAX)];
    
    resultSize.height = fmax(titleLabelSize.height, accessoryViewSize.height) + UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets);
    return resultSize;
}

#pragma mark - getter / setter

- (void)setAccessoryView:(UIView *)accessoryView {
    if (_accessoryView && _accessoryView != accessoryView) {
        [_accessoryView removeFromSuperview];
    }
    _accessoryView = accessoryView;
    self.isAccessibilityElement = NO;
    self.titleLabel.accessibilityTraits |= UIAccessibilityTraitHeader;
    [self.contentView addSubview:accessoryView];
}

- (void)setParentTableView:(UITableView *)parentTableView {
    _parentTableView = parentTableView;
    [self updateAppearance];
}

- (void)setType:(TMUITableViewHeaderFooterViewType)type {
    _type = type;
    [self updateAppearance];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    [self setNeedsLayout];
}

- (void)setAccessoryViewMargins:(UIEdgeInsets)accessoryViewMargins {
    _accessoryViewMargins = accessoryViewMargins;
    [self setNeedsLayout];
}


@end
