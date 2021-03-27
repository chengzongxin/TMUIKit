//
//  VC7Cell.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/3/27.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "VC7Cell.h"

const UIEdgeInsets kInsets1 = {15, 16, 15, 16};
const CGFloat kAvatarSize1 = 30;
const CGFloat kAvatarMarginRight1 = 12;
const CGFloat kAvatarMarginBottom1 = 6;
const CGFloat kContentMarginBotom1 = 10;

@implementation VC7Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self didInitializeWithStyle:style];
    }
    return self;
}

- (void)didInitializeWithStyle:(UITableViewCellStyle)style {
    
    UIImage *avatarImage = [UIImage tmui_imageWithStrokeColor:[UIColor tmui_randomColor] size:CGSizeMake(kAvatarSize1, kAvatarSize1) lineWidth:3 cornerRadius:6];
    _avatarImageView = [[UIImageView alloc] initWithImage:avatarImage];
    [self.contentView addSubview:self.avatarImageView];
    
    _nameLabel = [[UILabel alloc] tmui_initWithFont:UIFontBoldMake(16) textColor:UIColor.tmui_randomColor];
    [self.contentView addSubview:self.nameLabel];
    
    _contentLabel = [[UILabel alloc] tmui_initWithFont:UIFontMake(17) textColor:UIColor.tmui_randomColor];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    _timeLabel = [[UILabel alloc] tmui_initWithFont:UIFontMake(13) textColor:UIColor.tmui_randomColor];
    [self.contentView addSubview:self.timeLabel];
    
    _avatarImageView.makeCons(^{
        make.left.top.constants(kInsets1.left,kInsets1.top);
    });
    
    _nameLabel.makeCons(^{
//        make.top.equal.view(self.avatarImageView).top.constants(0);
        make.centerY.equal.view(self.avatarImageView).centerY.constants(0);
        make.left.equal.view(self.avatarImageView).right.constants(kAvatarMarginRight1);
    });
//    CGFloat contentLabelWidth = CGRectGetWidth(self.contentView.bounds) - UIEdgeInsetsGetHorizontalValue(kInsets1);
    _contentLabel.makeCons(^{
        make.left.right.constants(kInsets1.left,kInsets1.right);
        make.top.equal.view(self.avatarImageView).bottom.constants(kAvatarMarginBottom1);
    });
    
    _timeLabel.makeCons(^{
        make.left.constants(kInsets1.left);
        make.top.equal.view(self.contentLabel).bottom.constants(kContentMarginBotom1);
    });
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    CGFloat contentLabelWidth = CGRectGetWidth(self.contentView.bounds) - UIEdgeInsetsGetHorizontalValue(kInsets1);
//    self.avatarImageView.frame = CGRectSetXY(self.avatarImageView.frame, kInsets1.left, kInsets1.top);
//    if (self.nameLabel.text.length > 0) {
//        CGFloat nameLabelWidth = contentLabelWidth - CGRectGetWidth(self.avatarImageView.bounds) - kAvatarMarginRight1;
//        CGSize nameSize = [self.nameLabel sizeThatFits:CGSizeMake(nameLabelWidth, CGFLOAT_MAX)];
//        self.nameLabel.frame = CGRectFlatMake(CGRectGetMaxX(self.avatarImageView.frame) + kAvatarMarginRight1, CGRectGetMinY(self.avatarImageView.frame) + (CGRectGetHeight(self.avatarImageView.bounds) - nameSize.height) / 2, nameLabelWidth, nameSize.height);
//    }
//    if (self.contentLabel.text.length > 0) {
//        CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
//        self.contentLabel.frame = CGRectFlatMake(kInsets1.left, CGRectGetMaxY(self.avatarImageView.frame) + kAvatarMarginBottom1, contentLabelWidth, contentSize.height);
//    }
//    if (self.timeLabel.text.length > 0) {
//        CGSize timeSize = [self.timeLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
//        self.timeLabel.frame = CGRectFlatMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + kContentMarginBotom1, contentLabelWidth, timeSize.height);
//    }
//}


- (void)renderWithNameText:(NSString *)nameText contentText:(NSString *)contentText {
    
    self.nameLabel.text = nameText;
    self.contentLabel.attributedText = [self attributeStringWithString:contentText lineHeight:26];
    self.timeLabel.text = @"昨天 18:24";
    
    self.contentLabel.textAlignment = NSTextAlignmentJustified;
}

- (NSAttributedString *)attributeStringWithString:(NSString *)textString lineHeight:(CGFloat)lineHeight {
    if (textString.tmui_trim.length <= 0) return nil;
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:textString attributes:@{NSParagraphStyleAttributeName:[NSMutableParagraphStyle tmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByCharWrapping textAlignment:NSTextAlignmentLeft]}];
    return attriString;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    CGFloat contentLabelWidth = size.width - UIEdgeInsetsGetHorizontalValue(kInsets1);
    
    CGFloat resultHeight = UIEdgeInsetsGetHorizontalValue(kInsets1) + CGRectGetHeight(self.avatarImageView.bounds) + kAvatarMarginBottom1;
    
    if (self.contentLabel.text.length > 0) {
        CGSize contentSize = [self.contentLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        resultHeight += (contentSize.height + kContentMarginBotom1);
    }
    
    if (self.timeLabel.text.length > 0) {
        CGSize timeSize = [self.timeLabel sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
        resultHeight += timeSize.height;
    }
    
    resultSize.height = resultHeight;
    NSLog(@"%@ 的 cell 的 sizeThatFits: 被调用（说明这个 cell 的高度重新计算了一遍）", self.nameLabel.text);
    return resultSize;
}




@end
