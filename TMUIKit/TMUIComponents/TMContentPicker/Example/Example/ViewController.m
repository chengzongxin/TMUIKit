//
//  ViewController.m
//  Example
//
//  Created by nigel.ning on 2020/4/14.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ViewController.h"
#import "TMContentPicker.h"
#import "TMDatePicker.h"
#import "TMCityPicker.h"
#import "TMNormalPicker.h"
#import "TMMultiDataPicker.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = @[
        @{@"title": @"基础picker测试", @"class": TMContentPicker.class},
        @{@"title": @"普通picker测试", @"class": TMNormalPicker.class},
        @{@"title": @"日期picker测试", @"class": TMDatePicker.class},
        @{@"title": @"城市picker测试", @"class": TMCityPicker.class},
        @{@"title": @"多列数据picker测试", @"class": TMMultiDataPicker.class}
    ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCell"];
    cell.textLabel.text = self.dataSource[indexPath.item][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class cls = self.dataSource[indexPath.item][@"class"];
    if ([cls isEqual:TMContentPicker.class]) {
        [self basicContentPickerTest];
    }else if ([cls isEqual:TMNormalPicker.class]) {
        [self normalPickerTest];
    }else if ([cls isEqual:TMDatePicker.class]) {
        [self datePickerTest];
    }else if ([cls isEqual:TMMultiDataPicker.class]) {
        [self multiDataPickerTest];
    }else if ([cls isEqual:TMCityPicker.class]) {
        [self cityPickerTest];
    }
}

- (void)basicContentPickerTest {
    TMContentPicker *picker = [TMContentPicker pickerView];
    UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TMUI_SCREEN_WIDTH, 100)];
    contentV.clipsToBounds = YES;
    UIView *subV = [[UIView alloc] initWithFrame:contentV.bounds];
    [contentV addSubview:subV];
    [subV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    subV.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    picker.contentView = contentV;
    picker.title = @"基础picker测试";
    [picker showFromViewController:self];
}

- (void)normalPickerTest {
    [TMNormalPicker showPickerWithTitle:@"普通picker测试" itemListBlock:^NSArray * _Nonnull{
        return @[@"清包（预算最低，只包施工）",
                 @"全包（省时省力，包施工和所有材料）",
                 @"半包（大众首选，包施工和辅材）"];
    } fetchShowStringFromItem:^NSString * _Nonnull(id  _Nonnull item, NSInteger idx) {
        return item;
    } finishSelectBlock:^(id  _Nonnull item, NSInteger idx) {
        NSLog(@"select item: %@", item);
    } curItemIndex:1 fromViewController:self];
}

- (void)datePickerTest {
    [TMDatePicker showPickerWithTitle:@"日期picker测试" mode:TMDatePickerModeDate limitMinDate:nil limitMaxDate:nil currentDate:nil finishSelectBlock:^(NSDate * _Nonnull selectedDate) {
        NSLog(@"select date: %@", selectedDate);
    } fromViewController:self];
}

- (void)multiDataPickerTest {
    NSArray *rooms = @[@"一室", @"两室", @"三室", @"四室", @"五室"];
    NSArray *tings = @[@"一厅", @"两厅", @"三厅"];
    NSArray *cookRooms = @[@"一厨", @"两厨", @"三厨"];
    NSArray *bashRooms = @[@"一卫", @"两卫", @"三卫", @"四卫"];
    NSArray<NSArray *> *dataSource = @[rooms, tings, cookRooms, bashRooms];
    
    [TMMultiDataPicker showPickerWithTitle:@"多列数据picker测试" numberOfColumnsBlock:^NSInteger{
        return dataSource.count;
    } itemListAtColumnBlock:^NSArray * _Nonnull(NSInteger columnIndex) {
        return dataSource[columnIndex];
    } fetchShowStringFromItem:^NSString * _Nonnull(id  _Nonnull item, NSInteger columnIndex, NSInteger rowIndex) {
        return item;
    } finishSelectBlock:^(NSArray * _Nonnull selectedItems, NSArray<NSNumber *> * _Nonnull selectedRowIndexs) {
        NSLog(@"select items:%@ \n selectedIndex:%@", selectedItems, selectedRowIndexs);
    } curItemRowIndexs:@[@(2), @(0), @(0), @(2)] fromViewController:self];
}

- (void)cityPickerTest {
    NSArray *provinces = @[@"湖北", @"湖南", @"广东"];
    NSArray *citysList = @[
        @[@"荆州", @"武汉", @"襄阳", @"咸宁", @"潜江", @"黄岗", @"黄梅"],
        @[@"长沙", @"益阳", @"岳阳"],
        @[@"深圳", @"惠州", @"广州", @"揭阳", @"东莞", @"樟木头"]
    ];
    [TMCityPicker showPickerWithTitle:@"日期picker测试" provinceItemListBlock:^NSArray * _Nullable{
        return provinces;
    } cityItemListAtProvinceBlock:^NSArray * _Nullable(id  _Nonnull provinceItem, NSInteger provinceIndex) {
        return citysList[provinceIndex];
    } fetchShowStringForProvinceItem:^NSString * _Nullable(id  _Nonnull provinceItem, NSInteger provinceIndex) {
        return provinceItem;
    } fetchShowStringForCityItem:^NSString * _Nullable(id  _Nonnull cityItem, NSInteger cityIndex, id  _Nonnull inProvinceItem, NSInteger provinceIndex) {
        return cityItem;
    } finishSelectBlock:^(id  _Nonnull selectedProvinceItem, NSInteger selectedProvinceIndex, id  _Nonnull selectedCityItem, NSInteger selectedCityIndex) {
        NSLog(@"select province: %@, city: %@", selectedProvinceItem, selectedCityItem);
    } curProvinceItemIndex:2 curCityItemIndex:2 fromViewController:self];
}

@end
