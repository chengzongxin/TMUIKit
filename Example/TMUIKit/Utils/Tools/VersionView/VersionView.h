//
//  VersionView.h
//  silu
//
//  Created by sawyerzhang on 2016/10/26.
//  Copyright © 2016年 upintech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionView : UIView
@property (assign ,nonatomic)NSInteger counts; /// 更新内容数,与数组内容必须个数相同
@property (strong , nonatomic) NSArray<NSString *> *versionInfo; /// 更新内容数组
@property (copy , nonatomic) NSString *version; /// 版本


@property (strong , nonatomic) NSDictionary *dic;
@end
