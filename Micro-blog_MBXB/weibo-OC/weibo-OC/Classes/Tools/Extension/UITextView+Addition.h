//
//  UITextView+Addition.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/10.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLEmoiconModel;

@interface UITextView (Addition)

// 文本插入表情
- (void)insertEmoticon:(CLEmoiconModel *)emoticon;

@property (copy, nonatomic, readonly) NSString *emoticonText;

@end
