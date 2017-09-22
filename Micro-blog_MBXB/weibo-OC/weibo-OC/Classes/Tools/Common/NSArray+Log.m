//
//  NSArray+Log.m
//  解决中文输出问题
//
//  Created by LEE on 16/8/4.
//  Copyright © 2016年 LEE. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)
-(NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *stringM = [NSMutableString string];
    
    [stringM appendFormat:@"\n ( \n"];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [stringM appendFormat:@"\t%@,\n",obj];
    }];
    
    [stringM appendFormat:@"\n ) \n"];

    return stringM;
    
    
}

@end

@implementation NSDictionary (Log)
-(NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *stringM = [NSMutableString string];
    
    [stringM appendFormat:@"\n ( \n"];
    
    [self enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [stringM appendFormat:@"\t%@ = %@ \n",key,obj];
        
    }];
    
    [stringM appendFormat:@"\n ) \n"];
    
    return stringM;
    
}


@end
