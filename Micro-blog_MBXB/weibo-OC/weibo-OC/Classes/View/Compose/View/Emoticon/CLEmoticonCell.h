//
//  CLEmoticonCell.h
//  weibo-OC
//
//  Created by Oboe_b on 16/9/9.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLEmoiconModel;

@interface CLEmoticonCell : UICollectionViewCell

@property (assign, nonatomic) NSIndexPath* indexPath;
@property (strong, nonatomic) NSArray<CLEmoiconModel *> *emoticons;

@end
