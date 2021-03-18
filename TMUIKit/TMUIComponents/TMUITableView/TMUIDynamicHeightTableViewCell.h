//
//  TMUIDynamicHeightTableViewCell.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/18.
//

#import "TMUITableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
// 这个 cell 只是为了展示每个 cell 高度不一样，这样才有被 cache 的意义，至于这个 cell 里的代码可以不看
@interface TMUIDynamicHeightTableViewCell : TMUITableViewCell
@property(nonatomic, strong) UIImageView *avatarImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *timeLabel;

- (void)renderWithNameText:(NSString *)nameText contentText:(NSString *)contentText;
@end

NS_ASSUME_NONNULL_END
