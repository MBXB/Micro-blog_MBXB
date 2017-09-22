//
//  NSObject+Formula.h
//  YHRule
//
//  Created by Oboe_b on 15/12/22.
//  Copyright © 2015年 Oboe_b. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

struct YHValue {
    CGFloat startValue;
    CGFloat endValue;
};
typedef struct YHValue YHValue;

static inline YHValue
YHValueMake(CGFloat startValue, CGFloat endValue)
{
    YHValue value;
    value.startValue = startValue;
    value.endValue = endValue;
    return value;
}

@interface NSObject (Formula)

+ (CGFloat)resultWithConsult:(CGFloat)consule andResultValue:(YHValue)resultValue andConsultValue:(YHValue)consultValue;

@end
