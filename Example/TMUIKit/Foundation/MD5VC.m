//
//  MD5VC.m
//  TMUIKitmui_Example
//
//  Created by cl w on 2021/2/1.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "MD5VC.h"
#import "NSString+MD5.h"

@interface MD5VC ()
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tf3;
@property (weak, nonatomic) IBOutlet UITextField *tf4;
@property (weak, nonatomic) IBOutlet UITextField *tf5;

@end

@implementation MD5VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)buton_1_click:(id)sender {
    _tf2.text = [_tf1.text tmui_getMd5_16Bit];
}
- (IBAction)buton_2_click:(id)sender {
    _tf3.text = [_tf1.text tmui_getMd5_16Bitmui_upperString];
}
- (IBAction)buton_3_click:(id)sender {
    _tf4.text = [_tf1.text tmui_getMd5_32Bit];
}
- (IBAction)buton_4_click:(id)sender {
    _tf5.text = [_tf1.text tmui_getMd5_32Bitmui_upperString];
}

@end
