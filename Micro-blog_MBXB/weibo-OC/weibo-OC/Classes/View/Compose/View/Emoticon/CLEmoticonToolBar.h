//
//  CLEmoticonToolBar.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/8.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLEmotionType) {
    CLEmotionTypeResent = 0,
    CLEmotionTypeDefault,
    CLEmotionTypeEmoji,
    CLEmotionTypeLxh
};

@interface CLEmoticonToolBar : UIView

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (copy, nonatomic) void (^emotionTypeChangedBlock)(CLEmotionType type);

@end
