//
//  UIScrollView+PeerRefresh.m
//  EmptyDemo
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UIScrollView+PeerRefresh.h"
#import "MJRefreshBackGifNoMoreDataFooter.h"
#import "PreloadingRefreshAutoFooter.h"
#define kAnimateDuration 1.0f
#define kRefreshImageCount 12
@implementation UIScrollView (PeerRefresh)

#pragma mark - 刷新方法

- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock autofooterBlock:(void (^)(void))footerBlock{
    NSMutableArray *refreshGiftArr = [NSMutableArray array];
    for (NSUInteger i = 1; i<=kRefreshImageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_loading_%04zd", i]];
        [refreshGiftArr addObject:image];
    }
    NSAssert(refreshGiftArr.count, @"mjfresh no fresh image");
    NSAssert(headerBlock, @"mjfresh no headerblock");
    NSAssert(footerBlock, @"mjfresh no footerBlock");
    
    if (headerBlock) {
        MJRefreshGifHeader *header= [MJRefreshGifHeader headerWithRefreshingBlock:headerBlock];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        self.mj_header = header;
    }
    if (footerBlock) {
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:footerBlock];
        footer.triggerAutomaticallyRefreshPercent = 0.1;
//        [footer setTitle:kLStr(@"common_load_more") forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStatePulling];
//        [footer setTitle:kLStr(@"common_load_more") forState:MJRefreshStateRefreshing];
//        [footer setTitle:kLStr(@"common_load_more") forState:MJRefreshStatePulling];
        [footer setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
        [footer setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        [footer setTitle:kLStr(@"community_vidoe_comment_end") forState:MJRefreshStateNoMoreData];
        self.mj_footer = footer;
    }
    
    self.initalContentInset = self.contentInset;
}

- (void)setRefreshWithHeaderBlock:(void (^)(void))headerBlock footerBlock:(void (^)(void))footerBlock{
    NSMutableArray *refreshGiftArr = [NSMutableArray array];
    for (NSUInteger i = 1; i<=kRefreshImageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_loading_%04zd", i]];
        [refreshGiftArr addObject:image];
    }
    
    if (headerBlock) {
        MJRefreshGifHeader *header= [MJRefreshGifHeader headerWithRefreshingBlock:^{
            if (headerBlock) {
                headerBlock();
            }
        }];
        
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        self.mj_header = header;
    }
    if (footerBlock) {
        MJRefreshBackGifFooter * footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
            if (footerBlock) {
                footerBlock();
            }
        }];
        [footer setTitle:kLStr(@"common_load_more") forState:MJRefreshStateIdle];
//        footer.refreshingTitleHidden = YES;
        footer.stateLabel.hidden = YES;
        [footer setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
        [footer setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        [footer setTitle:kLStr(@"community_vidoe_comment_end") forState:MJRefreshStateNoMoreData];
        self.mj_footer = footer;
    }
    
    self.initalContentInset = self.contentInset;
    
}

//下拉刷新
- (void)setOnlyRefreshWithHeaderBlock:(void (^)(void))headerBlock {
    
    NSMutableArray *refreshGiftArr = [NSMutableArray array];
    for (NSUInteger i = 1; i<=kRefreshImageCount; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_loading_%04zd", i]];
        [refreshGiftArr addObject:image];
    }
    if (headerBlock) {
  
        MJRefreshGifHeader *header= [MJRefreshGifHeader headerWithRefreshingBlock:^{
            if (headerBlock) {
                headerBlock();
            }
        }];
        
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStateRefreshing];
        [header setImages:refreshGiftArr duration:kAnimateDuration forState:MJRefreshStatePulling];
        self.mj_header = header;
        
    }
}

//上拉加载更多
- (void)setRefreshWithFooterBlock:(void (^)(void))footerBlock{
    
    if (footerBlock) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            footerBlock();
        }];
//        [footer setTitle:@"正在为你推荐更多精彩内容..." forState:MJRefreshStateRefreshing];
        [footer setTitle:kLStr(@"common_load_loading_data") forState:MJRefreshStateRefreshing];
        [footer setTitle:kLStr(@"community_vidoe_comment_end") forState:MJRefreshStateNoMoreData];
//        footer.refreshingTitleHidden = YES;
        self.mj_footer = footer;
    }
    
}

#pragma mark - 无更多数据方法
- (void)resetNoMoreData{
//    if (self.mj_footer.state == MJRefreshStateNoMoreData) {
//        UIEdgeInsets insets = self.mj_footer.scrollView.contentInset;
//        self.mj_footer.scrollView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom-120, insets.right);
//    }
    
    [self.mj_footer resetNoMoreData];
    [(MJRefreshBackGifFooter *)self.mj_footer stateLabel].hidden = YES;
}

- (void)noticeNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
//    UIEdgeInsets insets = self.mj_footer.scrollView.contentInset;
//    self.mj_footer.scrollView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom+120, insets.right);
    [(MJRefreshBackGifFooter *)self.mj_footer stateLabel].hidden = NO;
}

#pragma mark - 停止刷新方法
- (void)headerBeginRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)headerEndRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)footerEndRefreshing
{
    [self.mj_footer endRefreshing];
}

- (void)footerNoMoreData
{
//    [self.mj_footer setState:MJRefreshStateNoMoreData];
    [self noticeNoMoreData];
}

- (void)hideFooterRefresh{
    self.mj_footer.hidden = YES;
}


- (void)hideHeaderRefresh{
    self.mj_header.hidden = YES;
}

- (void)showHeaderRefresh{
    self.mj_header.hidden = NO;
}

- (void)showFooterRefresh{
    self.mj_footer.hidden = NO;
}

- (void)ignoredScrollViewContentInsetTop:(CGFloat)insetTop{
//    [self.mj_header ignoredScrollViewContentInsetTop];
    self.mj_header.ignoredScrollViewContentInsetTop = insetTop;
}


- (UIEdgeInsets)initalContentInset{
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

- (void)setInitalContentInset:(UIEdgeInsets)initalContentInset{
    objc_setAssociatedObject(self, @selector(initalContentInset), [NSValue valueWithUIEdgeInsets:initalContentInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
