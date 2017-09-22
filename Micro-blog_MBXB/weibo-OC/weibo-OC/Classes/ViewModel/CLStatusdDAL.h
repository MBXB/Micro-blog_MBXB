//
//  CLStatusdDAL.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/12.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import <UIKit/UIKit.h>

@interface CLStatusdDAL : NSObject

+ (void)loadDataWithMaxId:(int64_t)maxId sinceId:(int64_t)sinceId completion:(void(^)(NSArray *array))completion;

// 清除缓存
+ (void)clearCache;

@end
