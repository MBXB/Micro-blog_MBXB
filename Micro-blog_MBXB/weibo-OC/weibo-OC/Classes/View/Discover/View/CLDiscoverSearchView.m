//
//  CLDiscoverSearchView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLDiscoverSearchView.h"

@implementation CLDiscoverSearchView

+ (instancetype)searchView {
    return [[NSBundle mainBundle]loadNibNamed:@"CLDiscoverSearchView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    if(cornerRadius > 0)
        self.layer.masksToBounds = true;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

@end
