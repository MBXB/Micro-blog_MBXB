//
//  UILabel+Addition.m
//  生活圈
//
//  Created by heima on 16/6/24.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

+ (instancetype)labelWithText:(NSString*)text andTextColor:(UIColor*)textColor andFontSize:(CGFloat)fontSize
{
    UILabel* label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    [label sizeToFit];
    return label;
}

@end
