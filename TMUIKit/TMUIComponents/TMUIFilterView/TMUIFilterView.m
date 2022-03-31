//
//  TMUIFilterView.m
//  Demo
//
//  Created by Joe.cheng on 2022/2/25.
//

#import "TMUIFilterView.h"
#import "TMUICustomCornerRadiusView.h"
#import "TMUIFilterSectionHeader.h"
#import "TMUIFilterToolbar.h"

static UIEdgeInsets itemPadding = {0,15,0,15};
static CGFloat itemH = 36;
static CGFloat TMUIFilterToolBarHeight = 54;
static CGFloat TMUIFilterHeaderFullHeight = 72;
static CGFloat TMUIFilterHeaderTitleHeight = 47;

@interface TMUIFilterView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TMUICustomCornerRadiusView *contentView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) TMUIFilterToolbar *toolbar;

@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath; // 记录最后一次选择，用于反选

@end

@implementation TMUIFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitalize];
        [self setupviews];
    }
    return self;
}

- (void)didInitalize{
    _topInset = NavigationContentTop;
    _column = 3;
    _allowsUnSelection = YES;
    _allowsMultipleSelection = NO;
    _lastSelectIndexPath = [NSIndexPath indexPathForItem:NSNotFound inSection:NSNotFound];
    _selectColor = UIColorHex(22C77D);
    
    self.frame = CGRectMake(0, self.topInset, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - self.topInset);
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupviews{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.toolbar];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(TMUI_SCREEN_HEIGHT);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(TMUIFilterToolBarHeight);
    }];
}

#pragma mark - Action

- (void)confirmClick{
    [self doCallBack];
    [self dismiss];
}

- (void)resetClick{
    [self.collectionView tmui_clearsSelection];
}

- (void)tapCover:(UITapGestureRecognizer *)tap{
    if ([tap locationInView:self].y > CGRectGetMaxY(self.contentView.frame)) {
        [self dismiss];
    }
}

#pragma mark - Public
- (void)show{
    UIViewController *topVC = UIViewController.new.tmui_topViewController;
    [topVC.view addSubview:self];
    // Perform animations
    CGFloat contentH = [self contentHeight];
    
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-contentH);
        make.height.mas_equalTo(contentH);
    }];
    
    
    [self layoutIfNeeded];
    
    dispatch_block_t animations = ^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
        
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:nil];
}

- (void)dismiss{
    CGFloat contentH = [self contentHeight];
    dispatch_block_t animations = ^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-contentH);
        }];
        
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:animations completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissWithoutAnimate{
    CGFloat contentH = [self contentHeight];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-contentH);
    }];
    [self layoutIfNeeded];
    [self removeFromSuperview];
}

- (BOOL)isShow{
    return self.superview;
}

- (void)setModels:(NSArray<TMUIFilterModel *> *)models{
    _models = models;
    if (models.count > 1) {
        self.allowsMultipleSelection = YES;
        self.toolbar.hidden = NO;
    }
    [self.collectionView reloadData];
    [self layoutIfNeeded];
    // 设置默认选中
    [models enumerateObjectsUsingBlock:^(TMUIFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.defalutItem != NSNotFound) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:obj.defalutItem inSection:idx] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }];
}

- (void)setTopInset:(CGFloat)topInset{
    _topInset = topInset;
    self.frame = CGRectMake(0, self.topInset, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - self.topInset);
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    _allowsMultipleSelection = allowsMultipleSelection;
    _collectionView.allowsMultipleSelection = allowsMultipleSelection;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.models.count;
}

#pragma mark headers
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSString *title = self.models[section].title;
    NSString *subtitle = self.models[section].subtitle;
    CGFloat headerH = 0;
    if (title.length > 0 && subtitle.length > 0) {
        headerH = TMUIFilterHeaderFullHeight;
    }else if (title.length > 0) {
        headerH = TMUIFilterHeaderTitleHeight;
    }
    return CGSizeMake(collectionView.width, headerH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        TMUIFilterSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(TMUIFilterSectionHeader.class) forIndexPath:indexPath];
        header.title = self.models[indexPath.section].title;
        header.subtitle = self.models[indexPath.section].subtitle;
        return header;
    } else if (kind == UICollectionElementKindSectionFooter) {
        return nil;
    }
    
    return nil;
}

#pragma mark items

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger i = self.models[section].items.count;
    return i;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [self itemSize];
    return size;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMUIFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TMUIFilterCell class])
                                                                           forIndexPath:indexPath];
    cell.btn.tmui_text = self.models[indexPath.section].items[indexPath.item];
    [cell.btn tmui_setNormalBackGroundColor:UIColorHex(F6F8F6) selectedBackGroundColor:self.selectColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowsUnSelection &&
        indexPath.section == self.lastSelectIndexPath.section &&
        indexPath.item == self.lastSelectIndexPath.item) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        self.lastSelectIndexPath = [NSIndexPath indexPathForItem:NSNotFound inSection:NSNotFound];
        
        // 如果是单选模式，立即回调
        if (self.allowsMultipleSelection == NO) {
            [self doCallBack];
            [self dismiss];
        }
    }else{
        self.lastSelectIndexPath = indexPath;
        // 单选模式，直接回调
        if (self.allowsMultipleSelection == NO) {
            [self doCallBack];
            [self dismiss];
        }else{
            // 多组多选模式，剔除同组其他选择
            NSArray<NSIndexPath *> *selectItems = collectionView.indexPathsForSelectedItems;
            for (NSIndexPath *idxP in selectItems) {
                //  设置每组只选一个
                if (idxP.section == indexPath.section && idxP.item != indexPath.item) {
                    [collectionView deselectItemAtIndexPath:idxP animated:NO];
                }
            }
        }
    }
}

#pragma mark - Private
- (CGSize)itemSize{
    CGFloat width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.flowLayout.sectionInset) - (self.flowLayout.minimumInteritemSpacing * self.column - 1))/self.column);
    return CGSizeMake(width, itemH);
}

- (CGFloat)contentHeight{
    CGFloat toolbarH = self.allowsMultipleSelection? TMUIFilterToolBarHeight : 0;
    return self.collectionView.contentSize.height + UIEdgeInsetsGetVerticalValue(self.collectionView.contentInset) + toolbarH;
}

- (void)doCallBack{
    // 设置排序优先级，并组成数组
    NSSortDescriptor *section = [NSSortDescriptor sortDescriptorWithKey:@"section" ascending:YES];
    NSArray<NSIndexPath *> *sortedArray = [self.collectionView.indexPathsForSelectedItems sortedArrayUsingDescriptors:@[section]];

    NSMutableArray <TMUIFilterCell *> *selectedCells = [NSMutableArray array];
    [sortedArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectedCells addObject:(TMUIFilterCell *)[self.collectionView cellForItemAtIndexPath:obj]];
    }];
    !_selectBlock?:_selectBlock(sortedArray,selectedCells);
}

#pragma mark - Getter && Setter

- (TMUICustomCornerRadiusView *)contentView{
    if (!_contentView) {
        _contentView = [[TMUICustomCornerRadiusView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.customCornerRadius = TMUICustomCornerRadiusMake(0, 0, 16, 16);
    }
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.allowsMultipleSelection = NO;
//        _collectionView.cornerRadius = 16;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        [_collectionView registerClass:TMUIFilterSectionHeader.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:NSStringFromClass(TMUIFilterSectionHeader.class)];
        [_collectionView registerClass:[TMUIFilterCell class]
            forCellWithReuseIdentifier:NSStringFromClass([TMUIFilterCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 9;
        _flowLayout.minimumLineSpacing = 8;
        _flowLayout.sectionInset = itemPadding;
    }
    return _flowLayout;
}

- (TMUIFilterToolbar *)toolbar{
    if (!_toolbar) {
        _toolbar = [[TMUIFilterToolbar alloc] init];
        _toolbar.hidden = YES;
        @TMUI_weakify(self);
        _toolbar.tapItem = ^(NSInteger index) {
            @TMUI_strongify(self);
            if (index == 0) {
                [self resetClick];
            }else if (index == 1) {
                [self confirmClick];
            }
        };
    }
    return _toolbar;
}

#pragma mark - Super

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *view = [super hitTest:point withEvent:event];
//
//    if (view == self) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self dismiss];
//        });
//    }
//
//    return view;
//}


//- (void)bindViewModel{
//    // 重设外部约束
//    
//    [self invalidateIntrinsicContentSize];
//    
//    [self.collectionView reloadData];
//}
//
//// 设置外部约束
//- (CGSize)intrinsicContentSize{
//    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//}
//
//- (CGSize)sizeThatFits:(CGSize)size{
//    CGSize fitSize = [super sizeThatFits:size];
//    return fitSize;
//}


@end
