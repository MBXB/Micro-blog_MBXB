//
//  SQLiteManager.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/12.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "SQLiteManager.h"

static NSString *dbName = @"status.db";

@interface SQLiteManager ()

@end

@implementation SQLiteManager

+ (instancetype)sharedManager {
    static SQLiteManager *instance;
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
        // 打开数据库
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject stringByAppendingPathComponent:dbName];
        NSLog(@"数据库额路径是：%@",path);
        
        // 判断是否有数据库文件，有就打开，没有就创建
        self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        // 创建一个表
        [self createTabel];
    }
    return self;
}

- (void)createTabel {
    NSURL *pathURL = [[NSBundle mainBundle] URLForResource:@"db.sql" withExtension:nil];
    // 取到内容
    NSString *sql = [NSString stringWithContentsOfURL:pathURL encoding:NSUTF8StringEncoding error:nil];
    
    // 执行sql语句
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeStatements:sql];
        if (result) {
            NSLog(@"创表成功");
        }else {
            NSLog(@"创表失败");
        }
    }];
}

// 通过一条sql语句查询数据库里面的内容，并将每一条数据转为字典返回
- (NSArray *)execRecordSetWithSQL:(NSString *)sql {
    NSMutableArray *result = [NSMutableArray array];
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        // 遍历结果，获取每一条数据
        while (resultSet.next) {
            // 初始化一个字典用来保存数据
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            // 列
            NSInteger colCount = resultSet.columnCount;
            for (int i = 0; i < colCount; i ++) {
                // 列名
                NSString *colName = [resultSet columnNameForIndex:i];
                // 值
                id colValue = [resultSet objectForColumnIndex:i];
                // 将值保存再字典里面
                [dict setObject:colValue forKey:colName];
            }
            [result addObject:dict];
        }
    }];
    return result;
}

@end
