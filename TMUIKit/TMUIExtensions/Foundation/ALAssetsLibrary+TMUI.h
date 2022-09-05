//
//  ALAssetsLibrary+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/3/15.
//

#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(NSError* _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface ALAssetsLibrary (TMUI)

- (void)tmui_saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

- (void)tmui_addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end

NS_ASSUME_NONNULL_END
