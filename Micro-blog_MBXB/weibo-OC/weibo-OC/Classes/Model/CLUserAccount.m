//
//  CLUserAccount.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLUserAccount.h"

@interface CLUserAccount () <NSCoding>

@end

@implementation CLUserAccount

+ (instancetype)userAccountWithdict:(NSDictionary *)dict {
    CLUserAccount *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_access_token forKey:@"access_token"];
    [aCoder encodeObject:_expiresDate forKey:@"expiresDate"];
    [aCoder encodeObject:_profile_image_url forKey:@"profile_image_url"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_avatar_large forKey:@"avatar_large"];
    [aCoder encodeObject:_uid forKey:@"uid"];
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _access_token = [coder decodeObjectForKey:@"access_token"];
        _name = [coder decodeObjectForKey:@"name"];
        _expiresDate = [coder decodeObjectForKey:@"expiresDate"];
        _profile_image_url = [coder decodeObjectForKey:@"profile_image_url"];
        _avatar_large = [coder decodeObjectForKey:@"avatar_large"];
        _uid = [coder decodeObjectForKey:@"uid"];
        
    }
    return self;
}

- (void)setExpires_in:(NSTimeInterval)expires_in {
    _expires_in = expires_in;
    self.expiresDate = [NSDate dateWithTimeIntervalSinceNow:expires_in];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (NSString *)description {
    return [self dictionaryWithValuesForKeys:@[@"access_token", @"name", @"avatar_large", @"uid", @"expiresDate", @"expires_in"]].description;
}
@end
