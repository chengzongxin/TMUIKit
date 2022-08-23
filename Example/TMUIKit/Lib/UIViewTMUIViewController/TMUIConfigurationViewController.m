//
//  TMUIConfigurationViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2022/4/26.
//  Copyright © 2022 chengzongxin. All rights reserved.
//

#import "TMUIConfigurationViewController.h"

@interface TMUIConfigurationViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TMUIOrderedDictionary *dataSource;

@end

@implementation TMUIConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[TMUIOrderedDictionary alloc] init];
    
    [self.view addSubview:self.tableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[TMUIConfiguration sharedInstance] tmui_enumratePropertiesUsingBlock:^(objc_property_t  _Nonnull property, NSString * _Nonnull propertyName) {
            TMUIPropertyDescriptor *proDes = [TMUIPropertyDescriptor descriptorWithProperty:property];
            if (proDes.isStrong && [proDes.name.lowercaseString containsString:@"color"]) {
                UIColor *color = [[TMUIConfiguration sharedInstance] tmui_valueForKey:proDes.name];
    //            [TMUIConfiguration.sharedInstance tmui_performSelector:NSSelectorFromString(proDes.name) withPrimitiveReturnValue:&color]; // 这个方法会崩溃
                if ([color isKindOfClass:UIColor.class]) {
                    [self.dataSource addObject:color forKey:proDes.name];
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self isViewLoaded]) {
                [self.tableView reloadData];
            }
        });
    });
}




#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataSource.allKeys[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TMUITableViewCell alloc] initForTableView:tableView withStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    UIColor *color = self.dataSource[indexPath.section];
    
    cell.imageEdgeInsets = UIEdgeInsetsZero;
    cell.textLabelEdgeInsets = UIEdgeInsetsZero;
    cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    cell.accessoryEdgeInsets = UIEdgeInsetsZero;
    cell.detailTextLabel.font = UIFont(12);
    
    cell.imageView.image = [UIImage tmui_imageWithShape:TMUIImageShapeOval size:CGSizeMake(60, 60) tintColor:color];
    cell.textLabel.text = self.dataSource.allKeys[indexPath.section];
    NSString *rgba = [NSString stringWithFormat:@"(%.0f,%.0f,%.0f,%.1f)",color.tmui_red*255,color.tmui_green*255,color.tmui_blue*255,color.tmui_alpha];
    NSString *hex = [[NSString stringWithFormat:@"#%1x%1x%1x",(int)(color.tmui_red*255),(int)(color.tmui_green*255),(int)(color.tmui_blue*255)] uppercaseString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RGBA:%@, HEX:%@",rgba,hex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:TMUITableViewStyleInsetGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
//        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(TMUITableViewCell.class)];
    }
    return _tableView;
}

- (void)color1{
    id s1 = Style().fixWH(44,44).borderRadius(22);
    id s2 = Style().fnt(14).color(UIColorGreen).multiline;
    // origin
    id v1 = View.styles(s1).bgColor(UIColorGreen);
    id a1 = AttStr(
                   AttStr(Str(@"UIColorGreen")).styles(s1),
                   AttStr(Str(@"\n小面积使用，用于特别需要强调的文字、按钮和图标")).styles(body)
                   ).lineGap(3);
    id l1 = Label.styles(s2).str(a1);
    // origin
    id v2 = View.styles(s1).bgColor(UIColorTextImportant);
    id a2 = AttStr(
                   AttStr(Str(@"UIColorTextImportant")).styles(s1),
                   AttStr(Str(@"\n用于重要级文字信息，页内标题信息")).styles(body)
                   ).lineGap(3);
    id l2 = Label.styles(s2).str(a2);
    // origin
    id v3 = View.styles(s1).bgColor(UIColorTextRegular);
    id a3 = AttStr(
                   AttStr(Str(@"UIColorTextRegular")).styles(s1),
                   AttStr(Str(@"\n用于一般文字信息，正文或常规文字")).styles(body)
                   ).lineGap(3);
    id l3 = Label.styles(s2).str(a3);
    // origin
    id v4 = View.styles(s1).bgColor(UIColorTextWeak);
    id a4 = AttStr(
                   AttStr(Str(@"UIColorTextWeak")).styles(s1),
                   AttStr(Str(@"\n用于辅助、次要、弱提示类的文字信息")).styles(body)
                   ).lineGap(3);
    id l4 = Label.styles(s2).str(a4);
    // origin
    id v5 = View.styles(s1).bgColor(UIColorTextPlaceholder);
    id a5 = AttStr(
                   AttStr(Str(@"UIColorTextPlaceholder")).styles(s1),
                   AttStr(Str(@"\n用于占位文字")).styles(body)
                   ).lineGap(3);
    id l5 = Label.styles(s2).str(a5);
    
    
    id scrollView = [UIScrollView new].embedIn(self.view);
    VerStack(HorStack(v1,l1).gap(20),
             HorStack(v2,l2).gap(20),
             HorStack(v3,l3).gap(20),
             HorStack(v4,l4).gap(20),
             HorStack(v5,l5).gap(20),
             ).gap(44).embedIn(scrollView, 20, 20, 80);
    
}

@end
