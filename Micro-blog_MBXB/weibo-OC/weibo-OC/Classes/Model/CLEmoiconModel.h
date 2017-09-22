//
//  CLEmoiconModel.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/8.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLEmoiconModel : NSObject <NSCoding>

/**
 表情描述的字符串
 */
@property (copy, nonatomic) NSString *chs;
/**
 繁体的描述
 */
@property (copy, nonatomic) NSString *cht;
/**
 图片的名字
 */
@property (copy, nonatomic) NSString *png;
/**
 代表图片的类型，0 表示为图片表情，1为emoji表情
 */
@property (assign, nonatomic) NSInteger type;
/**
 emoji表情
 */
@property (copy, nonatomic) NSString *code;
/**
 代表当前的图片是在哪个文件夹
 */
@property (copy, nonatomic) NSString *path;
@end
