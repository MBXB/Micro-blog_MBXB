//
//  CLComposePictureView.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/7.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLComposePictureView : UICollectionView

@property (copy, nonatomic) void (^addImageBlock)();
@property (strong, nonatomic) NSMutableArray *imageArray;

- (void)addImageWithImgae:(UIImage *)image;

@end

