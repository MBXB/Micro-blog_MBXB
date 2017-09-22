//
//  CLUserModel.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUserModel : NSObject

// 昵称
@property (copy, nonatomic) NSString *name;
// 用户头像地址
@property (copy, nonatomic) NSString *profile_image_url;
// 用户认证:
@property (assign, nonatomic) NSInteger verified_type;
// 会员等级
@property (assign, nonatomic) NSInteger mbrank;

@end
