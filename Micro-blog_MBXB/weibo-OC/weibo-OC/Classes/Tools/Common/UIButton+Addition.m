//
//  UIButton+Addition.m
//  彩票系统的自我学习
//
//  Created by Oboe_b on 16/7/19.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "UIButton+Addition.h"

@implementation UIButton (Addition)

+ (instancetype)setNormalTitle:(NSString *)normalTitle andNormalColor:(UIColor *)color andFont:(CGFloat)font {
    return [self setAttributas:UIControlStateNormal andTitle:normalTitle andNormalColor:color andFont:font];
}

+ (instancetype)setHighlightedTitle:(NSString *)highlightedTitle andHighlightedColor:(UIColor *)color andFont:(CGFloat)font {
    return [self setAttributas:UIControlStateHighlighted andTitle:highlightedTitle andNormalColor:color andFont:font];
}

+ (UIButton *)setAttributas:(NSUInteger)UIControlState andTitle:(NSString *)title andNormalColor:(UIColor *)color andFont:(CGFloat)font {
    UIButton *btn = [[self alloc] init];
    [btn setTitle:title forState:UIControlState];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitleColor:color forState:UIControlState];
    if (UIControlState == UIControlStateNormal) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }

    [btn sizeToFit];
    return btn;
}

@end
