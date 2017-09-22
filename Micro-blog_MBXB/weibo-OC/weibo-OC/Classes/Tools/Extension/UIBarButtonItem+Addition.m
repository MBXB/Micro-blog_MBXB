//
//  UIBarButtonItem+Addition.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "UIBarButtonItem+Addition.h"

@implementation UIBarButtonItem (Addition)

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    // 如果有文字，设置文字
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithRed:80 / 255 green:80 / 255 blue:80 / 255 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    }

    // 如果有图片设置图片
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", imageName]] forState:UIControlStateHighlighted];
    }

    // 添加点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    //        self.customView = btn;
    return [self initWithCustomView:btn];
}

@end
