//
//  CLTabBar.h
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTabBar : UITabBar

@property (copy, nonatomic) void (^composeButtonClick)();

@end
