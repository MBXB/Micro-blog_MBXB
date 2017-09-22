//
//  CLUserAccount.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLUserAccount : NSObject

/**
 返回的口令
 */
@property (copy, nonatomic) NSString *access_token;
/**
 过期时间
 */
@property (assign, nonatomic) NSTimeInterval expires_in;
/**
 过期的具体时间
 */
@property (strong, nonatomic) NSDate *expiresDate;
/**
 小头像
 */
@property (copy, nonatomic) NSString *profile_image_url;
/**
 大头像
 */
@property (copy, nonatomic) NSString *avatar_large;
/**
 昵称
 */
@property (copy, nonatomic) NSString *name;
/**
 用户id
 */
@property (copy, nonatomic) NSString *uid;

+ (instancetype)userAccountWithdict:(NSDictionary *)dict;

@end
