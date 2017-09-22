//
//  CLStatusModel.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLStatusModel.h"
#import "CLStatusPictureModel.h"

@implementation CLStatusModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{ @"pic_urls": [CLStatusPictureModel class] };
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
