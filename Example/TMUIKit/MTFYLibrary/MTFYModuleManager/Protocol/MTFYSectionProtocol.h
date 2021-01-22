//
//  MTFYSectionProtocol.h
//  Matafy
//
//  Created by Fussa on 2019/8/20.
//  Copyright © 2019 com.upintech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTFYSectionProtocol <NSObject>

@optional;
/**
 加载数据
 */
- (void)requestData;

/**
 刷新collectionView
 */
- (void)reloadCollectionView;

@end
