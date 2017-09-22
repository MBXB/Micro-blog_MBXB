//
//  CLEmoticonKeyboardViewModel.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/8.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import <Foundation/Foundation.h>
@class CLEmoiconModel;

static NSInteger CLEmoticonKeyboardPageEmoticonCount = 20;

@interface CLEmoticonKeyboardViewModel : NSObject

+ (instancetype)sharedManeger;

/**
 当前存放各种表情的bundle
 */
@property (strong, nonatomic, readonly) NSBundle *emoticonBundel;
/**
 用来存放所有表情的数组
 */
@property (strong, nonatomic) NSArray<NSArray *> *allEmotions;
/**
 用来将选择的图片保存在最近使用中
 */
- (void)saveEmoticonToRecent:(CLEmoiconModel *)emoticon;
/**
 获取富文本的中的表情所在的模型
 */
- (CLEmoiconModel *)getEmoticonWithString:(NSString *)captureString;

@end
