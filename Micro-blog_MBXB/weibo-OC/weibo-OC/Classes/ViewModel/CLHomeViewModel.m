//
//  CLHomeViewModel.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import "CLHomeViewModel.h"
#import "CLUserAccountViewModel.h"
#import "CLStatusModel.h"
#import "CLStatusViewModel.h"
#import "CLStatusPictureModel.h"
#import "CLStatusdDAL.h"

@interface CLHomeViewModel ()

@property (strong, nonatomic) NSMutableArray<CLStatusViewModel *> *statusArray;

@end

@implementation CLHomeViewModel

- (void)loadDataWithIsPullUp:(BOOL)isPullUp completion:(completion)completion{
    NSString *urlString = urlString = @"https://api.weibo.com/2/statuses/friends_timeline.json";
    
    int64_t max_id = 0;
    int64_t since_id = 0;
    
    if (isPullUp) {
        // 上拉加载
        max_id = self.statusArray.lastObject.model.id - 1;
//        NSLog(@"微博刷新ID是：%zd",max_id);
    }else {
        // 下拉刷新
        since_id = self.statusArray.firstObject.model.id;
    }
    
    [CLStatusdDAL loadDataWithMaxId:max_id sinceId:since_id completion:^(NSArray *array) {
        
        NSArray *tempArray = [NSArray yy_modelArrayWithClass:[CLStatusModel class] json:array];
        NSMutableArray<CLStatusViewModel *> *modelArray = [NSMutableArray array];
        for (CLStatusModel *model in tempArray) {
            CLStatusViewModel *statuViewModel = [[CLStatusViewModel alloc] init];
            statuViewModel.model = model;
            [modelArray addObject:statuViewModel];
        }
        NSLog(@"新加载的数据共有%zd",modelArray.count);
        if (self.statusArray == nil) {
            self.statusArray = [NSMutableArray array];
        }
        
        if (isPullUp) {
            [self.statusArray addObjectsFromArray:modelArray];
        }else {
            self.statusArray = [modelArray arrayByAddingObjectsFromArray:self.statusArray.copy].mutableCopy;
        }
        [self cacheSingleImageWithModel:modelArray completion:completion];
    }];
}

// 判断是否为单张图片
- (void)cacheSingleImageWithModel:(NSArray<CLStatusViewModel *> *)status completion:(completion)completion {
    
    dispatch_group_t group = dispatch_group_create();
    
    for (CLStatusViewModel *value in status) {
        NSArray<CLStatusPictureModel *> *pic_urls = (value.model.pic_urls.count == 1)? value.model.pic_urls : value.model.retweeted_status.pic_urls;
        if (pic_urls.count != 1) {
            continue;
        }
        
        NSString *urlString = pic_urls.lastObject.thumbnail_pic;
        NSURL *url = [NSURL URLWithString:urlString];
        
        dispatch_group_enter(group);
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(_statusArray.copy, status.count);
    });
}

@end
