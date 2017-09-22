//
//  CLStatusViewModel.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import <UIKit/UIKit.h>
@class CLStatusModel;

@interface CLStatusViewModel : NSObject

@property (strong, nonatomic) CLStatusModel *model;

// 当前用户的会员图标
@property (strong, nonatomic) UIImage *memberImage;
// 认证图标
@property (strong, nonatomic) UIImage *avatatImage;
// 转发数
@property (copy, nonatomic) NSString *reposts_count;
// 评论数
@property (copy, nonatomic) NSString *comments_count;
// 表态数
@property (copy, nonatomic) NSString *attitudes_count;
// 转发人 + 转发微博
@property (copy, nonatomic) NSString *retweetStatusText;
// 格式化好的来源
@property (copy, nonatomic) NSString *sourceString;
// 格式化好的创建时间
@property (copy, nonatomic) NSString *createAtString;
// 原创微博的富文本
@property (copy, nonatomic) NSAttributedString *originalAttributedText;
// 转发微博的富文本
@property (copy, nonatomic) NSAttributedString *retweetAttributedText;

@end
