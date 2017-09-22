//
//  UIButton+Addition.h
//  彩票系统的自我学习
//
//  Created by Oboe_b on 16/7/19.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Addition)

+ (instancetype)setNormalTitle:(NSString *)normalTitle andNormalColor:(UIColor *)color andFont:(CGFloat)font;

+ (instancetype)setHighlightedTitle:(NSString *)highlightedTitle andHighlightedColor:(UIColor *)color andFont:(CGFloat)font;
@end
