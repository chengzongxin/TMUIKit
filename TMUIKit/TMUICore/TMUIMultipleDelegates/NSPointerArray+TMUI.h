//
//  NSPointerArray+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSPointerArray (TMUI)

- (NSUInteger)tmui_indexOfPointer:(nullable void *)pointer;
- (BOOL)tmui_containsPointer:(nullable void *)pointer;
@end

NS_ASSUME_NONNULL_END
