//
//  TMEmptyContentItemProtocol.h
//  Masonry
//
//  Created by nigel.ning on 2020/6/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TMEmptyDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TMEmptyContentItemProtocol <NSObject>

#pragma mark - 空白页占位图配置

@property (nonatomic, assign)CGFloat contentCenterOffsetY;///<  具体展示的内容块整体Y轴上居中位置后的偏移参数，若为0表示整体居中效果，若<0表示居中上移，>0表示居中下移 | 按设计稿此值通常会被赋值为默认值-70，即表示居中位置上移70pt

@property (nonatomic, assign, readonly)CGSize emptyImgSize;///< 返回空白页相关提示图片视图显示的尺寸，按显示的pt为准

@property (nonatomic, strong, readonly)UIImage *emptyImg;///<  返回空白页相关的提示图片对象

#pragma mark - 空白页占位图下方的标题串配置 | 当富文本有值时优先取富文本展示
@property (nonatomic, copy, nullable)NSString *title;///< 空白页显示的在占位图下方的标题串

@property (nonatomic, copy, nullable)NSAttributedString *attributedTitle;///< 自定义标题的富文本串，若有值则优先显示富文本串标题

#pragma mark - 空白页标题串下方的子描述串配置 | 当富文本有值时优先取富文本展示
@property (nonatomic, copy, nullable)NSString *desc;///< 空白页显示在标题串下方的子描述串

@property (nonatomic, copy, nullable)NSAttributedString *attributedDesc;///< 自定义子描述串的富文本串， 若有值则优先显示富文本子描述串

#pragma mark - 整个空白页提示视图点击后的回调配置
@property (nonatomic, copy, nullable)void (^clickEmptyBlock)(void);

#pragma mark - 提供单独更新图片及图片size的接口

- (void)updateImage:(UIImage *)img;
- (void)updateImageFromType:(TMEmptyContentType)type;
- (void)updateImageSize:(CGSize)imgSize;

@end

NS_ASSUME_NONNULL_END
