//
//  CLNetWorkTools.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLNetWorkTools.h"

@implementation CLNetWorkTools

+ (instancetype)sharedTools {
    static CLNetWorkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
//        [instance.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//        [instance.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/xml", @"text/plain",nil];
    });
    return instance;
}

- (void)requestWithHttpMethod:(HTTPMethod)method UrlString:(NSString *)urlString parameter:(id)parameter completion:(void (^)(id, NSError *))completion {
    
    void(^success)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id response) {
        completion(response,nil);
    };
    
    void(^failure)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    };
    
    if (method == HTTPMethodGET) {
        [self GET:urlString parameters:parameter progress:nil success:success failure:failure];
    }else {
        [self POST:urlString parameters:parameter progress:nil success:success failure:failure];
    }

}

- (void)uploadWithURLString:(NSString *)URLString parameter:(id)parameter fileData:(NSDictionary<NSString *, NSData *> *)fileData completion:(void (^)(id, NSError *))completion {
    void(^success)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *task, id response) {
        completion(response,nil);
    };
    
    void(^failure)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    };
    
    [self POST:URLString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [fileData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:key fileName:URLString mimeType:@"application/octet-stream"];
        }];
        
    } progress:nil success:success failure:failure];
}

@end
