//
//  TDAllSystemFontViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/7/21.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TDAllSystemFontViewController.h"

@interface TDAllSystemFontViewController ()<UITableViewDelegate,UITableViewDataSource,TMUISearchBarDelegate>


@property (nonatomic, strong) TMUISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<UIFont *> *allFonts;
@property (nonatomic, strong) NSMutableArray<UIFont *> *searchResultFonts;
@property (nonatomic, assign) BOOL isFilter;

@end

@implementation TDAllSystemFontViewController


//- (instancetype)initWithStyle:(UITableViewStyle)style {
//    if (self = [super initWithStyle:style]) {
//        self.shouldShowSearchBar = YES;
//        self.allFonts = [[NSMutableArray alloc] init];
//        self.searchResultFonts = [[NSMutableArray alloc] init];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            for (NSString *familyName in [UIFont familyNames]) {// 注意，familyNames 获取到的字体大全里不包含系统默认字体（iOS 13 是 .SFUI，iOS 12 及以前是 .SFUIText）
//                for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//                    [self.allFonts addObject:[UIFont fontWithName:fontName size:16]];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([self isViewLoaded]) {
//                    [self.tableView reloadData];
//                }
//            });
//        });
//    }
//    return self;
//}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.allFonts = [[NSMutableArray alloc] init];
    self.searchResultFonts = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchBar;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *familyName in [UIFont familyNames]) {// 注意，familyNames 获取到的字体大全里不包含系统默认字体（iOS 13 是 .SFUI，iOS 12 及以前是 .SFUIText）
            for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
                [self.allFonts addObject:[UIFont fontWithName:fontName size:16]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isViewLoaded]) {
                [self.tableView reloadData];
            }
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<UIFont *> *fonts = self.isFilter ?  self.searchResultFonts : self.allFonts;
    return fonts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<UIFont *> *fonts = tableView == self.tableView ? self.allFonts : self.searchResultFonts;
    NSString *fontName = fonts[indexPath.row].fontName;
    if ([fontName containsString:@"Zapfino"]) {
        // 这个字体很飘逸，不够高是显示不全的
        return TableViewCellNormalHeight + 60;
    }
    return TableViewCellNormalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<UIFont *> *fonts = self.isFilter ?  self.searchResultFonts : self.allFonts;
    static NSString *identifier = @"cell";
    TMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColor.td_mainTextColor;
        cell.detailTextLabel.textColor = UIColor.td_descriptionTextColor;
    }
    
    UIFont *font = fonts[indexPath.row];
    cell.textLabel.font = font;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", @(indexPath.row + 1), font.fontName];
    cell.detailTextLabel.font = font;
    cell.detailTextLabel.text = @"中文的效果";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)searchBarTextChange:(TMUISearchBar *)searchBar textField:(UITextField *)textField{
    if (textField.text.length) {
        self.isFilter = YES;
        [self.searchResultFonts removeAllObjects];
        for (UIFont *font in self.allFonts) {
            if ([font.fontName.lowercaseString containsString:textField.text.lowercaseString]) {
                [self.searchResultFonts addObject:font];
            }
        }
    }else{
        self.isFilter = NO;
    }
    [self.tableView reloadData];
}


- (TMUISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[TMUISearchBar alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH - 40, 36)];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
    }
    return _searchBar;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:TMUITableViewCell.class forCellReuseIdentifier:NSStringFromClass(TMUITableViewCell.class)];
    }
    return _tableView;
}

//- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
//    [self.searchResultFonts removeAllObjects];
//    for (UIFont *font in self.allFonts) {
//        if ([font.fontName.lowercaseString containsString:searchString.lowercaseString]) {
//            [self.searchResultFonts addObject:font];
//        }
//    }
//    [searchController.tableView reloadData];
//}


@end
