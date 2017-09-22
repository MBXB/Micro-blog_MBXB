//
//  CLEmoticonKeyboardViewModel.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/8.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import "CLEmoticonKeyboardViewModel.h"
#import "CLEmoiconModel.h"

@interface CLEmoticonKeyboardViewModel ()

@property (strong, nonatomic) NSMutableArray *recentEmotions;
@property (strong, nonatomic) NSArray *defaultEmotions;
@property (strong, nonatomic) NSArray *emojiEmotions;
@property (strong, nonatomic) NSArray *lxhEmotions;
@property (copy, nonatomic, readonly) NSString *archivePath;

@end

@implementation CLEmoticonKeyboardViewModel

+ (instancetype)sharedManeger {
    static CLEmoticonKeyboardViewModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSBundle *)emoticonBundel {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Emoticons.bundle" ofType:nil];
    NSBundle *result = [NSBundle bundleWithPath:path];
    return result;
}

- (NSMutableArray *)recentEmotions {
    if (!_recentEmotions) {
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:self.archivePath];
        if (_recentEmotions != nil && _recentEmotions.count != 0) {
            return _recentEmotions;
        }
        _recentEmotions = [NSMutableArray arrayWithObject:[CLEmoiconModel new]];
    }
    return _recentEmotions;
}

- (NSArray *)defaultEmotions {
    return [self emoticonsWithPath:@"default/info.plist"];
}

- (NSArray *)emojiEmotions {
    return [self emoticonsWithPath:@"emoji/info.plist"];
}

- (NSArray *)lxhEmotions {
    return [self emoticonsWithPath:@"lxh/info.plist"];
}

- (NSArray *)allEmotions {
    return @[[self typeEmotionPagesWithEmotionaArray:self.recentEmotions],
             [self typeEmotionPagesWithEmotionaArray:self.defaultEmotions],
             [self typeEmotionPagesWithEmotionaArray:self.emojiEmotions],
             [self typeEmotionPagesWithEmotionaArray:self.lxhEmotions]];
}

- (NSString *)archivePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject stringByAppendingPathComponent:@"recent.archive"];
}

- (CLEmoiconModel *)getEmoticonWithString:(NSString *)captureString {
    // 遍历默认表情
    for (CLEmoiconModel *value in self.defaultEmotions) {
        if (value.chs == captureString) {
            return value;
        }
    }
    
    // 遍历浪小花
    for (CLEmoiconModel *value in self.lxhEmotions ) {
        if (value.chs == captureString) {
            return value;
        }
    }
    
    return nil;
}

/**
  用来将选择的图片保存在最近使用中
 */
- (void)saveEmoticonToRecent:(CLEmoiconModel *)emoticon {
//    __block NSInteger index = 0;
//    __block BOOL isContains = false;
    [self.recentEmotions enumerateObjectsUsingBlock:^(CLEmoiconModel *value, NSUInteger index, BOOL * _Nonnull stop) {
        BOOL isContains = false;
        if (value.type == emoticon.type) {
            if (value.type == 0) {
                isContains = [value.png isEqualToString: emoticon.png];
            }else {
                isContains = [value.code isEqualToString: emoticon.code];
            }
            
            if (isContains == true) {
                [self.recentEmotions removeObjectAtIndex:index];
                *stop = true;
            }
        }
    }];
    
    [self.recentEmotions insertObject:emoticon atIndex:0];
    
    if (self.recentEmotions.count > 20) {
        [self.recentEmotions removeLastObject];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLEmoticonReloadDataNotification object:nil];

    [NSKeyedArchiver archiveRootObject:self.recentEmotions toFile:self.archivePath];
    
}

/**
 将一类表情数组分割成20个表情一组

 @param emoticons 一类表情

 @return 分割好的表情
 */
- (NSArray *)typeEmotionPagesWithEmotionaArray:(NSArray *)emoticons {
    
    NSInteger pageCount = (emoticons.count - 1) / CLEmoticonKeyboardPageEmoticonCount + 1;
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0 ; i < pageCount; i++) {
        NSInteger loc = i * CLEmoticonKeyboardPageEmoticonCount;
        NSInteger len = CLEmoticonKeyboardPageEmoticonCount;
        
        if (loc + len > emoticons.count) {
            len = emoticons.count - loc;
        }
        NSRange range = NSMakeRange(loc, len);
        NSArray *subArray = [emoticons subarrayWithRange:range];
        [result addObject:subArray];
    }
    return result;
}

/**
 从指定的路径加载所有的表情组

 @param path <#path description#>

 @return <#return value description#>
 */
- (NSArray *)emoticonsWithPath:(NSString *)path {
    NSString *file = [self.emoticonBundel pathForResource:path ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:file];
    NSArray *emoticons = [NSArray yy_modelArrayWithClass:[CLEmoiconModel class] json:array];
    
    // 设置表情模型对应的文件夹
    for (CLEmoiconModel *value in emoticons) {
        value.path = [path stringByDeletingLastPathComponent];
    }
    return emoticons;
}

@end
