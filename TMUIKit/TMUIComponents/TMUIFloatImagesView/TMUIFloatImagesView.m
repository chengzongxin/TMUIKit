//
//  TMUIFloatImagesView.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/11/30.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "TMUIFloatImagesView.h"
#import <Masonry/Masonry.h>
#import <TMUICore/TMUICore.h>
#import <TMUIExtensions/NSMutableArray+TMUI.h>
//#define kMaxWidth  (TMUI_SCREEN_WIDTH - 15*2)

@interface TMUIFloatImagesCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *numberOfPicLabel;
@end

@implementation TMUIFloatImagesCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self TMUI_setupView];
    }
    return self;
}

- (void)TMUI_setupView {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.numberOfPicLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.numberOfPicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-8);
        make.size.mas_equalTo(CGSizeMake(38, 18));
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 2;
        _imageView.layer.masksToBounds = YES;
//        _imageView.backgroundColor = kDefaultImgBgColor;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)numberOfPicLabel{
    if (!_numberOfPicLabel) {
        _numberOfPicLabel = [[UILabel alloc] init];
        _numberOfPicLabel.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _numberOfPicLabel.textAlignment = NSTextAlignmentCenter;
        _numberOfPicLabel.textColor = UIColor.whiteColor;
        _numberOfPicLabel.font = UIFont(10);
        _numberOfPicLabel.layer.cornerRadius = 9;
        _numberOfPicLabel.layer.masksToBounds = YES;
    }
    return _numberOfPicLabel;
}

@end

@interface TMUIFloatImagesView ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TMUIFloatImagesViewModel *viewModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) CGFloat maxWidth;


@end

// Method override for the designated initializer of the superclass '-initWithCoder:' not found
BeginIgnoreClangWarning(-Wobjc-designated-initializers)

@implementation TMUIFloatImagesView


#pragma mark - Life Cycle
- (void)dealloc{
    NSLog(@"%@ did dealloc",self);
}

/// xib创建
//- (instancetype)initWithCoder:(NSCoder *)coder{
//    self = [super initWithCoder:coder];
//    if (self) {
//        [self didiniailze];
//    }
//    return self;
//}
//
///// init or initWithFrame创建
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self didiniailze];
//    }
//    return self;
//}

- (instancetype)initWithMaxWidth:(CGFloat)maxWidth{
    if (self = [super initWithFrame:CGRectZero]) {
        self.maxWidth = maxWidth;
        [self didiniailze];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    self.collectionView.frame = self.bounds;
//    if (self.viewModel.model.count && self.collectionView.visibleCells.count == 0) {
////        [self.collectionView reloadData];
//        [self bindViewModel];
//    }
}

- (void)didiniailze{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)bindViewModel:(TMUIFloatImagesViewModel *)viewModel{
    self.viewModel = viewModel;
    
    [self bindViewModel];
}

#pragma mark - Public
// initWithModel or bindViewModel: 方法来到这里
// MARK: 初始化,刷新数据和UI,xib,重新设置时调用
- (void)bindViewModel{
    // 重设外部约束
    [self invalidateIntrinsicContentSize];
    
    self.flowLayout.minimumLineSpacing = self.viewModel.minimumLineSpacing;
    self.flowLayout.minimumInteritemSpacing = self.viewModel.minimumInteritemSpacing;
    
    if (self.superview) {
        CGSize size = [self sizeThatFits:CGSizeMax];
        // 需要内部先刷新size，否则会有item>collectionView的警告
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
    }
    
    [self.collectionView reloadData];
    // 这里必须强制渲染collectionview，因为在cell会重用，导致不渲染不调用cellforrow
    [self.collectionView layoutIfNeeded];
}


- (UIImageView *)imageViewAtIndex:(NSInteger)index{
    TMUIFloatImagesCell *cell = (TMUIFloatImagesCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.imageView;
}
// 设置外部约束
- (CGSize)intrinsicContentSize{
    return [self sizeThatFits:CGSizeMake(self.maxWidth, CGFLOAT_MAX)];
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize fitSize = [super sizeThatFits:CGSizeMake(self.maxWidth, size.height)];
    CGSize itemSize = [self SizeForItemThatFits];
    if (itemSize.width == 0 || itemSize.height == 0) {
        return CGSizeZero;
    }
    // 计算行数和列数
    NSInteger count = MIN(self.viewModel.model.count,self.viewModel.maxShowNum);
    NSInteger row = count / 3 + (count % 3 > 0);
    NSInteger column = MIN(count, 3);
    // 计算总行高、列高
    CGFloat width = itemSize.width * column + self.flowLayout.minimumInteritemSpacing * (column - 1);
    CGFloat height = itemSize.height * row + self.flowLayout.minimumLineSpacing * (row - 1);
    
    fitSize = CGSizeMake(width, height);
    
    return fitSize;
}

+ (CGFloat)imagesViewHeightFor:(TMUIFloatImagesViewModel *)viewModel maxWidth:(CGFloat)width{
    
    TMUIFloatImagesView *imgsView = [[TMUIFloatImagesView alloc] initWithMaxWidth:width];
    [imgsView bindViewModel:viewModel];
    CGSize size = [imgsView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return size.height;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.viewModel.model.count, self.viewModel.maxShowNum);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self SizeForItemThatFits];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMUIFloatImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TMUIFloatImagesCell class])
                                                                           forIndexPath:indexPath];
    TMUIFloatImageModel *imgModel = self.viewModel.model[indexPath.item];
//    [cell.imageView loadImageWithUrlStr:imgModel.thumbnailUrl];
    !_loadImage?:_loadImage(cell.imageView,imgModel);// 外部实现
    
    BOOL showNum = self.viewModel.showNumLabel;
    NSInteger imgNum = self.viewModel.imageNum;
    NSInteger maxNum = self.viewModel.maxShowNum;
    NSInteger imgCorner = self.viewModel.itemCornerRadius;
    cell.imageView.layer.cornerRadius = imgCorner;
    cell.imageView.layer.masksToBounds = YES;
    // 设置最后一个标签
    if (showNum && imgNum > maxNum && indexPath.item == maxNum - 1) {
        cell.numberOfPicLabel.hidden = NO;
        cell.numberOfPicLabel.text = [NSString stringWithFormat:@"%zd图",imgNum];
    }else{
        cell.numberOfPicLabel.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickImage) {
        // 设置排序优先级，并组成数组
        
        NSMutableArray *imgs = [NSMutableArray array];
        NSSortDescriptor *itemSort = [NSSortDescriptor sortDescriptorWithKey:@"item" ascending:YES];
        NSArray<NSIndexPath *> *visibleIndexPath = [collectionView.indexPathsForVisibleItems sortedArrayUsingDescriptors:@[itemSort]];
        [visibleIndexPath enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TMUIFloatImagesCell *cell = (TMUIFloatImagesCell *)[collectionView cellForItemAtIndexPath:obj];
            [imgs tmui_safeAddObject:cell.imageView];
        }];
        self.clickImage(indexPath.item,collectionView.indexPathsForVisibleItems,imgs);
    }
}

#pragma mark - Private

- (CGSize)SizeForItemThatFits{
    CGSize fitSize = CGSizeZero;
    NSArray <TMUIFloatImageModel *> *imgs = self.viewModel.model;
    CGFloat kItemWidth = [self itemWidthForContentWidth:self.maxWidth];
    switch (imgs.count) {
        case 0:
        {
            // 由于cell的复用机制，设为0会不走collectionView的代理方法，不刷新UI
            fitSize = CGSizeZero;
        }
            break;
        case 1:
        {
            TMUIFloatImageModel *item = imgs.firstObject;
            CGFloat width = kItemWidth*2 + _flowLayout.minimumLineSpacing;
            // w : x = imgW : imgH
            if (item.imageWidth == 0 || item.imageHeight == 0) {
                fitSize.width = kItemWidth;
                fitSize.height = kItemWidth;
            }else{
                fitSize.width = width;
                fitSize.height = item.imageHeight * width / item.imageWidth;
            }
        }
            break;
        default:
        {
            fitSize = CGSizeMake(kItemWidth, kItemWidth);
        }
            break;
    }
    return CGSizeFloor(fitSize);
}

- (CGFloat)itemWidthForContentWidth:(CGFloat)contentWidth{
    // cell刚渲染的时候，imagesView刚加载，此时width是0，需要给一个宽度，计算
//    CGFloat width = contentWidth?:self.maxWidth;
//    CGFloat width = self.maxWidth;
    return (contentWidth - self.flowLayout.minimumInteritemSpacing * 2) / 3;
}

#pragma mark - Getter && Setter
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[TMUIFloatImagesCell class]
            forCellWithReuseIdentifier:NSStringFromClass([TMUIFloatImagesCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 8;
        _flowLayout.minimumLineSpacing = 8;
    }
    
    return _flowLayout;
}

@end

EndIgnoreClangWarning
