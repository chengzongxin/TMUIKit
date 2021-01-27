//
//  UITableView+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "UITableView+TMUI.h"

@implementation UITableView (TMUI)

- (NSUInteger)indexOfIndexPath:(NSIndexPath *)indexPath {
    if (!self.dataSource) {
        return 0;
    }
    NSUInteger index = 0;
    NSUInteger sectionIndex = indexPath.section;
    
    for (int i=0; i<sectionIndex; i++) {
        NSUInteger sectionRowsCount = [self.dataSource tableView:self numberOfRowsInSection:i];
        index += sectionRowsCount;
    }
    
    index += indexPath.row;
    
    return index;
}

- (NSIndexPath *)indexPathOfIndex:(NSUInteger)index {
    if (!self.dataSource) {
        return nil;
    }
    NSUInteger sectionIndex = 0;
    while ([self.dataSource tableView:self numberOfRowsInSection:sectionIndex]<=index) {
        index -= [self.dataSource tableView:self numberOfRowsInSection:sectionIndex];
        sectionIndex ++;
    }
    return [NSIndexPath indexPathForRow:index inSection:sectionIndex];
}

@end


@implementation UITableView (TNib)

- (void)registerNibClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cellClass) bundle:[NSBundle bundleForClass:cellClass]];
    [self registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)registerNibIdentifierNSStringFromClass:(Class)cellClass {
    [self registerNibClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

@end


@implementation UITableView (TRegisterCell)

- (void)registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier {
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:NSClassFromString(nibName)]];
    [self registerNib:nib forCellReuseIdentifier:identifier];
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                         initWithClass:(Class)cellClass
                                                 Style:(UITableViewCellStyle)style {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:style reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                         initWithClass:(Class)cellClass {
   UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier
                                                     initWithClass:cellClass
                                                             Style:UITableViewCellStyleDefault];
    return  cell;
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                   initWithClassString:(NSString *)classString
                                                 Style:(UITableViewCellStyle)style {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(classString) alloc] initWithStyle:style reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSAssert(cell!=nil, @"className不存在");
    return cell;
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                   initWithClassString:(NSString *)classString {
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier
                                                initWithClassString:classString
                                                              Style:UITableViewCellStyleDefault];
    return cell;
}

@end

