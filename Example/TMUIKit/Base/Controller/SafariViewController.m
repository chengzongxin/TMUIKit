//
//  SafariViewController.m
//  silu
//
//  Created by Cheng on 2017/12/18.
//  Copyright © 2017年 upintech. All rights reserved.
//

#import "SafariViewController.h"

@implementation SafariViewController


- (instancetype)initWithURLString:(NSString *)urlString finish:(finish)finishBlock{
    self = [super initWithURL:[NSURL URLWithString:urlString] entersReaderIfAvailable:true];
    if (self) {
        self.delegate = self;
        self.finishBlock = finishBlock;
    }
    return self;
}

/*! @abstract Called when the view controller is about to show UIActivityViewController after the user taps the action button.
 @param URL, the URL of the web page.
 @param title, the title of the web page.
 @result Returns an array of UIActivity instances that will be appended to UIActivityViewController.
 */
//- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(nullable NSString *)title{
//    return @[[[UIActivity alloc] init],[[UIActivity alloc] init],[[UIActivity alloc] init]];
//}

/*! @abstract Delegate callback called when the user taps the Done button. Upon this call, the view controller is dismissed modally. */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    NSLog(@"safariViewControllerDidFinish");
    if (self.escapeBlock) {
        self.escapeBlock();
    }
}

/*! @abstract Invoked when the initial URL load is complete.
 @param didLoadSuccessfully YES if loading completed successfully, NO if loading failed.
 @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
 to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
 */
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
    NSLog(@"safariViewController");
    if (self.finishBlock) {
        self.finishBlock();
    }
}


@end
