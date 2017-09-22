//
//  CLRetweetStatusView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLRetweetStatusView.h"
#import "CLStatusViewModel.h"
#import "CLStatusModel.h"
#import "CLUserModel.h"
#import "CLStatusPictureView.h"

@interface CLRetweetStatusView ()
/**
 内容
 */
@property (weak, nonatomic) YYLabel *contentLabel;
/**
 微博配图
 */
@property (weak, nonatomic) CLStatusPictureView *pictureView;
@property (strong, nonatomic) MASConstraint *bottomCon;

@end

@implementation CLRetweetStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:250.0 / 255 alpha:1];
    
    // 内容label
    YYLabel *contentLabel = [[YYLabel alloc] init];
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 0;
    contentLabel.preferredMaxLayoutWidth = CLScreenW - 2 * (CGFloat)CLStatusCellMargin;
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 微博配图
    CLStatusPictureView *pictureView = [[CLStatusPictureView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self addSubview:pictureView];
    self.pictureView = pictureView;
    
    // 自动布局
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(CLStatusCellMargin);
    }];
    
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).mas_offset(CLStatusCellMargin);
        make.left.equalTo(contentLabel);
    }];
    
    // 设置视图底部的高为微博配图的高
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(pictureView.mas_bottom).mas_offset(CLStatusCellMargin);
    }];
}

- (void)setStatusViewModel:(CLStatusViewModel *)statusViewModel {
    _statusViewModel = statusViewModel;
    
    self.contentLabel.attributedText = statusViewModel.retweetAttributedText;
    
    NSArray *pic_urls = statusViewModel.model.retweeted_status.pic_urls;
    
    [self.bottomCon uninstall];
    if (pic_urls.count > 0) {
        self.pictureView.hidden = false;
        self.pictureView.pic_urls = pic_urls;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.pictureView.mas_bottom).mas_offset(CLStatusCellMargin);
        }];
    }else {
        self.pictureView.hidden = true;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.bottomCon = make.bottom.equalTo(self.contentLabel.mas_bottom).mas_offset(CLStatusCellMargin);
        }];
    }    
}

@end
