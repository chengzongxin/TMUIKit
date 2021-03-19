//
//  TMUITableViewController2.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/18.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITableViewController2.h"

@interface TMUITableViewController2 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UISegmentedControl *segmentedTitleView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TMUITableViewController2

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    [self handleTableViewStyleChanged:0];
}


#pragma mark - <TMUITableViewDelegate, TMUITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = UIFontMake(16);
        cell.textLabel.textColor = TableViewCellTitleLabelColor;
        cell.tmui_separatorInsetsBlock = ^UIEdgeInsets(__kindof UITableView * _Nonnull aTableView, __kindof UITableViewCell * _Nonnull aCell) {
            TMUITableViewCellPosition position = aCell.tmui_cellPosition;
            CGFloat defaultRight = 20;
            switch (aTableView.tmui_style) {
                case UITableViewStylePlain: {
                    CGRect frame = [aCell convertRect:aCell.textLabel.bounds fromView:aCell.textLabel];
                    CGFloat left = CGRectGetMinX(frame);
                    CGFloat right = aCell.tmui_accessoryView ? CGRectGetWidth(aCell.bounds) - CGRectGetMinX(aCell.tmui_accessoryView.frame) : defaultRight;
                    return UIEdgeInsetsMake(0, left, 0, right);
                }
                case UITableViewStyleGrouped: {
                    CGRect frame = [aCell convertRect:aCell.textLabel.bounds fromView:aCell.textLabel];
                    CGFloat left = (position & TMUITableViewCellPositionLastInSection) == TMUITableViewCellPositionLastInSection ? 0 : CGRectGetMinX(frame);
                    CGFloat right = aCell.tmui_accessoryView ? CGRectGetWidth(aCell.bounds) - CGRectGetMinX(aCell.tmui_accessoryView.frame) : defaultRight;
                    right = (position & TMUITableViewCellPositionLastInSection) == TMUITableViewCellPositionLastInSection ? 0 : right;
                    return UIEdgeInsetsMake(0, left, 0, right);
                }
                default: {
                    // InsetGrouped
                    if ((position & TMUITableViewCellPositionLastInSection) == TMUITableViewCellPositionLastInSection) {
                        return TMUITableViewCellSeparatorInsetsNone;
                    }
                    CGRect frame = [aCell convertRect:aCell.textLabel.bounds fromView:aCell.textLabel];
                    CGFloat left = CGRectGetMinX(frame);
                    CGFloat right = aCell.tmui_accessoryView ? CGRectGetWidth(aCell.bounds) - CGRectGetMinX(aCell.tmui_accessoryView.frame) : defaultRight;
                    return UIEdgeInsetsMake(0, left, 0, right);
                }
            }
        };
        cell.tmui_topSeparatorInsetsBlock = ^UIEdgeInsets(__kindof UITableView * _Nonnull aTableView, __kindof UITableViewCell * _Nonnull aCell) {
            if (aTableView.tmui_style == UITableViewStyleGrouped && aCell.tmui_cellPosition & TMUITableViewCellPositionFirstInSection) {
                return UIEdgeInsetsZero;
            }
            return TMUITableViewCellSeparatorInsetsNone;
        };
    }
    
    NSString *text = nil;
    
    if (indexPath.section > 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        text = @"分隔线在 accessoryView 前截止";
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.imageView.image = [UIImage tmui_imageWithStrokeColor:[UIColor tmui_randomColor] size:CGSizeMake(30, 30) lineWidth:3 cornerRadius:6];
        text = @"分隔线在 imageView 之后开始";
    } else {
        cell.imageView.image = nil;
    }
    
    if (!text) {
        TMUITableViewCellPosition position = [tableView tmui_positionForRowAtIndexPath:indexPath];
        if ((position & TMUITableViewCellPositionSingleInSection) == TMUITableViewCellPositionSingleInSection) {
            text = @"section 单行的情况";
        } else if ((position & TMUITableViewCellPositionLastInSection) == TMUITableViewCellPositionLastInSection) {
            text = @"section 最后一行的情况";
        }
    }
    cell.textLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TableViewCellNormalHeight;
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
    self.tableView.backgroundColor = UIColorHexString(@"EEEEEE");
    [self.view addSubview:self.tableView];
}

@end
