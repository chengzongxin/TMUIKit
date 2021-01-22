//
//  UILabel+isTruncated.m
//  Matafy
//
//  Created by Jason on 2018/11/22.
//  Copyright © 2018 com.upintech. All rights reserved.
//

#import "UILabel+isTruncated.h"
//
//}
//extension UILabel {
//    //判断文本标签的内容是否被截断
//    var isTruncated: Bool {
//        guard let labelText = text else {
//            return false
//        }
//
//        //计算理论上显示所有文字需要的尺寸
//        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        let labelTextSize = (labelText as NSString)
//        .boundingRect(with: rect, options: .usesLineFragmentOrigin,
//                      attributes: [NSAttributedStringKey.font: self.font], context: nil)
//
//        //计算理论上需要的行数
//        let labelTextLines = Int(ceil(CGFloat(labelTextSize.height) / self.font.lineHeight))
//
//        //实际可显示的行数
//        var labelShowLines = Int(floor(CGFloat(bounds.size.height) / self.font.lineHeight))
//        if self.numberOfLines != 0 {
//            labelShowLines = min(labelShowLines, self.numberOfLines)
//        }
//
//        //比较两个行数来判断是否需要截断
//        return labelTextLines > labelShowLines
//    }
//}


//    CGFloat labelHeight = [_contentLabel sizeThatFits:CGSizeMake(_contentLabel.frame.size.width, MAXFLOAT)].height;
//    NSInteger count = (labelHeight) / _contentLabel.font.lineHeight;
//    if (count <= 8) {
//        _shrinkButton.hidden = YES;
//    }else{
//        _shrinkButton.hidden = NO;
//    }


@implementation UILabel (isTruncated)
//判断文本标签的内容是否被截断
- (BOOL)isTruncated{
    if (!self.text.length) {
        return false;
    }
    //计算理论上显示所有文字需要的尺寸
    CGSize size = CGSizeMake(self.bounds.size.width, CGFLOAT_MAX);
    CGRect labelTextSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    
    //计算理论上需要的行数
    int labelTextLines = (int)(ceil(labelTextSize.size.height / self.font.lineHeight));
    
    //实际可显示的行数
    int labelShowLines = (int)(floor(self.bounds.size.height / self.font.lineHeight));
    
    // 必须限制了行数
    if (self.numberOfLines != 0) {
//        labelShowLines = MIN(labelShowLines, (int)self.numberOfLines);
        labelShowLines = (int)self.numberOfLines;
    }
    
    return labelTextLines > labelShowLines;
}

@end
