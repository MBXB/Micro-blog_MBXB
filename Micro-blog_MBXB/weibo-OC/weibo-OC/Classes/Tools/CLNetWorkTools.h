//
//  CLNetWorkTools.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
};

@interface CLNetWorkTools : AFHTTPSessionManager

+ (instancetype)sharedTools;

- (void)requestWithHttpMethod:(HTTPMethod)method UrlString:(NSString *)urlString parameter:(id)parameter completion:(void(^)(id response, NSError *error))completion;

- (void)uploadWithURLString:(NSString *)URLString parameter:(id)parameter fileData:(NSDictionary<NSString *, NSData *> *)fileData completion:(void (^)(id response, NSError *error))completion;
@end
