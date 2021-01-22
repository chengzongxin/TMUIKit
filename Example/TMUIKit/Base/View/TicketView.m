//
//  TicketView.m
//  Matafy
//
//  Created by Jason on 2018/6/4.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import "TicketView.h"
#import "UIView+Extension.h"

@interface TicketView ()

@property (weak, nonatomic) IBOutlet UITextField *departureTF;

@property (weak, nonatomic) IBOutlet UITextField *destinationTF;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation TicketView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [_departureTF setBorderForColor:[UIColor colorWithHexString:@"0xD9D9DD"] width:1 radius:6];
    [_destinationTF setBorderForColor:[UIColor colorWithHexString:@"0xD9D9DD"] width:1 radius:6];
    _departureTF.tintColor =[UIColor clearColor];
    _destinationTF.tintColor =[UIColor clearColor];
    
//    WEAK(weakSelf)
    @weakify(self);
    [[_departureTF rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [x resignFirstResponder];
        [self searchAction:nil];
    }];
    [[_destinationTF rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [x resignFirstResponder];
        [self searchAction:nil];
    }];
}

+ (instancetype)xibView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (IBAction)backAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
}

- (IBAction)searchAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchAction)]) {
        [self.delegate searchAction];
    }
}


- (void)setType:(int)type{
    _type = type;
    switch (type) {
        case 0:
        {
            _departureTF.placeholder = kLStr(@"h5_place_of_departure");
            _destinationTF.placeholder = kLStr(@"h5_destination");
            [_searchBtn setTitle:kLStr(@"h5_search_air_ticket") forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            _departureTF.placeholder = kLStr(@"h5_search_city");
            _destinationTF.placeholder = kLStr(@"h5_search_time");
            [_searchBtn setTitle:kLStr(@"h5_search_hotel") forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            _departureTF.placeholder = kLStr(@"h5_place_of_departure");
            _destinationTF.placeholder = kLStr(@"h5_destination");
            [_searchBtn setTitle:kLStr(@"h5_search_train_ticket") forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            _departureTF.placeholder = kLStr(@"h5_search_city");
            _destinationTF.placeholder = kLStr(@"h5_search_attractions_keyword");
            [_searchBtn setTitle:kLStr(@"h5_search_attractions") forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void)setTitles:(NSDictionary *)titles{
    _titles = titles;
    if (titles.allKeys.count < 3) {
        NSLog(@"titles = %@",titles);
        return;
    }
    _departureTF.text = titles[@"firstAdds"];
    _destinationTF.text = titles[@"endAdds"];
}


@end
