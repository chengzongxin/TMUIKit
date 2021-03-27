//
//  TMUITableViewProtocols.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class TMUITableView;

@protocol TMUICellHeightCache_UITableViewDataSource

@optional
/// 搭配 TMUICellHeightCache 使用，对于 UITableView 而言如果要用 TMUICellHeightCache 那套高度计算方式，则必须实现这个方法
- (nullable __kindof UITableViewCell *)tmui_tableView:(nullable UITableView *)tableView cellWithIdentifier:(nonnull NSString *)identifier;

@end

@protocol TMUICellHeightKeyCache_UITableViewDelegate <NSObject>

@optional

- (nonnull id<NSCopying>)tmui_tableView:(nonnull UITableView *)tableView cacheKeyForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
@end

@protocol TMUITableViewDelegate <UITableViewDelegate, TMUICellHeightKeyCache_UITableViewDelegate>

@optional

/**
 * 自定义要在<i>- (BOOL)touchesShouldCancelInContentView:(UIView *)view</i>内的逻辑<br/>
 * 若delegate不实现这个方法，则默认对所有UIControl返回NO（UIButton除外，它会返回YES），非UIControl返回YES。
 */
- (BOOL)tableView:(nonnull TMUITableView *)tableView touchesShouldCancelInContentView:(nonnull UIView *)view;

@end


@protocol TMUITableViewDataSource <UITableViewDataSource, TMUICellHeightCache_UITableViewDataSource>

@end

NS_ASSUME_NONNULL_END
