//
//  TMCityPicker.h
//  Masonry
//
//  Created by nigel.ning on 2020/4/20.
//

#import "TMContentPicker.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const NSString *const TMCityPickerTitle;

typedef NSArray * _Nonnull (^TMCityPickerProvinceItemListBlock)(void);
typedef NSArray * _Nonnull (^TMCityPickerCityItemListAtProvinceBlock)(id provinceItem, NSInteger provinceIndex);

typedef NSString * _Nonnull (^TMCityPickerFetchShowStringForProvinceBlock)(id provinceItem, NSInteger provinceIndex);
typedef NSString * _Nonnull (^TMCityPickerFetchShowStringForCityBlock)(id cityItem, NSInteger cityIndex, id inProvinceItem, NSInteger provinceIndex);

typedef void (^TMCityPickerFinishSelectBlock)(id selectedProvinceItem, NSInteger selectedProvinceIndex, id selectedCityItem, NSInteger selectedCityIndex);

/**
 城市选择器视图
 主要分两列 省-市，当省变化时对应的市列表数据要联动变化
 */
@interface TMCityPicker : TMContentPicker


+ (void)showPickerWithTitle:(NSString * _Nullable)title
      provinceItemListBlock:(TMCityPickerProvinceItemListBlock)provinceItemListBlock
cityItemListAtProvinceBlock:(TMCityPickerCityItemListAtProvinceBlock)cityItemListAtProvinceBlock
fetchShowStringForProvinceItem:(TMCityPickerFetchShowStringForProvinceBlock)fetchShowStringForProvinceBlock
 fetchShowStringForCityItem:(TMCityPickerFetchShowStringForCityBlock)fetchShowStringForCityBlock
          finishSelectBlock:(TMCityPickerFinishSelectBlock)finishSelectBlock
       curProvinceItemIndex:(NSInteger)curProvinceItemIndex
           curCityItemIndex:(NSInteger)curCityItemIndex
         fromViewController:(UIViewController *)fromVc;


@end

NS_ASSUME_NONNULL_END
