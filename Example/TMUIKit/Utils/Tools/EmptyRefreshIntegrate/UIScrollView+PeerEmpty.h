//
//  UIScrollView+PeerEmpty.h
//  EmptyDemo
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIScrollView+EmptyDataSet.h>

typedef enum : NSUInteger {
    EmptyStatusInital = 1,  // 初始
    EmptyStatusNoData = 2,  // 没数据
    EmptyStatusNoNet  = 3,   // 没网络
} EmptyStatusType;

@class EmptyModel;
@interface UIScrollView (PeerEmpty)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
typedef void(^ClickBlock)(void);
@property (nonatomic) ClickBlock clickBlock;                // 点击事件
@property (nonatomic, assign) CGFloat offset;               // 垂直偏移量
@property (nonatomic, strong) NSString *emptyText;          // 空数据显示内容
@property (nonatomic, strong) UIImage *buttonImage;        // 空数据按钮内容
@property (nonatomic, strong) NSString *buttonTitle;        // 空数据按钮内容
@property (nonatomic, strong) UIImage *emptyImage;          // 空数据的图片
@property (nonatomic, assign) BOOL isLoading;               // 是否正在加载,如果在加载就不显示
@property (nonatomic, assign) NSRange range;                // 富文本range

- (void)setupEmptyData:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text tapBlock:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset tapBlock:(ClickBlock)clickBlock;
- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock;
// 富文本
- (void)setupEmptyDataAttrbuteText:(NSString *)text range:(NSRange)range verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock;

- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image buttonImage:(UIImage *)buttonImage tapBlock:(ClickBlock)clickBlock;

- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image buttonTitle:(NSString *)buttonTitle tapBlock:(ClickBlock)clickBlock;


#pragma mark - 多状态切换
@property (assign, nonatomic) EmptyStatusType statusType;
@property (strong, nonatomic) EmptyModel *inialAttrs;
@property (strong, nonatomic) EmptyModel *noDataAttrs;
@property (strong, nonatomic) EmptyModel *noNetAttrs;

- (void)setupEmptyDataWithInital:(EmptyModel *)inialAttrs
                          noData:(EmptyModel *)noDataAttrs
                           noNet:(EmptyModel *)noNetAttrs
                  verticalOffset:(CGFloat)offset
                        tapBlock:(ClickBlock)clickBlock;

@end


@interface EmptyModel : NSObject

@property (strong, nonatomic) NSAttributedString *title;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *buttonTitle;

+ (instancetype)modelWithTitle:(NSAttributedString *)title image:(UIImage *)image buttonTitle:(NSString *)buttonTitle;

+ (instancetype)modelWithTitle:(NSAttributedString *)title image:(UIImage *)image;

@end
