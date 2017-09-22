//
//  CLStatusCell.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLStatusCell.h"
#import "CLOriginalStatusView.h"
#import "CLStatusToolBarView.h"
#import "CLRetweetStatusView.h"
#import "CLStatusModel.h"

@interface CLStatusCell ()

@property (strong, nonatomic) CLOriginalStatusView *originalStatusView;
@property (strong, nonatomic) CLStatusToolBarView *statusToolBarView;
@property (strong, nonatomic) CLRetweetStatusView *retweetStatusView;

@end

@implementation CLStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 用户信息设置
    _originalStatusView = [[CLOriginalStatusView alloc] init];
    [self.contentView addSubview:_originalStatusView];
    
    _statusToolBarView = [[CLStatusToolBarView alloc] init];
    [self.contentView addSubview:_statusToolBarView];
    
    _retweetStatusView = [[CLRetweetStatusView alloc] init];
    [self.contentView addSubview:_retweetStatusView];
    
    // 自动布局
    [_originalStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
    }];
    
    [_retweetStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_originalStatusView.mas_bottom);
    }];
    
    [_statusToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(_retweetStatusView.mas_bottom);
    }];
    
}

#pragma mark -- setter方法
- (void)setStatusViewModel:(CLStatusViewModel *)statusViewModel {
    _statusViewModel = statusViewModel;
    _originalStatusView.statusViewModel = statusViewModel;
    _statusToolBarView.statusViewModel = statusViewModel;
    if(statusViewModel.model.retweeted_status != nil) {
        _retweetStatusView.hidden = false;
        _retweetStatusView.statusViewModel = statusViewModel;
        
        [_statusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(_retweetStatusView.mas_bottom);
        }];
    }else {
        _retweetStatusView.hidden = true;
        [_statusToolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(_originalStatusView.mas_bottom);
        }];
    }
}

@end
