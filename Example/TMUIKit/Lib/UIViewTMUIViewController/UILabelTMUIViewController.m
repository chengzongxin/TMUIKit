//
//  UILabelTMUIViewController.m
//  TMUIKit_Example
//
//  Created by Joe.cheng on 2021/1/23.
//  Copyright © 2021 chengzongxin. All rights reserved.
//

#import "UILabelTMUIViewController.h"

@interface UILabelTMUIViewController ()

@end

@implementation UILabelTMUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *linkAttr = @{NSUnderlineStyleAttributeName:@1,NSFontAttributeName:UIFont(20),NSForegroundColorAttributeName:UIColor.orangeColor};
    
    UILabel *label = [[UILabel alloc] tmui_initWithFont:UIFont(20) textColor:UIColor.orangeColor];
    label.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.text = @"春眠不觉晓，\n处处闻啼鸟，\n夜来风雨声，\n花落知多少。";
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.top.mas_equalTo(@100);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(@200);
    }];
    
    
    UILabel *tips = [[UILabel alloc] tmui_initWithFont:UIFont(15) textColor:UIColor.greenColor];
    [self.view addSubview:tips];
    tips.numberOfLines = 0;
    tips.text = @"可点击富文本 '春眠' '啼鸟' '风雨声' '花落知多少'\n,下面的内容可点击 '装修' '水真的很深' '能省点就省点' '地板'";
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@150);
        make.top.mas_equalTo(@100);
        make.right.mas_offset(0);
        make.height.mas_equalTo(@100);
    }];
    
    
    // 行间距
    [label tmui_addAttributeslineSpacing:10];
    // 指定富文本
    [label tmui_addAttributesText:@"春眠不觉晓，" color:UIColor.systemPinkColor font:UIFont(15)];
    [label tmui_addAttributesText:@"处处闻啼鸟，" color:UIColor.greenColor font:UIFont(15)];
    [label tmui_addAttributesText:@"夜来风雨声，" color:UIColor.systemPurpleColor font:UIFont(15)];
    [label tmui_addAttributesText:@"花落知多少。" color:UIColor.systemPurpleColor font:UIFont(15)];
    // 垂直偏移
    [label tmui_addAttributesLineOffset:0];
    // 加横线
    [label tmui_addAttributesLineSingle];
    // 设置可交互文字
    [label tmui_clickAttrTextWithStrings:@[@"春眠",@"啼鸟",@"风雨声",@"花落知多少"] attributes:linkAttr clickAction:^(NSString * _Nonnull string, NSRange range, NSInteger index) {
        NSLog(@"%@",string);
        [self showAlertSureWithTitle:string message:[NSString stringWithFormat:@"你点击了%@",string] sure:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",action);
        }];
    }];
    
    
    
    CGSize size = [label.text tmui_sizeForFont:label.font
                                          size:CGSizeMake(self.view.width, HUGE)
                                    lineHeight:label.tmui_attributeTextLineHeight
                                          mode:label.lineBreakMode];
    NSLog(@"size = %@",NSStringFromCGSize(size));
    
    CGSize attrSize = [label.attributedText tmui_sizeForWidth:self.view.width];
    NSLog(@"attrSize = %@",NSStringFromCGSize(attrSize));
    
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(attrSize);
    }];
    
    
    
    // online text
    UILabel *onlineLabel = [[UILabel alloc] tmui_initWithFont:UIFont(12) textColor:UIColor.lightTextColor];
    onlineLabel.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:onlineLabel];
    onlineLabel.numberOfLines = 0;
    onlineLabel.text = [self onlineText2];
    [onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).inset(20);
        make.top.equalTo(label.mas_bottom).offset(44);
        make.height.mas_equalTo(@500);
    }];
    
    [onlineLabel tmui_addAttributeslineSpacing:10];
    [onlineLabel tmui_addAttributesText:onlineLabel.text color:UIColor.tmui_randomColor font:UIFont(14)];
    
    
    CGSize size1 = [onlineLabel.text tmui_sizeForFont:onlineLabel.font
                                          size:CGSizeMake(self.view.width - 40, HUGE)
                                    lineHeight:onlineLabel.tmui_attributeTextLineHeight
                                          mode:onlineLabel.lineBreakMode];
    NSLog(@"size1 = %@",NSStringFromCGSize(size1));
    
    CGSize attrSize1 = [onlineLabel.attributedText tmui_sizeForWidth:self.view.width - 40];
    NSLog(@"attrSize1 = %@",NSStringFromCGSize(attrSize1));
    
    [onlineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(attrSize1.height);
    }];
    
    
    NSDictionary *linkAttr1 = @{NSUnderlineStyleAttributeName:@1,NSFontAttributeName:UIFont(13),NSForegroundColorAttributeName:UIColor.orangeColor};
    [onlineLabel tmui_clickAttrTextWithStrings:@[@"装修",@"水真的很深",@"能省点就省点",@"地板"] attributes:linkAttr1 clickAction:^(NSString * _Nonnull string, NSRange range, NSInteger index) {
        NSLog(@"%@",string);
        [self showAlertSureWithTitle:string message:[NSString stringWithFormat:@"你点击了%@",string] sure:^(UIAlertAction * _Nonnull action) {
            NSLog(@"%@",action);
        }];
    }];
    
}




- (NSString *)onlineText{
    return @"全屋家电🙋‍♀️90后装修必备家居电器清单📑\n🛒买房是一件很开心的事情，但后续的装修采购家电也是很头疼🤦‍♀️，买房子装修只是第一步，采购家电也是非常重要的环节，当初家里装修完成后，我也是不知道要买哪些家电，真的是很痛苦的一件事情，不过也总算过来了‼️所以今天就把自己认为装修时必入的家电整理好分享给大家了。\n🤫附加自用品牌+型号+价格，别忘了收藏哦~\n·\n📍浴室\n1.智能马桶：摩柏 型号：K4000 💰4688\n2.花洒：梦豚 型号：MT-9250EE 💰1188\n3.电热毛巾架：舒格尔 型号：501 💰1288\n4.浴室镜：尚格森 型号：高配版 💰638\n5.台上盆：卡雅森 型号：FX500+抽拉龙头 💰646\n6.浴霸：欧普 型号：TDSF115 💰339\n7.智能牙刷：丹乐 型号：白色 💰248\n·\n📍厨房\n1.集成灶：森歌 型号：T5B 💰8080\n2.洗碗机：西门子 型号：SC454B00AC 💰4999\n3.水槽：欧乐菱 型号：纳米 💰269\n4.冰箱：海尔 型号：BCD-572WDENU1 💰3499\n5.蒸烤箱：凯度 型号：SR56B-FD 💰4299\n6.电饭煲：苏泊尔 型号：SF40FC743 💰249\n7.破壁机：九阳 型号：JYL-Y99 💰299\n·\n📍客厅\n1.电视机：小米 型号：4A 💰1999\n2.立式空调：海尔 型号：KFR-72LW 💰399\n3.扫地机：云鲸 型号：YJCC001-1 💰4299\n4.吸尘器：戴森 型号：V8 Flffy 💰2790\n5.净化器：小米 型号：2S 💰699\n6.饮水机：北鼎 型号：S603 💰1198\n7.智能门铃：360 型号：D819 💰309\n·\n📍卧室\n1.投影仪：坚果 型号：G7S 💰2638\n2.挂烫机：飞利浦 型号：GC487 💰489\n3.吹风机：戴森 型号：HD03 💰2380\n4.加湿器：小熊 型号：JSQ-C50Q1 💰59\n5.落地灯：拾光记忆 型号：SG8015 💰178\n6.智能化妆镜：松下 型号：HHLT0626 💰199\n7.感应夜灯：小米 型号：白色 💰49\n·\n📍阳台\n1.滚筒洗衣机：小天鹅 型号：TG100VT26WIAD5💰2799\n2.烘干机：博世 型号：WTG86400W 💰5999\n3.壁挂洗衣机：小吉 型号：G1-MZB 💰2199\n4.电动晾衣架：好太太 型号：D-3111 💰1199\n5.挂烫机：苏泊尔 型号：GT18AP-20 💰198\n·\n💅总共3⃣️3⃣️款家电，踩雷的产品已经排除掉了，这些是我家亲测使用的，可以放心选购参考哦✌️";
}

- (NSString *)onlineText2{
    return @"装修这些点，足够坑你5⃣️万‼️\n👉现在建材市场水真的很深，很多建材商为了赚钱，老给客户推荐最贵的产品。但并不是什么都要买贵的，能省点就省点，毕竟现在挣钱也都不容易。我家装修被坑了好几万，现在总结一些经验给大家，希望大家在购买建材时要注意。\n1、地板\n2、涂料\n3、地砖\n4、灯具\n5、门类\n6、吊顶\n7、橱柜\n8、油烟机\n9、马桶\n10、地漏\n11、榻榻米\n12、燃气热水器\n13、环保问题\n👆以上的装修点在装修时一定要注意到哦👐\n👇以下是我家用了一年的家具好物，现在还是很好用，颜值也超好看，推荐给你们啦，有需要可以自行看哦‼️";
}

@end
