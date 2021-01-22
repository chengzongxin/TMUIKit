//
//  MTFYResponseModel.h
//  Matafy
//
//  Created by Fussa on 2019/9/17.
//  Copyright © 2019 com.upintech. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

/**
 * 请求的Response数据的模型
 */
@interface MTFYResponseModel : NSObject
/// 状态码
@property(nonatomic, assign) NSInteger code;
/// 信息
@property(nonatomic, copy) NSString *message;
/// 数据实体
@property(nonatomic, strong) id data;

@end

/**
 * 请求的Response分页数据模型
 */
@interface MTFYResponsePageModel: NSObject
@property (nonatomic,assign) NSInteger startRow;
@property (nonatomic,assign) NSInteger total;
@property (nonatomic,assign) NSInteger size;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger nextPage;
@property (nonatomic,assign) NSInteger navigatepageNums;
@property (nonatomic,assign) NSInteger navigatePages;
@property (nonatomic,assign) NSInteger navigateLastPage;
@property (nonatomic,assign) NSInteger navigateFirstPage;
@property (nonatomic,assign) NSInteger lastPage;
@property (nonatomic,assign) NSInteger isLastPage;
@property (nonatomic,assign) NSInteger isFirstPage;
@property (nonatomic,assign) NSInteger hasPreviousPage;
@property (nonatomic,assign) NSInteger hasNextPage;
@property (nonatomic,assign) NSInteger firstPage;
@property (nonatomic,copy) NSString *extData;
@property (nonatomic,assign) NSInteger endRow;
@property (nonatomic,strong) NSArray *list;

+ (instancetype)objectWithKeyValues:(id)keyValues classInArray:(Class)className;

@end

NS_ASSUME_NONNULL_END
