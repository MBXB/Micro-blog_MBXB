//
//  CLEmoticonPaopaoView.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/9.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLEmoiconModel.h"

@interface CLEmoticonPaopaoView : UIView

@property (strong, nonatomic) CLEmoiconModel *emoticon;

+ (instancetype)PaopaoView;

@end
