//
//  MTFYNetworkCenter.m
//  Matafy
//
//  Created by Tiaotiao on 2019/3/23.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYNetworkCenter.h"
#import <CoreTelephony/CTCellularData.h>

@interface MTFYNetworkCenter()

@property (nonatomic, strong) CTCellularData *cellularData;

@property (nonatomic, strong) Reachability *reach;
@property (nonatomic, assign, readwrite) NSInteger currentNetworkStatus;

@property (nonatomic, strong) NSMutableDictionary<NSString *, EnableBlock> *authorBlock;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NetworkStatusBlock> *netStatusBlock;

@end;

@implementation MTFYNetworkCenter

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (MTFYNetworkCenter *)shareInstance {
    static MTFYNetworkCenter *observer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observer = [[MTFYNetworkCenter alloc] init];
    });
    return observer;
}

- (instancetype)init {
    if (self = [super init]) {
        // 监测网络情况
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        self.currentNetworkStatus = -1;
        self.reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [self.reach startNotifier];
        
        // 网络授权状态监听
        __weak typeof(self) weakSelf = self;
        self.cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            for (EnableBlock block in weakSelf.authorBlock.objectEnumerator.allObjects) {
                switch (state) {
                    case kCTCellularDataRestrictedStateUnknown:
                        if (block) {
                            block(NO);
                        }
                        break;
                    case kCTCellularDataRestricted:
                        if (block) {
                            block(isHaveNetwork);
                        }
                        break;
                    case kCTCellularDataNotRestricted:
                        if (block) {
                            block(YES);
                        }
                        break;
                }
            }
        };
    }
    return self;
}

#pragma mark - Public

- (BOOL)checkNetworkIsConnected
{
    return self.currentNetworkStatus > 0;
}

- (void)checkCellualrDataEnableBlock:(EnableBlock)block {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        do {
            [NSThread sleepForTimeInterval:0.5];
        } while (self.cellularData.restrictedState == kCTCellularDataRestrictedStateUnknown);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(self.cellularData.restrictedState == kCTCellularDataNotRestricted || isHaveNetwork);
            }
        });
    });
}

- (void)addCellualrDataAuthorObserver:(NSObject *)observer
                                block:(nullable EnableBlock)block {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        return;
    }
    if (!observer || !block) {
        return;
    }
    [self.authorBlock setObject:block forKey:[NSString stringWithFormat:@"%@",@(observer.hash)]];
}

- (void)removeCellualrDataAuthorObserver:(NSObject *)observer {
    [self.authorBlock removeObjectForKey:[NSString stringWithFormat:@"%@",@(observer.hash)]];
}

- (void)checkNetworkEnableBlock:(nullable EnableBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        do {
            [NSThread sleepForTimeInterval:0.5];
        } while (self.currentNetworkStatus == -1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(self.currentNetworkStatus);
            }
        });
    });
}

- (void)addNetworkReachabilityStatusObserver:(NSObject *)observer
                                       block:(nullable NetworkStatusBlock)block {
    if (!observer || !block) {
        return;
    }
    
    [self.netStatusBlock setObject:block forKey:[NSString stringWithFormat:@"%@",@(observer.hash)]];
}

- (void)removeNetworkReachabilityStatusObserver:(NSObject *)observer {
    [self.netStatusBlock removeObjectForKey:[NSString stringWithFormat:@"%@",@(observer.hash)]];
}

- (BOOL)connectionRequired {
    return self.reach.connectionRequired;
}

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    if (curReach.currentReachabilityStatus == self.currentNetworkStatus) {
        return;
    }
    
    self.currentNetworkStatus = curReach.currentReachabilityStatus;
    for (NetworkStatusBlock block in self.netStatusBlock.objectEnumerator.allObjects) {
        if (block) {
            block(curReach.currentReachabilityStatus);
        }
    }
}

#pragma mark - Getters and Setters

- (CTCellularData *)cellularData {
    if (!_cellularData) {
        _cellularData = [[CTCellularData alloc] init];
    }
    return _cellularData;
}

- (NSMutableDictionary<NSString *, EnableBlock> *)authorBlock
{
    if (!_authorBlock) {
        _authorBlock = [NSMutableDictionary dictionary];
    }
    return _authorBlock;
}

- (NSMutableDictionary<NSString *,NetworkStatusBlock> *)netStatusBlock {
    if (!_netStatusBlock) {
        _netStatusBlock = [NSMutableDictionary dictionary];
    }
    return _netStatusBlock;
}

#pragma mark - Supperclass

#pragma mark - NSObject

@end
