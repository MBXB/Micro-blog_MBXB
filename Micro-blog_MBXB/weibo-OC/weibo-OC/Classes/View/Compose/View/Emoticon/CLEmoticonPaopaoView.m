//
//  CLEmoticonPaopaoView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/9.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLEmoticonPaopaoView.h"
#import "CLEmoticonButton.h"

@interface CLEmoticonPaopaoView ()

@property (weak, nonatomic) IBOutlet CLEmoticonButton *emoticonButton;

@end

@implementation CLEmoticonPaopaoView

+ (instancetype)PaopaoView {
    return [[NSBundle mainBundle] loadNibNamed:@"CLEmoticonPaopaoView" owner:nil options:nil].lastObject;
}

- (void)setEmoticon:(CLEmoiconModel *)emoticon {
    _emoticon = emoticon;
    self.emoticonButton.emoticon = emoticon;
}

@end
