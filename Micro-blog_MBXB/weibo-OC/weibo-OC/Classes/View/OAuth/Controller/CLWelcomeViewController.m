//
//  CLWelcomeViewController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLWelcomeViewController.h"
#import "Addition.h"
#import "Masonry.h"
#import "CLUserAccountViewModel.h"
#import "CLUserAccount.h"

@interface CLWelcomeViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *messageLabel;

@end

@implementation CLWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    NSURL *url = [NSURL URLWithString:[CLUserAccountViewModel sharedManager].account.avatar_large];
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
    }];
    
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:.7 initialSpringVelocity:0 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _messageLabel.alpha = 1;
        }completion:^(BOOL finished) {
            // 动画结束，切换到首页
            NSLog(@"动画结束，切换到首页");
            [[NSNotificationCenter defaultCenter] postNotificationName:CLChangeRootVCNotification object:nil];
        }];
    }];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 / 255 alpha:1];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.messageLabel];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(200);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_imageView);
        make.top.equalTo(_imageView.mas_bottom).mas_offset(15);
    }];
}

#pragma mark -- 懒加载
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
        _imageView.layer.cornerRadius = 45;
        _imageView.layer.masksToBounds = YES;
        
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
        _imageView.layer.borderWidth = 1;
    }
    return _imageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel labelWithText:@"欢迎回来" andTextColor:[UIColor grayColor] andFontSize:16];
        [_messageLabel sizeToFit];
        _messageLabel.alpha = 0;
    }
    return _messageLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
