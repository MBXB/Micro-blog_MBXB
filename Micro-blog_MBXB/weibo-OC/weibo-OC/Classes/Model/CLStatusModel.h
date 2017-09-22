//
//  CLStatusModel.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLUserModel;
@class CLStatusPictureModel;

@interface CLStatusModel : NSObject

/// 微博的创建时间
@property (copy, nonatomic) NSDate *created_at;
/// 微博的Id
@property (assign, nonatomic) int64_t id;
/// 微博内容
@property (copy, nonatomic) NSString *text;
/// 微博的来源
@property (copy, nonatomic) NSString *source;

@property (strong, nonatomic) CLUserModel *user;

// 转发数
@property (assign, nonatomic) NSInteger reposts_count;
// 评论数
@property (assign, nonatomic) NSInteger comments_count;
// 表态数
@property (assign, nonatomic) NSInteger attitudes_count;
// 转发微博
@property (strong, nonatomic) CLStatusModel *retweeted_status;
// 缩略图
@property (strong, nonatomic) NSArray<CLStatusPictureModel *> *pic_urls;

@end
