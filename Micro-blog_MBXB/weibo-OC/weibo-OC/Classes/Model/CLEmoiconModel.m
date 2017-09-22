//
//  CLEmoiconModel.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/8.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLEmoiconModel.h"

@implementation CLEmoiconModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        [self yy_modelInitWithCoder:coder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [self yy_modelEncodeWithCoder:coder];
}

@end
