//
//  CLStatusPictureView.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/4.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLStatusPictureModel;

@interface CLStatusPictureView : UICollectionView

@property (strong, nonatomic) NSArray<CLStatusPictureModel *> *pic_urls;

@end
