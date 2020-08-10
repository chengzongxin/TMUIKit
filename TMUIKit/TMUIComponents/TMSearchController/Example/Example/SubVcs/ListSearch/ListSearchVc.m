//
//  ListSearchVc.m
//  SearchVcTest
//
//  Created by nigel.ning on 2020/8/5.
//  Copyright © 2020 t8t. All rights reserved.
//

#import "ListSearchVc.h"
#import "ListSearchingVc.h"

@interface ListSearchVc ()

@end

@implementation ListSearchVc

- (instancetype)initWithSearchingController:(UIViewController<TMSearchingControllerProtocol> *)searchingController {
    self = [super initWithSearchingController:searchingController];
    if (self) {
        if ([searchingController isKindOfClass:[ListSearchingVc class]]) {
            @TMUI_weakify(self);
            [(ListSearchingVc*)searchingController setReSearchBlock:^(NSString * _Nonnull toSearchStr) {
                @TMUI_strongify(self);
                self.searchBar.text = toSearchStr;
            }];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *v = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    [v setTitle:@"测试自定义初始状态的子视图" forState:UIControlStateNormal];
    v.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
}

@end
