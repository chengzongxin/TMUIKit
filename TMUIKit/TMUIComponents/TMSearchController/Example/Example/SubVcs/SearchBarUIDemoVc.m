//
//  SearchBarUIDemoVc.m
//  Example
//
//  Created by nigel.ning on 2020/8/10.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "SearchBarUIDemoVc.h"
#import "TMSearchBar.h"
#import "TMUICommonDefines.h"
#import <Masonry/Masonry.h>

@interface SearchBarUIDemoVc ()<TMSearchBarDelegate>
@property (nonatomic, strong)TMSearchBar *searchBar;

@end

@implementation SearchBarUIDemoVc


TMUI_DEBUG_Code_Dealloc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"SearchBar UI";
    
    TMSearchBar *searchBar = [[TMSearchBar alloc] init];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(50);
        make.height.mas_equalTo(44);
        make.trailing.mas_equalTo(-50);
    }];
    searchBar.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.5];
    searchBar.textField.layer.cornerRadius = (44 - searchBar.contentEdgeInsets.top - searchBar.contentEdgeInsets.bottom)/2;
    searchBar.placeholder = @"测试placeHolder";
    self.searchBar = searchBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - TMSearchBarDelegate
- (void)tmSearchBarTextDidBeginEditing:(TMSearchBar *)searchBar {
    [searchBar setActive:YES animate:YES];
}

- (void)tmSearchBar:(TMSearchBar *)searchBar textDidChange:(NSString *)searchText {
    TMUI_DEBUG_Code(
                    NSLog(@"textChange==>: %@", searchText);
                    )
}
- (void)tmSearchBarSearchButtonClicked:(TMSearchBar *)searchBar {
    TMUI_DEBUG_Code(
                    NSLog(@"search: %@", searchBar.text);
                    )
}
- (void)tmSearchBarCancelButtonClicked:(TMSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setActive:NO animate:YES];
}


@end
