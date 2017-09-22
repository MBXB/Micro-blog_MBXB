//
//  UITextView+Addition.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/10.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "UITextView+Addition.h"
#import "CLEmoiconModel.h"
#import "NSString+Emoji.h"
#import "CLEmoticonKeyboardViewModel.h"
#import "CLTextAttachment.h"

@implementation UITextView (Addition)

- (void)insertEmoticon:(CLEmoiconModel *)emoticon {
    if (emoticon.type == 1) {
        // 直接插入emoji表情
        [self insertText:[emoticon.code emoji]];
    }else {
        NSBundle *bundle = [CLEmoticonKeyboardViewModel sharedManeger].emoticonBundel;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",emoticon.path,emoticon.png] inBundle:bundle compatibleWithTraitCollection:nil];
        
        // 文字附件
        CLTextAttachment *attachment = [[CLTextAttachment alloc]init];
        // 设置表情图片的大小
        CGFloat imageHW = self.font.lineHeight;
        attachment.bounds = CGRectMake(0, -4, imageHW, imageHW);
        attachment.image = image;
        attachment.chs = emoticon.chs;
        
        // 将文字附件添加到富文本中
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        // 获取光标的位置
        NSRange selectedRange = self.selectedRange;
        // 将数据插入到指定的位置，但不能替换，所以改用Replace
        [attr replaceCharactersInRange:selectedRange withAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        
        // 设置富文本的大小
        [attr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attr.length)];
        
        // 将设置好的富文本添加到textView中
        self.attributedText = attr;
        
        // 重新将光标移动回来
        selectedRange.location += 1;
        selectedRange.length = 0;
        self.selectedRange = selectedRange;
        
        // 发送通知，让文字改变
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:nil];
        // 执行代理方法
        if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.delegate textViewDidChange:self];
        }
    }
}

- (NSString *)emoticonText {
    NSMutableString *result = [NSMutableString string];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        CLTextAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment != nil) {
            [result appendString:attachment.chs];
        }else {
            [result appendString:[self.attributedText.string substringWithRange:range]];
        }
    }];
    return result.copy;
}

@end
