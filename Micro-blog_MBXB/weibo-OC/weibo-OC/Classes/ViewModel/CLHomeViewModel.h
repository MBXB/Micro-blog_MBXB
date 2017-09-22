//
//  CLHomeViewModel.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/3.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import <Foundation/Foundation.h>

typedef void(^completion)(NSArray *statusArray, NSInteger count);

@interface CLHomeViewModel : NSObject

- (void)loadDataWithIsPullUp:(BOOL)isPullUp completion:(completion)completion;

@end
