//
//  UIScrollView+PeerEmpty.m
//  EmptyDemo
//
//  Created by Apple on 2017/8/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "UIScrollView+PeerEmpty.h"

#import <objc/runtime.h>
static const void *KClickBlock = @"clickBlock";
static const void *KEmptyText = @"emptyText";
static const void *KOffSet = @"offset";
static const void *Kimage = @"emptyImage";
static const void *KIsLoading = @"isLoding";
static const void *KRange = @"range";
static const int  KSpaceHeight = 8;
@implementation UIScrollView (PeerEmpty)

#pragma mark - Getter Setter

- (ClickBlock)clickBlock{
    return objc_getAssociatedObject(self, &KClickBlock);
}

- (void)setClickBlock:(ClickBlock)clickBlock{
    
    objc_setAssociatedObject(self, &KClickBlock, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)emptyText{
    return objc_getAssociatedObject(self, &KEmptyText);
}

- (void)setEmptyText:(NSString *)emptyText{
    objc_setAssociatedObject(self, &KEmptyText, emptyText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)offset{
    
    NSNumber *number = objc_getAssociatedObject(self, &KOffSet);
    return number.floatValue;
}

- (void)setOffset:(CGFloat)offset{
    
    NSNumber *number = [NSNumber numberWithDouble:offset];
    
    objc_setAssociatedObject(self, &KOffSet, number, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isLoading{
    NSNumber *number = objc_getAssociatedObject(self, &KIsLoading);
    return number.boolValue;
}

- (void)setIsLoading:(BOOL)isLoading{
    NSNumber *num = [NSNumber numberWithBool:isLoading];
    
    objc_setAssociatedObject(self, &KIsLoading, num, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)emptyImage{
    return objc_getAssociatedObject(self, &Kimage);
}

- (void)setEmptyImage:(UIImage *)emptyImage{
    objc_setAssociatedObject(self, &Kimage, emptyImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// range
- (NSRange)range{
    NSValue *value = objc_getAssociatedObject(self, &KRange);
    return value.rangeValue;
}


- (void)setRange:(NSRange)range{
    NSValue *value = [NSValue valueWithRange:range];
    objc_setAssociatedObject(self, &KRange, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)buttonImage{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setButtonImage:(UIImage *)buttonImage{
    objc_setAssociatedObject(self, @selector(buttonImage), buttonImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)buttonTitle{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    objc_setAssociatedObject(self, @selector(buttonTitle), buttonTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (EmptyStatusType)statusType{
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setStatusType:(EmptyStatusType)statusType{
    objc_setAssociatedObject(self, @selector(statusType), @(statusType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (EmptyModel *)inialAttrs{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setInialAttrs:(EmptyModel *)inialAttrs{
    objc_setAssociatedObject(self, @selector(inialAttrs), inialAttrs, OBJC_ASSOCIATION_RETAIN);
}

- (EmptyModel *)noDataAttrs{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNoDataAttrs:(EmptyModel *)noDataAttrs{
    objc_setAssociatedObject(self, @selector(noDataAttrs), noDataAttrs, OBJC_ASSOCIATION_RETAIN);
}

- (EmptyModel *)noNetAttrs{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNoNetAttrs:(EmptyModel *)noNetAttrs{
    objc_setAssociatedObject(self, @selector(noNetAttrs), noNetAttrs, OBJC_ASSOCIATION_RETAIN);
}

- (void)setupEmptyData:(ClickBlock)clickBlock{
    self.clickBlock = clickBlock;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


- (void)setupEmptyDataText:(NSString *)text tapBlock:(ClickBlock)clickBlock{
    self.clickBlock = clickBlock;
    self.emptyText = text;
    self.isLoading = YES;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset tapBlock:(ClickBlock)clickBlock{
    self.emptyText = text;
    self.offset = offset;
    self.clickBlock = clickBlock;
    
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock{
    self.emptyText = text;
    self.offset = offset;
    self.emptyImage = image;
    self.clickBlock = clickBlock;
    self.isLoading = YES;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}

- (void)setupEmptyDataAttrbuteText:(NSString *)text range:(NSRange)range verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image tapBlock:(ClickBlock)clickBlock{
    self.emptyText = text;
    self.range = range;
    self.offset = offset;
    self.emptyImage = image;
    self.clickBlock = clickBlock;
    self.isLoading = YES;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image buttonImage:(UIImage *)buttonImage tapBlock:(ClickBlock)clickBlock{
    self.emptyText = text;
    self.offset = offset;
    self.emptyImage = image;
    self.buttonImage = buttonImage;
    self.clickBlock = clickBlock;
    self.isLoading = YES;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}

- (void)setupEmptyDataText:(NSString *)text verticalOffset:(CGFloat)offset emptyImage:(UIImage *)image buttonTitle:(NSString *)buttonTitle tapBlock:(ClickBlock)clickBlock{
    self.emptyText = text;
    self.offset = offset;
    self.emptyImage = image;
    self.buttonTitle = buttonTitle;
    self.clickBlock = clickBlock;
    self.isLoading = YES;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}

- (void)setupEmptyDataWithInital:(EmptyModel *)inialAttrs noData:(EmptyModel *)noDataAttrs noNet:(EmptyModel *)noNetAttrs verticalOffset:(CGFloat)offset tapBlock:(ClickBlock)clickBlock{
    self.inialAttrs = inialAttrs;
    self.noDataAttrs = noDataAttrs;
    self.noNetAttrs = noNetAttrs;
    self.offset = offset;
    self.isLoading = NO;
    self.statusType = EmptyStatusInital;
    self.clickBlock = clickBlock;
    self.emptyDataSetSource = self;
    if (clickBlock) {
        self.emptyDataSetDelegate = self;
    }
}


#pragma mark - DZNEmptyDataSetSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return !self.isLoading;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return KSpaceHeight;
}

// 空白界面的标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    // 多状态
    switch (self.statusType) {
        case EmptyStatusInital:
            return self.inialAttrs.title;
            break;
        case EmptyStatusNoData:
            return self.noDataAttrs.title;
            break;
        case EmptyStatusNoNet:
            return self.noNetAttrs.title;
            break;
        default:
            break;
    }
    
    // 单状态
    NSString *text = self.emptyText?:kLStr(@"common_no_data");
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: ColorHex(0x8F8F8F),
                                 NSParagraphStyleAttributeName: paragraph};
    
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    
    if ([self.emptyText containsString:kLStr(@"community_search_changeWord")]) {
        NSDictionary *attributesColor = @{
                                          NSFontAttributeName: [UIFont systemFontOfSize:14],
                                          NSForegroundColorAttributeName: COLOR(37, 197, 206, 1),
                                          };
        //2.匹配字符串
        NSString *string  = self.emptyText;
        NSRange range = [string rangeOfString:@"换"];//匹配得到的下标
        NSLog(@"rang:%@",NSStringFromRange(range));
        string = [string substringWithRange:range];//截取范围内的字符串
        [attributedStr setAttributes:attributesColor range:NSMakeRange(range.location, 5)];
    }
   
//    [attributedStr addAttribute:NSFontAttributeName
//
//                          value:[UIFont systemFontOfSize:16.0]
//
//                          range:NSMakeRange(2, 2)];
    
    if (self.range.location != 0 && self.range.length != 0) {
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:HEXCOLOR(0x00C3CE)
                              range:self.range];
    }
    
    
    
    return attributedStr;
}

// 空白页的图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    switch (self.statusType) {
        case EmptyStatusInital:
            return self.inialAttrs.image;
            break;
        case EmptyStatusNoData:
            return self.noDataAttrs.image;
            break;
        case EmptyStatusNoNet:
            return self.noNetAttrs.image;
            break;
        default:
            break;
    }
    return self.emptyImage;
}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

// 垂直偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.offset;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    return self.buttonImage;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *multiTitle = nil;
    switch (self.statusType) {
        case EmptyStatusInital:
            multiTitle = self.inialAttrs.buttonTitle;
            break;
        case EmptyStatusNoData:
            multiTitle = self.noDataAttrs.buttonTitle;
            break;
        case EmptyStatusNoNet:
            multiTitle = self.noNetAttrs.buttonTitle;
            break;
        default:
            break;
    }
    
    if (multiTitle) {
        return [[NSAttributedString alloc] initWithString:multiTitle attributes:nil];
    }
    
    
    
    if (self.buttonTitle == nil) {
        return nil;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName : ( (state == UIControlStateNormal) ? HEXCOLOR(0x00C3CE) : HEXCOLOR(0x8F8F8F) )
                                 };
    
    return [[NSAttributedString alloc] initWithString:self.buttonTitle attributes:attributes];
}


- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    
    if (self.buttonTitle == nil) {
        return nil;
    }
    
    NSString *imageName = [[NSString stringWithFormat:@"order_empty_button"] lowercaseString];
    
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_normal"];
    
    CGFloat textW = [self.buttonTitle singleLineSizeWithText:[UIFont systemFontOfSize:14]].width;
    CGFloat buttonW = textW;
    CGFloat inset = (KMainScreenWidth - 128 - buttonW - 20)/2;
    
    UIEdgeInsets capInsets =  UIEdgeInsetsZero;//UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(0, -inset, 0, -inset);

    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}


#pragma mark - DZNEmptyDataSetDelegate

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    if (self.clickBlock && !self.buttonImage) {
        self.clickBlock();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

//- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView{
//    if (self.statusType) {
//        for (UIView *view in scrollView.subviews) {
//            if ([view isKindOfClass:NSClassFromString(@"DZNEmptyDataSetView")]) {
//                UILabel *label = [view valueForKey:@"titleLabel"];
//                // 适配订单搜索界面
//                if ([label.text isEqualToString:kLStr(@"order_query_note")]) {
//                    label.textAlignment = NSTextAlignmentLeft;
//                    [label sizeToFit];
//                    label.centerX = scrollView.centerX;
//                }
//                
//                break;
//            }
//        }
//    }
//}

@end

@implementation EmptyModel

+ (instancetype)modelWithTitle:(NSAttributedString *)title image:(UIImage *)image buttonTitle:(NSString *)buttonTitle{
    EmptyModel *model = [[EmptyModel alloc] init];
    model.title = title;
    model.image = image;
    model.buttonTitle = buttonTitle;
    return model;
}

+ (instancetype)modelWithTitle:(NSAttributedString *)title image:(UIImage *)image{
    return [self modelWithTitle:title image:image buttonTitle:nil];
}

@end
