//
//  CLStatusPictureView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/4.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLStatusPictureView.h"
#import "CLStatusPictureModel.h"

static NSString *pictureCell = @"pictureCell";

@interface CLPictureCell: UICollectionViewCell

@property (strong, nonatomic) CLStatusPictureModel *model;
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation CLPictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = true;
    self.imageView = imageView;
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

// 获取显示的图片
- (void)setModel:(CLStatusPictureModel *)model {
    _model = model;
    NSString *str = model.thumbnail_pic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

@end

@interface CLStatusPictureView () <UICollectionViewDataSource>

@end

@implementation CLStatusPictureView

- (void)setPic_urls:(NSArray<CLStatusPictureModel *> *)pic_urls {
    _pic_urls = pic_urls;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self calcSizeWithCount:pic_urls.count]);
    }];
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:250.0 / 255 alpha:1];
    self.dataSource = self;
    
    //注册
    [self registerClass:[CLPictureCell class] forCellWithReuseIdentifier:pictureCell];
    
    // 设置cell的布局
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(CLitemWH, CLitemWH);
    layout.minimumLineSpacing = CLitemMargin;
    layout.minimumInteritemSpacing = CLitemMargin;
}

#pragma mark -- 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureCell forIndexPath:indexPath];
    CLStatusPictureModel *pictureModel = self.pic_urls[indexPath.row];
    cell.model = pictureModel;
    return cell;
}


#pragma mark -- 设置collectionView的大小
// 设置collectionView的大小
- (CGSize)calcSizeWithCount:(NSInteger)count {
    
    if (count == 1) {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.pic_urls.firstObject.thumbnail_pic];
        
        CGSize size = image.size;
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize result = CGSizeMake(scale * size.width, scale * size.height);
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        layout.itemSize = result;
        return result;
    }
    
    // 列
    NSInteger col = count == 4? 2 : (count > 3? 3 : count);
    
    //行
    NSInteger row = (count - 1) / 3 + 1;
    
    //设置collectionView的宽高
    CGFloat width = CLitemWH * (CGFloat)col + CLitemMargin * (CGFloat)(col - 1);
    CGFloat height = CLitemWH * (CGFloat)row + CLitemMargin * (CGFloat)(row - 1);
    
    // 重新设置每个cell的大小
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(CLitemWH, CLitemWH);
    
    CGSize size = CGSizeMake(width, height);
    return size;
}

@end


