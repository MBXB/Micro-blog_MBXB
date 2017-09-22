//
//  CLOriginalStatusView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLOriginalStatusView.h"
#import "CLStatusModel.h"
#import "CLStatusViewModel.h"
#import "CLUserModel.h"
#import "CLStatusPictureView.h"

@interface CLOriginalStatusView ()
/**
 用户图标
 */
@property (strong, nonatomic) UIImageView *iconView;
/**
 昵称
 */
@property (strong, nonatomic) UILabel *nameLabel;
/**
 会员标识
 */
@property (strong, nonatomic) UIImageView *memberIconView;
/**
 创建时间
 */
@property (strong, nonatomic) UILabel *createAtLabel;
/**
 来源
 */
@property (strong, nonatomic) UILabel *sourceLabel;
/**
 身份标识
 */
@property (strong, nonatomic) UIImageView *avatarIconView;
/**
 内容
 */
@property (strong, nonatomic) YYLabel *contentLabel;
/**
 微博配图
 */
@property (weak, nonatomic) CLStatusPictureView *pictureView;

@property (strong, nonatomic) MASConstraint *bottomCon;


@end

@implementation CLOriginalStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    // 微博配图
    CLStatusPictureView *pictureView = [[CLStatusPictureView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.pictureView = pictureView;
    
    [self addSubview:pictureView];
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.memberIconView];
    [self addSubview:self.sourceLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.createAtLabel];
    [self addSubview:self.avatarIconView];
    
    // 自动布局
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_offset(CLStatusCellMargin);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView);
        make.left.equalTo(_iconView.mas_right).offset(CLStatusCellMargin);
    }];
    
    [_memberIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel).offset(-2);
        make.left.equalTo(_nameLabel.mas_right).offset(CLStatusCellMargin);
    }];
    
    [_createAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_iconView);
    }];
    
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_createAtLabel.mas_right).offset(CLStatusCellMargin);
        make.top.equalTo(_createAtLabel);
    }];
    
    [_avatarIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconView.mas_bottom).offset(-2);
        make.centerX.equalTo(_iconView.mas_right).offset(-2);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView);
        make.top.equalTo(_iconView.mas_bottom).offset(CLStatusCellMargin);
    }];
    
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).mas_offset(CLStatusCellMargin);
        make.left.equalTo(_contentLabel);
    }];
    
    //原创微博的底部为内容的底部
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.bottomCon = make.bottom.equalTo(pictureView).mas_offset(CLStatusCellMargin);
    }];
}

#pragma mark -- 设置显示的数据
- (void)setStatusViewModel:(CLStatusViewModel *)statusViewModel {
    _statusViewModel = statusViewModel;
    
    // 设置显示数据
    [_iconView sd_setImageWithURL:[NSURL URLWithString:statusViewModel.model.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    _nameLabel.text = statusViewModel.model.user.name;
    _memberIconView.image = statusViewModel.memberImage;
    _avatarIconView.image = statusViewModel.avatatImage;
    
//    _contentLabel.text = statusViewModel.model.text;
    _contentLabel.attributedText = statusViewModel.originalAttributedText;
    _sourceLabel.text = statusViewModel.sourceString;
    _createAtLabel.text = statusViewModel.createAtString;
    
    NSArray *pic_urls = statusViewModel.model.pic_urls;
    
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

#pragma mark -- 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithText:@"帅哥" andTextColor:[UIColor darkGrayColor] andFontSize:14];
    }
    return _nameLabel;
}
- (UIImageView *)memberIconView {
    if (!_memberIconView) {
        _memberIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership"]];
    }
    return _memberIconView;
}

- (UILabel *)createAtLabel {
    if (!_createAtLabel) {
        _createAtLabel = [UILabel labelWithText:@"刚刚" andTextColor:[UIColor orangeColor] andFontSize:12];
    }
    return _createAtLabel;
}

- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        _sourceLabel = [UILabel labelWithText:@"来自 帅的一逼" andTextColor:[UIColor darkGrayColor] andFontSize:12];
    }
    return _sourceLabel;
}

- (UIImageView *)avatarIconView {
    if (!_avatarIconView) {
        _avatarIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_vgirl"]];
    }
    return _avatarIconView;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = CLScreenW - 2 * CLStatusCellMargin;
    }
    return _contentLabel;
}

@end
