//
//  CLEmoticonCell.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/9.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLEmoticonCell.h"
#import "CLEmoiconModel.h"
#import "CLEmoticonKeyboardViewModel.h"
#import "CLEmoticonButton.h"
#import "CLEmoticonPaopaoView.h"

@interface CLEmoticonCell ()

@property (weak, nonatomic) UILabel *messageLabel;
/**
 存储当前页的按钮
 */
@property (strong, nonatomic) NSMutableArray<CLEmoticonButton *> *emoticonButtons;
/**
 删除按钮
 */
@property (strong, nonatomic) UIButton *deleteButton;
/**
 气泡
 */
@property (strong, nonatomic) CLEmoticonPaopaoView *paopaoView;
@end

@implementation CLEmoticonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *messageLabel = [UILabel labelWithText:@"最近使用表情" andTextColor:[UIColor blackColor] andFontSize:14];
    [self.contentView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).mas_offset(-10);
    }];
    
    self.messageLabel = messageLabel;
    
    [self addChildButtons];
    [self.contentView addSubview:self.deleteButton];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self addGestureRecognizer:longPress];
}

#pragma mark - 响应事件
- (void)longPressGesture:(UILongPressGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            // 获取button
            CGPoint location = [sender locationInView:sender.view];
            CLEmoticonButton *button = [self getButtonWithLocation:location];
            
            if (button != nil) {
                if (button.isHidden == true) {
                    [self.paopaoView removeFromSuperview];
                    return;
                }
                // 获取button相对window的位置
                self.paopaoView.emoticon = button.emoticon;
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                CGRect rect = [button convertRect:button.bounds toView:window];
                // 设置气泡的位置
                self.paopaoView.center = CGPointMake(CGRectGetMidX(rect), 0);
                CGRect tempRect = _paopaoView.frame;
                tempRect.origin.y = CGRectGetMaxY(rect) - self.paopaoView.bounds.size.height;
                self.paopaoView.frame = tempRect;
                
                [window addSubview:_paopaoView];
            }else {
                [self.paopaoView removeFromSuperview];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self.paopaoView removeFromSuperview];
            break;
        }
        default:
            break;
    }
}

- (void)emoticonButtonClick:(CLEmoticonButton *)sender {
    CLEmoiconModel *emoticonModel = sender.emoticon;
    
    // 在点击的时候也要现实小气泡
    CLEmoticonPaopaoView *paopaoView = [CLEmoticonPaopaoView PaopaoView];
    paopaoView.emoticon = emoticonModel;
    
    // 发送通知，显示在textView上
    [[NSNotificationCenter defaultCenter] postNotificationName:CLEmoticonButtonDidSelectedNotification object:nil userInfo:@{@"emoticon": emoticonModel}];
    
    [[CLEmoticonKeyboardViewModel sharedManeger] saveEmoticonToRecent:emoticonModel];
    
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    CGRect rect = [sender convertRect:sender.bounds toView:window];
    // 设置气泡的位置
    paopaoView.center = CGPointMake(CGRectGetMidX(rect), 0);
    CGRect tempRect = paopaoView.frame;
    tempRect.origin.y = CGRectGetMaxY(rect) - paopaoView.bounds.size.height;
    paopaoView.frame = tempRect;
    
    [window addSubview:paopaoView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [paopaoView removeFromSuperview];
    });
}

- (void)deleteButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:CLEmoticonButtonDidDeletedNotification object:nil];
}

#pragma mark - 添加表情按钮
- (CLEmoticonButton *)getButtonWithLocation:(CGPoint)loaction {
    for (CLEmoticonButton *button in self.emoticonButtons) {
        if (CGRectContainsPoint(button.frame, loaction)) {
            return button;
        }
    }
    return nil;
}

- (void)addChildButtons {
    for (NSInteger i = 0; i < CLEmoticonKeyboardPageEmoticonCount; i++) {
        CLEmoticonButton *btn = [CLEmoticonButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(emoticonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:34];
        [self.contentView addSubview:btn];
        [self.emoticonButtons addObject:btn];
    }
}

#pragma mark - setter方法，更新视图数据

- (void)setEmoticons:(NSArray<CLEmoiconModel *> *)emoticons {
    _emoticons = emoticons;
   
    for (CLEmoticonButton *button in self.emoticonButtons) {
        button.hidden = true;
    }
    
    [emoticons enumerateObjectsUsingBlock:^(CLEmoiconModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CLEmoticonButton *button = self.emoticonButtons[idx];
        button.hidden = false;
        button.emoticon = obj;
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
//    _messageLabel.text = [NSString stringWithFormat:@"第%zd组，第%zd页",indexPath.section, indexPath.row];
    [_messageLabel sizeToFit];
    self.messageLabel.hidden = indexPath.section;
}

#pragma mark - 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemW = self.bounds.size.width / 7;
    CGFloat itemH = (self.bounds.size.height - 20) / 3;
    
    [self.emoticonButtons enumerateObjectsUsingBlock:^(CLEmoticonButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger col = idx % 7;
        NSInteger row = idx / 7;
        CGFloat x = col * itemW;
        CGFloat y = row * itemH;
        
        obj.frame = CGRectMake(x, y, itemW, itemH);
    }];
    self.deleteButton.frame = CGRectMake(self.contentView.frame.size.width - itemW, itemH * 2, itemW, itemH);
}

#pragma mark - 懒加载
- (NSMutableArray *)emoticonButtons {
    if (!_emoticonButtons) {
        _emoticonButtons = [NSMutableArray array];
    }
    return _emoticonButtons;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
    }
    return _deleteButton;
}

- (CLEmoticonPaopaoView *)paopaoView {
    if (!_paopaoView) {
        _paopaoView = [CLEmoticonPaopaoView PaopaoView];
    }
    return _paopaoView;
}

@end
