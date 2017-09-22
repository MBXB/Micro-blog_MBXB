//
//  CLVisitorView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/30.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLVisitorView.h"
#import "Addition.h"
#import "Masonry.h"

@interface CLVisitorView ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UIImageView *circleView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIButton *registButton;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIImageView *maskIconView;

@end

@implementation CLVisitorView

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
    self.backgroundColor = [UIColor colorWithWhite:237.0 / 255 alpha:1];
    
    // 添加控件
    [self addSubview:self.circleView];
    [self addSubview:self.maskIconView];
    [self addSubview:self.iconView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.registButton];
    [self addSubview:self.loginButton];
    
    // 自动布局
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_iconView);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_circleView.mas_bottom).mas_offset(16);
        make.width.mas_equalTo(224);
    }];
    
    [_registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_messageLabel);
        make.top.equalTo(_messageLabel.mas_bottom).mas_offset(16);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_messageLabel);
        make.top.equalTo(_registButton);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    
    [_maskIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(_registButton);
    }];
    
}

- (void)setVisitorViewInfoWithImageName:(NSString *)imageName message:(NSString *)message {
    if (imageName) {
        _circleView.hidden = true;
        _iconView.image = [UIImage imageNamed:imageName];
        _messageLabel.text = message;
    }else {
        _messageLabel.text = message;
        [self startAnimation];
    }
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 20;
    animation.repeatCount = MAXFLOAT;
    animation.toValue = @(M_PI * 2);
    
    animation.removedOnCompletion = NO;
    [_circleView.layer addAnimation:animation forKey:nil];
}

#pragma mark -- 点击事件
- (void)loginButtonClick {
    if (self.loginBlock) {
        self.loginBlock();
    }
}

#pragma mark -- 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
    }
    return _iconView;
}

-(UIImageView *)circleView {
    if (!_circleView) {
        _circleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_smallicon"]];
    }
    return _circleView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel labelWithText:@"测试" andTextColor:[UIColor grayColor] andFontSize:14];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UIButton *)registButton {
    if (!_registButton) {
        _registButton = [UIButton setNormalTitle:@"注册" andNormalColor:[UIColor grayColor] andFont:14];
        [_registButton setBackgroundImage:[UIImage imageNamed:@"common_button_white"] forState:UIControlStateNormal];
    }
    return _registButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton setNormalTitle:@"登陆" andNormalColor:[UIColor grayColor] andFont:14];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"common_button_white"] forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UIImageView *)maskIconView {
    if (!_maskIconView) {
        _maskIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_mask_smallicon"]];
    }
    return _maskIconView;
}

@end
