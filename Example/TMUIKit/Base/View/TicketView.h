//
//  TicketView.h
//  Matafy
//
//  Created by Jason on 2018/6/4.
//  Copyright © 2018年 com.upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketViewDelegate <NSObject>

- (void)backAction;

- (void)searchAction;

@end

@interface TicketView : UIView

+ (instancetype)xibView;

@property (nonatomic, weak) id <TicketViewDelegate> delegate;

@property (assign, nonatomic) int type;

@property (copy, nonatomic) NSDictionary *titles;

@end
