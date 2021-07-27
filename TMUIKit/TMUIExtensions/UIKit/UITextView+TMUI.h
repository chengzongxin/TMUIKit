//
//  UITextView+TMUI.h
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (TMUI)

/**
 *  convert UITextRange to NSRange, for example, [self tmui_convertNSRangeFromUITextRange:self.markedTextRange]
 */
- (NSRange)tmui_convertNSRangeFromUITextRange:(UITextRange *)textRange;

/**
 *  convert NSRange to UITextRange
 *  @return return nil if range is invalidate.
 */
- (nullable UITextRange *)tmui_convertUITextRangeFromNSRange:(NSRange)range;

/**
 *  设置 text 会让 selectedTextRange 跳到最后一个字符，导致在中间修改文字后光标会跳到末尾，所以设置前要保存一下，设置后恢复过来
 */
- (void)tmui_setTextKeepingSelectedRange:(NSString *)text;

/**
 *  设置 attributedText 会让 selectedTextRange 跳到最后一个字符，导致在中间修改文字后光标会跳到末尾，所以设置前要保存一下，设置后恢复过来
 */
- (void)tmui_setAttributedTextKeepingSelectedRange:(NSAttributedString *)attributedText;

/**
 [UITextView scrollRangeToVisible:] 并不会考虑 textContainerInset.bottom，所以使用这个方法来代替

 @param range 要滚动到的文字区域，如果 range 非法则什么都不做
 */
- (void)tmui_scrollRangeToVisible:(NSRange)range;

/**
 * 将光标滚到可视区域
 */
- (void)tmui_scrollCaretVisibleAnimated:(BOOL)animated;

@end


NS_ASSUME_NONNULL_END
