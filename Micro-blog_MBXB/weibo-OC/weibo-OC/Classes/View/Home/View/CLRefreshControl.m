//
//  CLRefreshControl.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/4.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLRefreshControl.h"

CGFloat CLRefreshControlH = 50;

@interface CLRefreshControl ()

@property (strong, nonatomic) UIActivityIndicatorView *indictorView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CLRefreshType clRefreshState;
@property (assign, nonatomic) CLRefreshType oldRefreshState;

@end

@implementation CLRefreshControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)endRefreshing {
    self.clRefreshState = CLRefreshTypeNormal;
}

- (void)setupUI {
    self.frame = CGRectMake(0, -CLRefreshControlH, CLScreenW, CLRefreshControlH);
    self.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:self.arrowImageView];
    [self addSubview:self.messageLabel];
    [self addSubview:self.indictorView];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).mas_offset(-50);
        make.centerY.equalTo(self);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_arrowImageView.mas_right).mas_offset(CLStatusCellMargin);
    }];
    
    [_indictorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_arrowImageView);
    }];
    
}

#pragma mark -- KVO监听tableView的滚动
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    CGFloat contentInsetTop = self.scrollView.contentInset.top;
    
    // 下拉刷新的分界线
    CGFloat conditionValue = -contentInsetTop - CLRefreshControlH;
    if (self.scrollView.isDragging) {
        if (self.clRefreshState == CLRefreshTypeNormal && self.scrollView.contentOffset.y <= conditionValue) {
            self.clRefreshState = CLRefreshTypePulling;
        }else if (self.clRefreshState == CLRefreshTypePulling && self.scrollView.contentOffset.y > conditionValue)
            self.clRefreshState = CLRefreshTypeNormal;
    }else {
        if (self.clRefreshState == CLRefreshTypePulling) {
            self.clRefreshState = CLRefreshTypeRefreshing;
        }
    }
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark -- setter方法
- (void)setClRefreshState:(CLRefreshType)clRefreshState {
    _clRefreshState = clRefreshState;
    switch (clRefreshState) {
        case CLRefreshTypePulling: {
            // 调转箭头
            [UIView animateWithDuration:0.25 animations:^{
                self.arrowImageView.transform = CGAffineTransformMakeRotation((CGFloat)M_PI * 0.9999999);
            }];
            self.messageLabel.text = @"老司机要发车了~~";
            break;
        }
        case CLRefreshTypeNormal:{
            self.arrowImageView.hidden = false;
            [self.indictorView stopAnimating];
            
            // 恢复箭头的初始状态
            [UIView animateWithDuration:0.25 animations:^{
                self.indictorView.transform = CGAffineTransformIdentity;
            }];
            self.messageLabel.text = @"老司机等等我~~";
            
            // 如果之前是CLRefreshTypeRefreshing状态,将inset恢复
            if (self.oldRefreshState == CLRefreshTypeRefreshing) {
                [UIView animateWithDuration:0.24 animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.top -= CLRefreshControlH;
                    self.scrollView.contentInset = inset;
                }];
            }
            break;
        }
        case CLRefreshTypeRefreshing: {
            self.arrowImageView.hidden = true;
            [self.indictorView startAnimating];
            self.messageLabel.text = @"老司正在开车...";
            
            // 在刷新的时候改变ScrollView的contentInset使其保持在当前位置
            [UIView animateWithDuration:0.24 animations:^{
                UIEdgeInsets inset = self.scrollView.contentInset;
                inset.top += CLRefreshControlH;
                self.scrollView.contentInset = inset;
                
            }];
            
            // 发送消息，让scrollView刷新数据
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        }
    }
    self.oldRefreshState = clRefreshState;
}

#pragma mark -- 懒加载
- (UIActivityIndicatorView *)indictorView {
    if (!_indictorView) {
        _indictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indictorView.color = [UIColor blackColor];
    }
    return _indictorView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel labelWithText:@"" andTextColor:[UIColor darkGrayColor] andFontSize:14];
    }
    return _messageLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_pull_refresh"]];
    }
    return _arrowImageView;
}

@end
