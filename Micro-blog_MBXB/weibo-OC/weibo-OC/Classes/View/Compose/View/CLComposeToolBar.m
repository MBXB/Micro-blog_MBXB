//
//  CLComposeToolBar.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/7.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLComposeToolBar.h"

@interface CLComposeToolBar ()

@property (weak, nonatomic) UIStackView *stackView;

@end

@implementation CLComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.distribution = UIStackViewDistributionFillEqually;
    self.stackView = stackView;
    [self addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addChildButtonWithImageName:@"compose_toolbar_picture" composeToolBarType:CLComposeToolBarTypePicture];
    [self addChildButtonWithImageName:@"compose_mentionbutton_background" composeToolBarType:CLComposeToolBarTypeMention];
    [self addChildButtonWithImageName:@"compose_trendbutton_background" composeToolBarType:CLComposeToolBarTypeTrend];
    [self addChildButtonWithImageName:@"compose_emoticonbutton_background" composeToolBarType:CLComposeToolBarTypeEmoticon];
    [self addChildButtonWithImageName:@"compose_add_background" composeToolBarType:CLComposeToolBarTypeAdd];
    
}

- (void)addChildButtonWithImageName:(NSString *)imageName composeToolBarType:(CLComposeToolBarType)type {
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_highlighted"]] forState:UIControlStateHighlighted];
    btn.tag = type;
    [btn addTarget:self action:@selector(childButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addArrangedSubview:btn];
}

- (void)childButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(composeToolBarWithToolBar:composeToolBarType:)]) {
        [self.delegate composeToolBarWithToolBar:self composeToolBarType:sender.tag];
    }
}

- (void)setIsSystemKeyboard:(BOOL)isSystemKeyboard {
    _isSystemKeyboard = isSystemKeyboard;
    
    UIButton *btn = [self viewWithTag:3];
    NSString *imageName = @"compose_keyboardbutton_background";
    if (_isSystemKeyboard) {
        imageName = @"compose_emoticonbutton_background";
    }
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_highlighted"]] forState:UIControlStateHighlighted];
}
@end
