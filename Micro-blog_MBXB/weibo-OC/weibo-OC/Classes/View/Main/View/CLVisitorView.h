//
//  CLVisitorView.h
//  weibo-OC
//
//  Created by Oboe_b on 16/8/30.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLVisitorView : UIView

@property (copy, nonatomic) void (^loginBlock)();

- (void)setVisitorViewInfoWithImageName:(NSString *)imageName message:(NSString *)message;

@end
