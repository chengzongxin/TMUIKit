//
//  TMUIFilterView.m
//  Demo
//
//  Created by Joe.cheng on 2022/2/25.
//

#import "TMUIFilterView.h"
#import "TMUIFilterSectionHeader.h"
#import "TMUIFilterToolbar.h"
#import "TMUIFilterLeftAlignedLayout.h"

typedef enum : NSUInteger {
    TMUIFilterViewType_SingleSecioin,
    TMUIFilterViewType_MultiSecion,
} TMUIFilterViewType;

static UIEdgeInsets itemPadding = {0,15,0,15};
static CGFloat itemH = 36;
static CGFloat TMUIFilterToolBarHeight = 54;
static CGFloat TMUIFilterHeaderTitleHeight = 47;
static CGFloat TMUIFilterHeaderFullHeight = 72;

static CGFloat TMUIFilterOnlyHeaderTitleHeight = 44;
static CGFloat TMUIFilterOnlyHeaderFullHeight = 61;

@interface TMUIFilterView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TMUICustomCornerRadiusView *contentView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) TMUIFilterLeftAlignedLayout *leftAlignedLayout;

@property (nonatomic, strong) TMUIFilterToolbar *toolbar;

@property (nonatomic, strong) NSIndexPath *lastSelectIndexPath; // 记录最后一次选择，用于反选

@property (nonatomic, assign) TMUIFilterViewType type;

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
    _topInset = 0;
    _column = 3;
    _animateDuration = 0.3;
    _isAutoDismiss = YES;
    _allowsUnSelection = NO;
    _allowsMultipleSelection = NO;
    _lastSelectIndexPath = [NSIndexPath indexPathForItem:NSNotFound inSection:NSNotFound];
    _selectColor = UIColorHex(22C77D);
    _maxHeight = TMUI_SCREEN_HEIGHT - self.topInset;
    
    self.frame = CGRectMake(0, self.topInset, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - self.topInset);
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    [self addTarget:self action:@selector(tapCover:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupviews{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.toolbar];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(_maxHeight);
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
    if (_isAutoDismiss) {
        [self dismiss];
    }
}

- (void)resetClick{
    [self.collectionView tmui_clearsSelection];
}

- (void)tapCover:(TMUIFilterView *)control{
    if (_isAutoDismiss) {
        [self dismiss];
    }
    
    !_dismissBlock?:_dismissBlock(control);
}

#pragma mark - Public
#pragma mark - datas 数据源
/// 最好在所有的配置都设置完成后再设置数据源，因为设置数据源后就会刷新列表
- (void)setModels:(NSArray<TMUIFilterModel *> *)models{
    _models = models;
    if (models.count > 1 && _isForceSingleList == NO) {
        self.type = TMUIFilterViewType_MultiSecion;
        self.allowsMultipleSelection = YES;
        self.toolbar.hidden = NO;
        
        [self updateLayoutWhenMultiSection];
    }
    [self.collectionView reloadData];
    [self layoutIfNeeded];
    // 更新高度
    CGFloat contentH = [self contentLimitHeight];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentH);
    }];
    
    // 设置默认选中
    [models enumerateObjectsUsingBlock:^(TMUIFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.defalutItem != NSNotFound) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:obj.defalutItem inSection:idx] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }];
}

#pragma mark - config 数据驱动配置，修改后会影响筛选菜单UI布局
- (void)setColumn:(NSInteger)column{
    _column = column;
    
    if (_column == 0) {
        self.collectionView.collectionViewLayout = self.leftAlignedLayout;
    }
    [self.collectionView reloadData];
}


- (void)setTopInset:(CGFloat)topInset{
    _topInset = topInset;
    self.frame = CGRectMake(0, self.topInset, TMUI_SCREEN_WIDTH, TMUI_SCREEN_HEIGHT - self.topInset);
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    _allowsMultipleSelection = allowsMultipleSelection;
    _collectionView.allowsMultipleSelection = allowsMultipleSelection;
}


- (void)setMaxHeight:(CGFloat)maxHeight{
    _maxHeight = maxHeight;
    
    [self updateLayoutWhenMultiSection];
}

#pragma mark - config 纯UI配置
- (void)setContentInset:(UIEdgeInsets)contentInset{
    _contentInset = contentInset;
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(contentInset);
    }];
    
    [self updateLayoutWhenMultiSection];
}


#pragma mark - 接口方法
- (CGFloat)contentLimitHeight{
    CGFloat toolbarH = self.allowsMultipleSelection? TMUIFilterToolBarHeight : 0;
    CGFloat realH = UIEdgeInsetsGetVerticalValue(self.contentInset) + self.collectionView.contentSize.height + UIEdgeInsetsGetVerticalValue(self.collectionView.contentInset) + toolbarH;
    return MIN(realH, _maxHeight);
}


- (void)show{
    UIViewController *topVC = UIViewController.new.tmui_topViewController;
    [self showInView:topVC.view];
}

- (void)showInView:(UIView *)view{
    [self showInView:view animate:YES];
}

- (void)showInView:(UIView *)view animate:(BOOL)animate{
    [view addSubview:self];
    // Perform animations
    CGFloat contentH = [self contentLimitHeight];
    
    if (animate && self.animateDuration > 0) {
        // 某些场景下，会出现collectionView的动画效果，需要先渲染出collectionview，再做动画，避免collectionview里的动画
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentH);
        }];

        [self layoutIfNeeded];
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];

        [self layoutIfNeeded];

        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentH);
        }];
        
        self.alpha = 0;
        dispatch_block_t animations = ^{
            self.alpha = 1;
            [self layoutIfNeeded];
        };
        [UIView animateWithDuration:self.animateDuration delay:0.0 usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:nil];
    }else{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentH);
        }];
    }
}


- (void)dismiss{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animate{
    if (animate && self.animateDuration > 0) {
        self.contentView.disableDrawPathWhenLayoutSubviews = YES;
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        self.alpha = 1;
        dispatch_block_t animations = ^{
            self.alpha = 0;
            [self layoutIfNeeded];
        };
        [UIView animateWithDuration:self.animateDuration delay:0.0 usingSpringWithDamping:1.f initialSpringVelocity:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:^(BOOL finished) {
            self.contentView.disableDrawPathWhenLayoutSubviews = NO;
            [self removeFromSuperview];
        }];
    }else{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
        [self removeFromSuperview];
    }
}

- (BOOL)isShow{
    return self.superview;
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
    BOOL isOnlyHeader = self.models[section].isOnlySectionStyle;
    if (title.length > 0 && subtitle.length > 0) {
        headerH = isOnlyHeader ? TMUIFilterOnlyHeaderFullHeight : TMUIFilterHeaderFullHeight;
    }else if (title.length > 0) {
        headerH = isOnlyHeader ? TMUIFilterOnlyHeaderTitleHeight : TMUIFilterHeaderTitleHeight;
    }
    return CGSizeMake(collectionView.width, headerH);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        TMUIFilterSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(TMUIFilterSectionHeader.class) forIndexPath:indexPath];
        TMUIFilterModel *filterModel = self.models[indexPath.section];
        header.title = filterModel.title;
        header.subtitle = filterModel.subtitle;
        
        [header setSelected:filterModel.defalutSection];
        
        if (_isForceSingleList) {
            @TMUI_weakify(self);
            @TMUI_weakify(collectionView);
            [header tmui_addSingerTapWithBlock:^{
                @TMUI_strongify(self);
                @TMUI_strongify(collectionView);
                [self.models enumerateObjectsUsingBlock:^(TMUIFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.defalutSection = NO;
                }];
                
                self.models[indexPath.section].defalutSection = YES;
                
                // 刷新
                [collectionView reloadData];
                
                if (self.selectBlock) {
                    self.selectBlock(@[indexPath], nil);
                }
            }];
        }
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
    NSString *text = self.models[indexPath.section].items[indexPath.item].text;
    CGSize size = [self itemSizeWithText:text];
    return size;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TMUIFilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TMUIFilterCell class])
                                                                           forIndexPath:indexPath];
    cell.btn.tmui_text = self.models[indexPath.section].items[indexPath.item].text;
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
            if (_isAutoDismiss) {
                [self dismiss];
            }
        }
    }else{
        self.lastSelectIndexPath = indexPath;
        // 单选模式，直接回调
        if (self.allowsMultipleSelection == NO) {
            [self doCallBack];
            if (_isAutoDismiss) {
                [self dismiss];
            }
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
- (CGSize)itemSizeWithText:(NSString *)text{
    CGFloat width;
    if (self.column == 0) {
        width = [text tmui_sizeWithFont:UIFont(14) width:self.width].width + 13 * 2;
    }else{
        width = floor((TMUI_SCREEN_WIDTH - UIEdgeInsetsGetHorizontalValue(self.flowLayout.sectionInset) - (self.flowLayout.minimumInteritemSpacing * self.column - 1))/self.column);
    }
    return CGSizeMake(width, itemH);
}

- (void)doCallBack{
    // 设置排序优先级，并组成数组
    NSSortDescriptor *section = [NSSortDescriptor sortDescriptorWithKey:@"section" ascending:YES];
    NSArray<NSIndexPath *> *sortedArray = [self.collectionView.indexPathsForSelectedItems sortedArrayUsingDescriptors:@[section]];
    // 回调model
    NSMutableArray <TMUIFilterItemModel *> *selectedModels = [NSMutableArray array];
    // 回调cell
//    NSMutableArray <TMUIFilterCell *> *selectedCells = [NSMutableArray array];
    [sortedArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectedModels addObject:self.models[obj.section].items[obj.item]];
        // 这里回调cell可能为nil，如果选中cell滑出屏幕会被回收
//        [selectedCells addObject:(TMUIFilterCell *)[self.collectionView cellForItemAtIndexPath:obj]];
    }];
    !_selectBlock?:_selectBlock(sortedArray,selectedModels);
}


- (void)updateLayoutWhenMultiSection{
    if (self.type == TMUIFilterViewType_MultiSecion) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_maxHeight);
        }];
        
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-TMUIFilterToolBarHeight-_contentInset.bottom);
        }];
    }
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

- (TMUIFilterLeftAlignedLayout *)leftAlignedLayout{
    if (!_leftAlignedLayout) {
        _leftAlignedLayout = [[TMUIFilterLeftAlignedLayout alloc] init];
        _leftAlignedLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _leftAlignedLayout.minimumInteritemSpacing = 9;
        _leftAlignedLayout.minimumLineSpacing = 8;
        _leftAlignedLayout.sectionInset = itemPadding;
    }
    return _leftAlignedLayout;
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


@end
