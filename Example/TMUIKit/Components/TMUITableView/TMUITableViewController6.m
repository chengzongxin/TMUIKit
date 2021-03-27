//
//  TMUITableViewController6.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/26.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "TMUITableViewController6.h"

static NSString * const kCellIdentifier = @"cell";

@interface TMUITableViewController6 ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) TMUIOrderedDictionary *dataSource;

@end

@implementation TMUITableViewController6

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[TMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"张三 的想法", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"TMUI Team 的想法", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       
                       @"张三 的想法1", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法1", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法1", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"TMUI Team 的想法1", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       
                       @"张三 的想法2", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法2", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法2", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"TMUI Team 的想法2", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       
                       @"张三 的想法3", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
                       @"李四 的想法3", @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
                       @"王五 的想法3", @"高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       @"TMUI Team 的想法3", @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。",
                       nil];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleDebugItemEvent)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem tmui_itemWithTitle:@"更新第二行数据" color:UIColor.tmui_randomColor font:UIFont(15) target:self action:@selector(handleRightBarButtonItem)];
    
    [self.view addSubview:self.tableView];
}

- (void)handleRightBarButtonItem {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    id<NSCopying> cachedKey = [self cachedKeyAtIndexPath:indexPath];
    
    // 1. 模拟业务场景某个 indexPath 的数据发生变化
    [self.dataSource setObject:@"变化后的内容" forKey:self.dataSource.allKeys[indexPath.row]];
    
    // 2. 在更新 UI 之前先令对应的缓存失效
    [self.tableView tmui_invalidateHeightForKey:cachedKey];
    
    // 3. 更新 UI
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (id<NSCopying>)cachedKeyAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyName = self.dataSource.allKeys[indexPath.row];
    NSString *contentText = [self.dataSource objectForKey:keyName];
    return @(contentText.length);// 这里简单处理，认为只要长度不同，高度就不同（但实际情况下长度就算相同，高度也有可能不同，要注意）
}

#pragma mark - <TMUITableViewDelegate, TMUITableViewDataSource>

- (UITableViewCell *)tmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:kCellIdentifier]) {
        TMUIDynamicHeightTableViewCell *cell = (TMUIDynamicHeightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TMUIDynamicHeightTableViewCell alloc] initForTableView:tableView withReuseIdentifier:kCellIdentifier];
        }
        cell.separatorInset = UIEdgeInsetsZero;
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMUIDynamicHeightTableViewCell *cell = (TMUIDynamicHeightTableViewCell *)[self tmui_tableView:tableView cellWithIdentifier:kCellIdentifier];
    NSString *keyName = self.dataSource.allKeys[indexPath.row];
    [cell updateCellAppearanceWithIndexPath:indexPath];
    [cell renderWithNameText:[NSString stringWithFormat:@"%@ - %@", @(indexPath.row), keyName] contentText:[self.dataSource objectForKey:keyName]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<NSCopying> cachedKey = [self cachedKeyAtIndexPath:indexPath];
    NSString *keyName = self.dataSource.allKeys[indexPath.row];
    return [tableView tmui_heightForCellWithIdentifier:kCellIdentifier cacheByKey:cachedKey configuration:^(TMUIDynamicHeightTableViewCell *cell) {
        [cell updateCellAppearanceWithIndexPath:indexPath];
        [cell renderWithNameText:[NSString stringWithFormat:@"%@ - %@", @(indexPath.row), keyName] contentText:[self.dataSource objectForKey:keyName]];
    }];
}


- (void)handleDebugItemEvent {
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorHexString(@"EEEEEE");
    }
    return _tableView;
}


@end
