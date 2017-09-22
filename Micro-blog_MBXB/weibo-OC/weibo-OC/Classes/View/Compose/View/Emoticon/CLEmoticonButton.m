//
//  CLEmoticonButton.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/9.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLEmoticonButton.h"
#import "CLEmoiconModel.h"
#import "CLEmoticonKeyboardViewModel.h"
#import "NSString+Emoji.h"

@implementation CLEmoticonButton

- (void)setEmoticon:(CLEmoiconModel *)emoticon {
    _emoticon = emoticon;
    
    if (emoticon.type == 0) {
        NSBundle *bundle = [CLEmoticonKeyboardViewModel sharedManeger].emoticonBundel;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",emoticon.path,emoticon.png] inBundle:bundle compatibleWithTraitCollection:nil];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }else {
        [self setTitle:[emoticon.code emoji] forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
}

@end
