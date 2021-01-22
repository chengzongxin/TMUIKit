//
//  MTFYDisclaimerSectionController.m
//  Matafy
//
//  Created by Fussa on 2019/12/25.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYDisclaimerSectionController.h"

#define kTitleFont          [UIFont pingFangSCRegular:11]
#define kTitleColor         [UIColor colorWithHexString:@"#8A98AD"]
#define kBackgroundColor    [UIColor whiteColor]
#define kInsets             UIEdgeInsetsMake(20, 20, 20, 20)

#pragma mark - MTFYDisclaimerSectionController
@interface MTFYDisclaimerSectionController () <IGListBindingSectionControllerDataSource>

@end

@implementation MTFYDisclaimerSectionController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.inset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (UICollectionViewCell <IGListBindable> *)sectionController:(IGListBindingSectionController *)sectionController cellForViewModel:(id)viewModel atIndex:(NSInteger)index {
    return [self.collectionContext dequeueReusableCellOfClass:[MTFYDisclaimerCollectionViewCell class] forSectionController:self atIndex:index];
}

- (CGSize)sectionController:(IGListBindingSectionController *)sectionController sizeForViewModel:(id)viewModel atIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, [self fetchCellHeightWithModel:viewModel]);
}

- (NSArray<id <IGListDiffable>> *)sectionController:(IGListBindingSectionController *)sectionController viewModelsForObject:(id)object {
    if (!object) {
        return @[];
    }
    return @[object];
}

- (CGFloat)fetchCellHeightWithModel:(id)model {
    if ([model isKindOfClass:[MTFYDisclaimerModel class]]) {
        MTFYDisclaimerModel *dModel = (MTFYDisclaimerModel *)model;
        return [dModel.title mtfy_heightWithFont:dModel.titleFont maxWidth:KScreenW - (dModel.insets.left + dModel.insets.right)] + dModel.insets.top + dModel.insets.bottom;
    } else if ([model isKindOfClass:[NSString class]]) {
        return [((NSString *)model) mtfy_heightWithFont:kTitleFont maxWidth:KScreenW - (kInsets.left + kInsets.right)] + kInsets.top + kInsets.bottom;
    }
    return 0;
}

@end


#pragma mark - MTFYDisclaimerCollectionViewCell
@interface MTFYDisclaimerCollectionViewCell()
@property (nonatomic, strong) UILabel *label;
@end

@implementation MTFYDisclaimerCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.label];
    self.backgroundColor = [UIColor clearColor];
}

-(void)bindViewModel:(id)viewModel {
    MTFYDisclaimerModel *model = [MTFYDisclaimerModel new];
    if ([viewModel isKindOfClass:[NSString class]]) {
        model.title = viewModel;
    } else if ([viewModel isKindOfClass:[MTFYDisclaimerModel class]]) {
        model = viewModel;
    }
    
    self.backgroundColor = model.backgroundColor;
    self.label.textColor = model.titleColor;
    self.label.font = model.titleFont;
    self.label.text = model.title;
    self.label.textAlignment = model.textAlignment;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(model.insets);
    }];
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
    }
    return _label;
}

@end


#pragma mark - MTFYDisclaimerModel

@implementation MTFYDisclaimerModel

- (id <NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(NSObject <IGListDiffable> *)object {
    if (object != self) {
        return NO;
    } else if (![object isKindOfClass:[MTFYDisclaimerModel class]]) {
        return NO;
    } else {
        MTFYDisclaimerModel *model = (MTFYDisclaimerModel *) object;
        if (![self.title isEqualToString:model.title]) {
            return NO;
        }
        return [self isEqual:object];
    }
}


- (UIColor *)backgroundColor {
    if (!_backgroundColor) {
        _backgroundColor = kBackgroundColor;
    }
    return _backgroundColor;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = kTitleColor;
    }
    return _titleColor;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = kTitleFont;
    }
    return _titleFont;
}

- (UIEdgeInsets)insets {
    if (!_customInset) {
        _insets = kInsets;
    }
    return _insets;
}

@end

