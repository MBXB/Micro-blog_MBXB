//
//  CLComposeButton.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/6.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLComposeButton.h"

@implementation CLComposeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.width, self.frame.size.width, self.frame.size.height - self.frame.size.width);
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
