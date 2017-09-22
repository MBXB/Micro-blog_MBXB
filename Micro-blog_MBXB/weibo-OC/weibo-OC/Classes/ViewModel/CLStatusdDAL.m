//
//  CLStatusdDAL.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/12.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import "CLStatusdDAL.h"
#import "SQLiteManager.h"
#import "CLUserAccountViewModel.h"
#import "CLUserAccount.h"

static NSTimeInterval cacheMaxTimeInterval = -7 * 60 * 60 * 24;

@interface CLStatusdDAL ()

@end

@implementation CLStatusdDAL

// 供外界调用的加载数据的方法
+ (void)loadDataWithMaxId:(int64_t)maxId sinceId:(int64_t)sinceId completion:(void(^)(NSArray *array))completion {
    NSArray *result = [self checkDataWithMaxId:maxId sinceId:sinceId];
    if (result.count > 0) {
        completion(result);
        return;
    }
    
    // 没有就从网络上加载数据
    NSString *urlString = urlString = @"https://api.weibo.com/2/statuses/friends_timeline.json";
    NSDictionary *params = @{ @"max_id": @(maxId).description, @"since_id": @(sinceId).description ,@"access_token": [CLUserAccountViewModel sharedManager].access_token};
    
    [[CLNetWorkTools sharedTools] requestWithHttpMethod:HTTPMethodGET UrlString:urlString parameter:params completion:^(id response, NSError *error) {
        if (response == nil || error != nil) {
            NSLog(@"请求出错: %@",error);
            return ;
        }
        NSArray *dictArray = response[@"statuses"];
        
        // 缓存在本地数据库
        [self cacheData:dictArray];
        
        completion(dictArray);
    }];
    
}

// 检查是否有数据
+ (NSArray *)checkDataWithMaxId:(int64_t)maxId sinceId:(int64_t)sinceId {
    NSMutableString *sql = [NSMutableString stringWithString:@"SELECT statusid, status, uid FROM T_Status\n"];
    
    if (maxId > 0) {
        [sql appendFormat:@"WHERE statusid <= %zd\n",maxId];
    }else {
        [sql appendFormat:@"WHERE statusid > %zd\n",sinceId];
    }
    
    // 排序
    [sql appendFormat:@"ORDER BY statusid DESC\n"];
    
    // 限制微博数量
    [sql appendFormat:@"LIMIT 20;"];
    
    NSArray *sqlResult = [[SQLiteManager sharedManager] execRecordSetWithSQL:sql];
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *value in sqlResult) {
        NSData *data = value[@"status"];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [result addObject:dict];
    }
    return result.copy;
}

// 缓存从网络上加载的数据
+ (void)cacheData:(NSArray *)statues {
    NSString *uid = [CLUserAccountViewModel sharedManager].account.uid;
    if ( uid == nil)
        return ;
    
    NSString *sql = @"INSERT INTO T_Status (statusid, status, uid) VALUES (?, ?, ?);";
    
    [[SQLiteManager sharedManager].queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSDictionary *value in statues) {
            id statusid = value[@"id"];
            
            NSData *status = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
            BOOL result = [db executeUpdate:sql withArgumentsInArray:@[statusid, status, uid]];
            if (result == false) {
                *rollback = true;
                break;
            }
        }
    }];
}

+ (void)clearCache {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:cacheMaxTimeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *sql = @"DELETE FROM T_Status WHERE createDate < ?";
    
    [[SQLiteManager sharedManager].queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sql withArgumentsInArray:@[dateString]];
        if (result) {
            NSLog(@"删除成功，成功删除%zd条",[db changes]);
        }else {
            NSLog(@"删除失败");
        }
    }];
}

@end
