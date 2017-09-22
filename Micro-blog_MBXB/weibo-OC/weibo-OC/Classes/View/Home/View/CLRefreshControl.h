//
//  CLRefreshControl.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/4.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLRefreshType) {
    CLRefreshTypeNormal,
    CLRefreshTypePulling,
    CLRefreshTypeRefreshing,
};

@interface CLRefreshControl : UIControl

- (void)endRefreshing;

@end
