//
//  CLTextView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/7.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLTextView.h"

@interface CLTextView ()

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation CLTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.placeholderLabel];
    
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(5);
        make.top.equalTo(self).mas_offset(8);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_lessThanOrEqualTo(self.bounds.size.width - 2 * 5);
    }];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel labelWithText:@"呵呵" andTextColor:[UIColor lightGrayColor] andFontSize:12];
        _placeholderLabel.numberOfLines = 0;
    }
    return _placeholderLabel;
}

@end
