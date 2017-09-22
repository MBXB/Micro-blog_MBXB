//
//  CLTabBar.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLTabBar.h"

@interface CLTabBar ()

@property (strong, nonatomic) UIButton *composeButton;

@end

@implementation CLTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    [self addSubview:self.composeButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.composeButton.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    // 一个UITabBarButton的索引
    NSInteger index = 0;
    
    // 每个Button的宽
    CGFloat itemW = self.bounds.size.width / 5;
    
    for (UIView *subView in self.subviews) {
        if([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGRect rect = subView.frame;
            
            rect.origin.x = index * itemW;
            rect.size.width = itemW;
            
            if (index == 1) {
                index ++;
            }
            subView.frame = rect;
            index ++;
        }
    }
}

- (void)composeBtnClick :(UIButton *)sender {
    if (self.composeButtonClick) {
        self.composeButtonClick();
    }
}

#pragma mark -- 懒加载
- (UIButton *)composeButton {
    if(!_composeButton){
        _composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_composeButton addTarget:self action:@selector(composeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_composeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [_composeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [_composeButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [_composeButton sizeToFit];
    }
    return _composeButton;
}

@end
