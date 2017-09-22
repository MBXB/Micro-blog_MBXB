//
//  CLStatusToolBarView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLStatusToolBarView.h"
#import "CLStatusViewModel.h"

@interface CLStatusToolBarView ()

@property (weak, nonatomic) UIButton *retweetbtn;
@property (weak, nonatomic) UIButton *commentBtn;
@property (weak, nonatomic) UIButton *unlikeBtn;

@end

@implementation CLStatusToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    // 添加button
    UIButton *retweetbtn = [self addChildButtonWithImageName:@"timeline_icon_retweet" defaultTitle:@"转发"];
    UIButton *commentBtn = [self addChildButtonWithImageName:@"timeline_icon_comment" defaultTitle:@"评论"];
    UIButton *unlikeBtn = [self addChildButtonWithImageName:@"timeline_icon_unlike" defaultTitle:@"赞"];
    
    self.retweetbtn =retweetbtn;
    self.commentBtn = commentBtn;
    self.unlikeBtn = unlikeBtn;
    
    // 添加分割线
    UIImageView *sp1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    UIImageView *sp2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    [self addSubview:sp1];
    [self addSubview:sp2];
    
    // 添约束
    [retweetbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
    }];
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(retweetbtn.mas_right);
        make.top.bottom.equalTo(self);
        make.width.equalTo(retweetbtn);
    }];
    
    [unlikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentBtn.mas_right);
        make.top.bottom.right.equalTo(self);
        make.width.equalTo(commentBtn);
    }];
    
    [sp1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(retweetbtn.mas_right);
        make.centerY.equalTo(retweetbtn);
    }];
    
    [sp2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(commentBtn.mas_right);
        make.centerY.equalTo(commentBtn);
    }];
}

- (UIButton *)addChildButtonWithImageName:(NSString *)imageName  defaultTitle:(NSString *)title {
    UIButton *btn = [UIButton setNormalTitle:title andNormalColor:[UIColor grayColor] andFont:12];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    return btn;
}

#pragma mark -- 加载数据
- (void)setStatusViewModel:(CLStatusViewModel *)statusViewModel {
    _statusViewModel = statusViewModel;
    [_retweetbtn setTitle:statusViewModel.reposts_count forState:UIControlStateNormal];
    [_commentBtn setTitle:statusViewModel.comments_count forState:UIControlStateNormal];
    [_unlikeBtn setTitle:statusViewModel.attitudes_count forState:UIControlStateNormal];
}

@end
