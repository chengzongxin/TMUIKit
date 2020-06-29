//
//  TMEmptyDefine.h
//  Pods
//
//  Created by nigel.ning on 2020/6/29.
//

#ifndef TMEmptyDefine_h
#define TMEmptyDefine_h
#import <Foundation/Foundation.h>

/// 相关统计整理后的空态页面显的类型值
///@note 以下type值的赋值及定义顺序后续不能修改，否则可能影响对应type下的展示内容
///@warning 因相关内部处理逻辑对展示图片、标题串等数据时，是直接以此type值为数组索引，故：后续不能修改此具体type值的赋值及定义顺序 
typedef  NS_ENUM(NSInteger, TMEmptyContentType) {
    TMEmptyContentTypeNoData = 0,           ///< 通用的无内容, 这里空空如也
    TMEmptyContentTypeNetErr,               ///<  网络不好或断开
    TMEmptyContentTypeNoCollection,         ///<  收藏夹空空的
    TMEmptyContentTypeNoLike,               ///<  还没有喜欢的内容
    TMEmptyContentTypeNoPublishUgc,         ///<  还没有发布过内容
    TMEmptyContentTypeDataNoExist,          ///<  内容已不存在，通常是已被删除
    TMEmptyContentTypeNoComment,            ///<  还没有评论
    TMEmptyContentTypeNoSearchResult,       ///<  无搜索结果
    TMEmptyContentTypeNoOrder,              ///<  无订单
    
    /// 目前来看，工程内暂无 NoGift 的使用页
    
    TMEmptyContentTypeNoGift,               ///<   还没有获得礼品
};

#endif /* TMEmptyDefine_h */
