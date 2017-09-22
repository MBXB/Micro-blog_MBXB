//
//  CLMatchResult.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/11.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLMatchResult.h"

@implementation CLMatchResult

- (instancetype)initWithCaptureString:(NSString *)captureString CaptureRange:(NSRange)captureRange {
    if (self = [super init]) {
        _captureRange = captureRange;
        _captureString = captureString;
    }
    return self;
}

@end
