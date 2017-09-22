//
//  UIImage+Additions.m
//  YHTodo
//
//  Created by Oboe_b on 16/2/24.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage *)tintImageWithColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);

    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);

    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    UIImage *img = [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
    return img;
}

- (void)c {
    UIButton *btn;
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

// 获取屏幕截图
+ (UIImage *)getScreenSnap {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0);
    
    //将window的内容渲染到上下文中
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:false];
    
    //获取上下文种的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

// 缩放
- (UIImage *)scaleToWidth:(CGFloat)width {
    if (self.size.width <= width) {
        return self;
    }
    
    CGFloat height = self.size.height * (width / self.size.width);
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
