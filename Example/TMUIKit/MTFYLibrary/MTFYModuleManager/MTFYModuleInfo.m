//
//  MTFYModuleInfo.m
//  Matafy
//
//  Created by Tiaotiao on 2019/5/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import "MTFYModuleInfo.h"
#import "MTFYModuleProtocol.h"

@interface MTFYModuleInfo ()

@property (nonatomic, assign, readwrite) NSTimeInterval registerTimestamp;

@property (nonatomic, copy, readwrite) NSString *moduleName;

@property (nonatomic, strong, readwrite) id<MTFYModuleBaseProtocol> moduleInstance;

@property (nonatomic, assign, readwrite) MTFYModuleLevel level;

@end

@implementation MTFYModuleInfo

#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

- (instancetype)initWithModuleName:(NSString *)moduleName
{
    self = [super init];
    if (self) {
        self.registerTimestamp = [[NSDate date] timeIntervalSince1970];
        self.moduleName = moduleName;
        
        Class moduleClass = NSClassFromString(moduleName);
        id<MTFYModuleBaseProtocol> moduleInstance = [[moduleClass alloc] init];
        if (moduleInstance) {
            self.moduleInstance = moduleInstance;
            
            if ([moduleInstance respondsToSelector:@selector(moduleLevel)]) {
                self.level = [moduleInstance moduleLevel];
            } else {
                self.level = MTFYMModuleLevelNormal;
            }
        }
    }
    return self;
}

#pragma mark - Public

#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters

#pragma mark - Supperclass

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@,level:%ld,registerTime:%f", self.moduleName, (long)self.level, self.registerTimestamp];
}

- (BOOL)isEqual:(MTFYModuleInfo *)object
{
    return [self.moduleName isEqual:object.moduleName];
}

- (NSComparisonResult)compare:(MTFYModuleInfo *)object
{
    NSComparisonResult result = NSOrderedSame;
    
    if (self.level > object.level) {
        result = NSOrderedAscending;
    } else if (self.level < object.level) {
        result = NSOrderedDescending;
    } else {
        if (self.registerTimestamp > object.registerTimestamp) {
            result = NSOrderedDescending;
        } else if (self.registerTimestamp < object.registerTimestamp) {
            result = NSOrderedAscending;
        }
    }
    
    return result;
}


@end
