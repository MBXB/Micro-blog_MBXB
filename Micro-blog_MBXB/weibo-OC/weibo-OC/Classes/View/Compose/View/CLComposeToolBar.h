//
//  CLComposeToolBar.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/7.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLComposeToolBar;

typedef NS_ENUM(NSUInteger, CLComposeToolBarType) {
    CLComposeToolBarTypePicture = 0,
    CLComposeToolBarTypeMention,
    CLComposeToolBarTypeTrend,
    CLComposeToolBarTypeEmoticon,
    CLComposeToolBarTypeAdd,
};

@protocol CLComposeToolBarDelegate <NSObject>

- (void)composeToolBarWithToolBar:(CLComposeToolBar *)toolBar composeToolBarType:(CLComposeToolBarType)type;

@end

@interface CLComposeToolBar : UIView

@property (assign, nonatomic) BOOL isSystemKeyboard;
@property (weak, nonatomic) id<CLComposeToolBarDelegate> delegate;

@end
