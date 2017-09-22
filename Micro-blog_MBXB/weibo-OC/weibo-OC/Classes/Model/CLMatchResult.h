//
//  CLMatchResult.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/11.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMatchResult : NSObject
// 当前匹配到的字符串
@property (copy, nonatomic, readonly) NSString *captureString;
// 当前匹配到字符串的范围
@property (assign, nonatomic, readonly) NSRange captureRange;

- (instancetype)initWithCaptureString:(NSString *)captureString CaptureRange:(NSRange)captureRange;

@end
