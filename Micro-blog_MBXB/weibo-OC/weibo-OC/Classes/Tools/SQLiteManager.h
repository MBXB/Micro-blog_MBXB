//
//  SQLiteManager.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/12.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SQLiteManager : NSObject

// 全局操作的队列
@property (strong, nonatomic) FMDatabaseQueue *queue;

+ (instancetype)sharedManager;

// 查询，并返回一个字典数组
- (NSArray *)execRecordSetWithSQL:(NSString *)sql;

@end
