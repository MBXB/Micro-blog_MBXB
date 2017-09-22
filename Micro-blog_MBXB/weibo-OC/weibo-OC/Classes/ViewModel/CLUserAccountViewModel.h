//
//  CLUserAccountViewModel.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import <Foundation/Foundation.h>
@class CLUserAccount;

@interface CLUserAccountViewModel : NSObject

/**
 用户是否登录
 */
@property (assign, nonatomic) BOOL isUserLogin;

/**
 口令是否过期
 */
@property (assign, nonatomic) BOOL isExpires;

@property (strong, nonatomic) CLUserAccount *account;

/**
 获取口令
 */
@property (copy, nonatomic, readonly) NSString *access_token;

+ (instancetype)sharedManager;

- (void)loadAccessTokenWithCode:(NSString *)code completion: (void(^)(BOOL isSuccess))completion;

@end
