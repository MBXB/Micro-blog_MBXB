//
//  CLUserAccountViewModel.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import "CLUserAccountViewModel.h"
#import "CLOAuthViewController.h"
#import "CLNetWorkTools.h"
#import "CLUserAccount.h"

@interface CLUserAccountViewModel ()

@end

@implementation CLUserAccountViewModel

+ (instancetype)sharedManager {
    static CLUserAccountViewModel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.account = [self loadUserAccount];
    }
    return self;
}

- (BOOL)isUserLogin {
    
    // 如果accessToken存在，并且没有过期就能登录
    if(self.account.access_token != nil && self.isExpires == false) {
        return true;
    }
    return false;
}

- (BOOL)isExpires {
    if ([self.account.expiresDate compare:[NSDate date]] == NSOrderedDescending) {
        return false;
    }
    return true;
}

- (void)loadAccessTokenWithCode:(NSString *)code completion: (void(^)(BOOL isSuccess))completion {
    NSString *urlString = @"https://api.weibo.com/oauth2/access_token";
    
    NSDictionary *params = @{
                  @"client_id": WB_APPKEY,
                  @"client_secret": WB_APPSECRET,
                  @"grant_type": @"authorization_code",
                  @"code": code,
                  @"redirect_uri": WB_REDIRECTURI
                  };
    [[CLNetWorkTools sharedTools] requestWithHttpMethod:HTTPMethodPOST UrlString:urlString parameter:params completion:^(id response, NSError *error) {
        if (response == nil || error != nil) {
            NSLog(@"%@",error);
            completion(false);
            return;
        }
        
        CLUserAccount *account = [CLUserAccount userAccountWithdict:response];
        
        [self loadUserInfoWithUserAccount:account completion:completion];
    }];
}

- (void)loadUserInfoWithUserAccount:(CLUserAccount *)account completion:(void(^)(BOOL isSuccess))completion {
    NSString *urlString = @"https://api.weibo.com/2/users/show.json";
    NSDictionary *params = @{@"access_token": account.access_token, @"uid": account.uid};
    
    [[CLNetWorkTools sharedTools] requestWithHttpMethod:HTTPMethodGET UrlString:urlString parameter:params completion:^(id response, NSError *error) {
        if (response == nil || error != nil) {
            NSLog(@"%@",error);
            completion(false);
            return;
        }
       
        account.name = response[@"name"];
        account.profile_image_url = response[@"profile_image_url"];
        account.avatar_large = response[@"avatar_large"];
        
        self.account = account;
        // 归档
        [self saveAccount:account];
        NSLog(@"归档数据为：%@",account);
        completion(true);
    }];
}

- (NSString *)access_token {
    return self.account.access_token;
}

// 归档
- (void)saveAccount:(CLUserAccount *)account {
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject stringByAppendingPathComponent:@"userAccount.archive"];
    NSLog(@"%@",file);
    [NSKeyedArchiver archiveRootObject:account toFile:file];
}

// 解档
- (CLUserAccount *)loadUserAccount {
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject stringByAppendingPathComponent:@"userAccount.archive"];
    CLUserAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    return account;
}

@end
