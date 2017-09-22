//
//  CLComposePictureView.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/7.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLComposePictureView.h"

NSString *composePictureCell = @"composePictureCell";

@interface CLComposePictureCell: UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) void (^deleteBlock)();

@end

@implementation CLComposePictureCell

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
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
    }];
    
    self.imageView = imageView;
    self.deleteButton = deleteButton;
    
}

- (void)deleteButtonClick:(UIButton *)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (_image == nil) {
        self.imageView.image = [UIImage imageNamed:@"compose_pic_add"];
        self.imageView.highlightedImage = [UIImage imageNamed:@"compose_pic_add_highlighted"];
    }else {
        self.imageView.image = image;
        self.imageView.highlightedImage = image;
    }
    self.deleteButton.hidden = image == nil;
}

@end

@interface CLComposePictureView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CLComposePictureView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self registerClass:[CLComposePictureCell class] forCellWithReuseIdentifier:composePictureCell];
    self.dataSource = self;
    self.delegate = self;
    
    if (_imageArray == nil) {
         _imageArray = [NSMutableArray array];
    }
    self.hidden = true;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat itemHW = (self.frame.size.width - 2 * CLitemMargin) / 3;
    layout.itemSize = CGSizeMake(itemHW, itemHW);
    layout.minimumLineSpacing = CLitemMargin;
    layout.minimumInteritemSpacing = CLitemMargin;
}

- (void)addImageWithImgae:(UIImage *)image {
    if (_imageArray.count < 9) {
        [_imageArray addObject:image];
        [self reloadData];
    }else {
        [SVProgressHUD showErrorWithStatus:@"图片数量超出限制"];
    }
}

#pragma mark -- 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (_imageArray.count == 0 || _imageArray.count == 9)? _imageArray.count : _imageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLComposePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:composePictureCell forIndexPath:indexPath];
    
    self.hidden = self.imageArray.count == 0;
    if (indexPath.row < _imageArray.count) {
        cell.image = _imageArray[indexPath.row];
    }else {
        cell.image = nil;
    }
    
    cell.deleteBlock = ^{
        [self.imageArray removeObjectAtIndex:indexPath.item];
        [self reloadData];
        self.hidden = self.imageArray.count == 0;
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if (indexPath.row == _imageArray.count) {
        if (self.addImageBlock) {
            self.addImageBlock();
        }
    }
}

@end


