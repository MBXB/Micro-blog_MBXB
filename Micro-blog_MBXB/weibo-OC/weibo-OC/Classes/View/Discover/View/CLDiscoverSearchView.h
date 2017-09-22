//
//  CLDiscoverSearchView.h
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CLDiscoverSearchView : UIButton

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
//@property (assign, nonatomic) IBInspectable BOOL masksToBounds;

+ (instancetype)searchView;

@end
