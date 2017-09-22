//
//  CLEmoticonToolBar.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/8.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLEmoticonToolBar.h"

@interface CLEmoticonToolBar ()

@property (weak, nonatomic) UIStackView *stackView;
@property (weak, nonatomic) UIButton *currentSelectedButton;

@end

@implementation CLEmoticonToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.tag = 1000;
    stackView.distribution = UIStackViewDistributionFillEqually;
    self.stackView = stackView;
    [self addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addChildButtonWithTitle:@"最近" bgImageName:@"compose_emotion_table_left" CLEmotionType:CLEmotionTypeResent];
    [self addChildButtonWithTitle:@"默认" bgImageName:@"compose_emotion_table_mid" CLEmotionType:CLEmotionTypeDefault];
    [self addChildButtonWithTitle:@"Emoji" bgImageName:@"compose_emotion_table_mid" CLEmotionType:CLEmotionTypeEmoji];
    [self addChildButtonWithTitle:@"浪小花" bgImageName:@"compose_emotion_table_right" CLEmotionType:CLEmotionTypeLxh];
}

- (void)addChildButtonWithTitle:(NSString *)title bgImageName:(NSString *)bgImageName CLEmotionType:(CLEmotionType)type{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(childButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.tag = type;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [btn setBackgroundImage:[UIImage imageNamed:[bgImageName stringByAppendingString:@"_normal"]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:[bgImageName stringByAppendingString:@"_selected"]] forState:UIControlStateSelected];
    
    [self.stackView addArrangedSubview:btn];
}

- (void)childButtonClick:(UIButton *)sender {
    if (_currentSelectedButton == sender) {
        return;
    }
    if (_currentSelectedButton != nil) {
        _currentSelectedButton.selected = false;
    }
    sender.selected = true;
    
    _currentSelectedButton = sender;
    
    // 通知外界滚动scrollView
    if (self.emotionTypeChangedBlock) {
        self.emotionTypeChangedBlock(sender.tag);
    }
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    _selectedIndexPath = selectedIndexPath;
    UIButton *sender = [self.stackView viewWithTag:selectedIndexPath.section];
    if (_currentSelectedButton == sender) {
        return;
    }
    if (_currentSelectedButton != nil) {
        _currentSelectedButton.selected = false;
    }
    sender.selected = true;
    _currentSelectedButton = sender;
}

@end
