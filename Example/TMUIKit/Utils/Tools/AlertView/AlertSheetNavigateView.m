//
//  AlertSheetNavigateView.m
//  Matafy
//
//  Created by Fussa on 2019/7/16.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "AlertSheetNavigateView.h"
#import "LGAlertView.h"


static const CGFloat kCancelButtonMargin = 6.f;
static const CGFloat kButtonHeight = 50.f;

static NSString* const kGaoDeURL = @"iosamap://";
static NSString* const kBaiDuURL = @"baidumap://";
static NSString* const kTencentURL = @"qqmap://";

@interface AlertSheetNavigateView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation AlertSheetNavigateView
+ (void)showAndNavigateWithToCoordinate:(CLLocationCoordinate2D)toCoordinate toName:(NSString *)toName actionHandle:(AlertSheetNavigateViewCompleteHandler)actionHandle cancelHandle:(AlertSheetNavigateViewCancelHandler)cancelHandle {
    [self showAndNavigateWithCoordinate:[User sharedInstance].currentCoordinate name:kLStr(@"common_navigation_my_location") toCoordinate:toCoordinate toName:toName actionHandle:actionHandle cancelHandle:cancelHandle];
}

+ (void)showAndNavigateWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *)name toCoordinate:(CLLocationCoordinate2D)toCoordinate toName:(NSString *)toName actionHandle:(AlertSheetNavigateViewCompleteHandler)actionHandle cancelHandle:(AlertSheetNavigateViewCancelHandler)cancelHandle {
    
    NSMutableArray *titles = [NSMutableArray array];
    // 高德地图导航
    if ([self mtfy_canOpenURL:kGaoDeURL]) {
        [titles addObject:kLStr(@"common_navigation_gaode")];
    }
    // 百度地图导航
    if ([self mtfy_canOpenURL:kBaiDuURL]) {
        [titles addObject:kLStr(@"common_navigation_baidu")];
    }
    // 腾讯地图导航
    if ([self mtfy_canOpenURL:kTencentURL]) {
        [titles addObject:kLStr(@"common_navigation_tencent")];
    }
    
    [titles addObject:kLStr(@"common_navigation_system")];
    
    AlertSheetNavigateView *alertView = [[AlertSheetNavigateView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.titles = titles;
    
    alertView.actionHandle = ^(NSInteger index, NSString * _Nullable title) {
        
        CLLocationCoordinate2D gdCoor = [LocationTransform transformFromBDToGD:coordinate];
        CLLocationCoordinate2D gdToCoor = [LocationTransform transformFromBDToGD:toCoordinate];
        
        // 跳高德导航
        if ([title isEqualToString:kLStr(@"common_navigation_gaode")]) {
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",
                                  gdCoor.latitude,
                                  gdCoor.longitude,
                                  name,
                                  gdToCoor.latitude,
                                  gdToCoor.longitude,
                                  toName]
                                 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [self mtfy_openURL:urlsting completionHandler:^(BOOL success) {
                if (actionHandle) {
                    actionHandle(success, title);
                }
            }];
        }
        
        // 跳百度导航
        else if ([title isEqualToString:kLStr(@"common_navigation_baidu")]) {
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:%@&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=bd09ll&src=%@",
                                  coordinate.latitude,
                                  coordinate.longitude,
                                  name,
                                  toCoordinate.latitude,
                                  toCoordinate.longitude,
                                  toName,
                                  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]]
                                 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [self mtfy_openURL:urlsting completionHandler:^(BOOL success) {
                if (actionHandle) {
                    actionHandle(success, title);
                }
            }];
        }
        
        // 跳腾讯地图
        else if ([title isEqualToString:kLStr(@"common_navigation_tencent")]) {
            NSString *urlsting =[[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=%@&fromcoord=%lf,%lf&to=%@&tocoord=%lf,%lf&referer=%@",
                                  name,
                                  gdCoor.latitude,
                                  gdCoor.longitude,
                                  toName,
                                  gdToCoor.latitude,
                                  gdToCoor.longitude,
                                  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]]
                                 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self mtfy_openURL:urlsting completionHandler:^(BOOL success) {
                if (actionHandle) {
                    actionHandle(success, title);
                }
            }];
        }
        
        // 跳系统导航
        else {
            
            MKMapItem *location = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gdCoor addressDictionary:nil]];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gdToCoor addressDictionary:nil]];
            location.name = name;
            toLocation.name = toName;
            BOOL success = [MKMapItem openMapsWithItems:@[location, toLocation]
                                          launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                                          MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            if (actionHandle) {
                actionHandle(success, title);
            }
        }
        
    };
    
    alertView.cancelHandle = ^{
        if (cancelHandle) {
            cancelHandle();
        }
    };
    
    [KEY_WINDOW addSubview:alertView];
    [alertView show];
}

//+ (LGAlertView *)setupAlertView:(NSArray<NSString *>*)titles actionHandle:(AlertSheetNavigateViewActionHandler)actionHandle cancelHandle:(AlertSheetNavigateViewCancelHandler)cancelHandle {
//    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil
//                                                        message:nil
//                                                          style:LGAlertViewStyleActionSheet
//                                                   buttonTitles:titles
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                                  actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
//                                                      if (actionHandle) {
//                                                          actionHandle(index, title);
//                                                      }
//                                                  } cancelHandler:^(LGAlertView * _Nonnull alertView) {
//                                                      if (cancelHandle) {
//                                                          cancelHandle();
//                                                      }
//                                                  } destructiveHandler:nil];
//
//    alertView.buttonsBackgroundColorHighlighted = [UIColor colorWithHexString:@"#D8D8D8"];
//    alertView.cancelButtonBackgroundColorHighlighted = [UIColor colorWithHexString:@"#D8D8D8"];
//    alertView.coverColor = [UIColor colorWithWhite:0 alpha: 0.5];
//    alertView.backgroundColor = [UIColor whiteColor];
//    alertView.buttonsHeight = 50.0;
//    alertView.width = [UIScreen mainScreen].bounds.size.width;
//    alertView.layerCornerRadius = 0;
//    alertView.offsetVertical = 6;
//    alertView.cancelButtonOffsetY = CGFLOAT_MIN;
//    alertView.separatorsColor = [UIColor colorWithHexString:@"#D8D8D8"];
//    alertView.buttonsFont = [UIFont pingFangSCMedium:17];
//    alertView.buttonsTitleColor = [UIColor colorWithHexString:@"#333333"];
//    alertView.cancelButtonTitleColor = [UIColor colorWithHexString:@"#333333"];
//    [alertView showAnimated:YES completionHandler:nil];
//    return alertView;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha: 0.5];
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.hidden = YES;
    tableView.backgroundColor= [UIColor colorWithHexString:@"#F7F9FC"];
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    CGFloat tableH = [self getTableH];
    self.tableView.frame = CGRectMake(0, self.height - tableH, self.width, tableH);
}

- (void)show {
    self.tableView.hidden = NO;
    self.tableView.y = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y = self.height - [self getTableH];
    }];
}


- (CGFloat)getTableH {
    return kButtonHeight * (self.titles.count + 1) + kCancelButtonMargin;
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.y = self.height;
    }];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        if (self.cancelHandle) {
            self.cancelHandle();
        }
        [self removeFromSuperview];
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont pingFangSCMedium:17];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    cell.backgroundColor = UIColor.whiteColor;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kButtonHeight - 0.5, self.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"##D8D8D8"];
    [cell.contentView addSubview:line];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.titles[indexPath.row];
    } else {
        cell.textLabel.text = kLStr(@"common_alert_cancel");
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 6;
    }
    return  CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.actionHandle) {
            self.actionHandle(indexPath.row, self.titles[indexPath.row]);
        }
    }
    [self dismiss];
}


@end
