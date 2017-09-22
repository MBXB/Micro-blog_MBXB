//
//  CLEmotionKeyboard.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/8.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLEmotionKeyboard.h"
#import "CLEmoticonToolBar.h"
#import "CLEmoticonCell.h"
#import "CLEmoticonKeyboardViewModel.h"
#import "CLEmoticonCell.h"

static NSString *CLEmotionCollectionViewCellId = @"CLEmotionCollectionView_cell";
@interface CLEmotionKeyboard () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) CLEmoticonToolBar *emoticonToolBar;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation CLEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
    
    [self addSubview:self.emoticonToolBar];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    
    // 自动布局
    [_emoticonToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(37);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(_emoticonToolBar.mas_top);
    }];
   
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_collectionView);
        make.bottom.equalTo(_collectionView);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
        self.emoticonToolBar.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self setPageControlWithIndexPaht:[NSIndexPath indexPathForRow:0 inSection:1]];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:CLEmoticonReloadDataNotification object:nil];
}

- (void) reloadData {
    
    CLEmoticonCell *cell = [self.collectionView visibleCells].firstObject;
    if ([self.collectionView indexPathForCell:cell].section == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)setPageControlWithIndexPaht:(NSIndexPath *)indexPath {
    self.pageControl.numberOfPages = [CLEmoticonKeyboardViewModel sharedManeger].allEmotions[indexPath.section].count;
    self.pageControl.currentPage = indexPath.row;
    self.pageControl.hidden = !indexPath.section;
}

#pragma mark -- 数据源/代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [CLEmoticonKeyboardViewModel sharedManeger].allEmotions.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [CLEmoticonKeyboardViewModel sharedManeger].allEmotions[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLEmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CLEmotionCollectionViewCellId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.emoticons = [CLEmoticonKeyboardViewModel sharedManeger].allEmotions[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray* cells = [self.collectionView visibleCells];
    
    if (cells.count == 2) {
        CLEmoticonCell *firstCell = cells.firstObject;
        CLEmoticonCell *lastCell = cells.lastObject;
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        // 获取第一个cell的中心店
        CGPoint firstPoint = CGPointMake(firstCell.center.x - scrollView.contentOffset.x, firstCell.center.y);
        // 判断第一个点的中心点是否再屏幕内
        NSIndexPath *indexPath;
        if (CGRectContainsPoint(screenRect, firstPoint)) {
            indexPath = [self.collectionView indexPathForCell:firstCell];
        }else {
            indexPath = [self.collectionView indexPathForCell:lastCell];
        }
        self.emoticonToolBar.selectedIndexPath = indexPath;
        [self setPageControlWithIndexPaht:indexPath];
    }
}

#pragma mark -- 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.bounces = false;
        _collectionView.pagingEnabled = true;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CLEmoticonCell class] forCellWithReuseIdentifier:CLEmotionCollectionViewCellId];
    }
    return _collectionView;
}

- (CLEmoticonToolBar *)emoticonToolBar {
    if (!_emoticonToolBar) {
        _emoticonToolBar = [[CLEmoticonToolBar alloc] init];
        __weak typeof(self) weakSelf = self;
        _emoticonToolBar.emotionTypeChangedBlock = ^(CLEmotionType type){
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:type] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
            [weakSelf setPageControlWithIndexPaht:[NSIndexPath indexPathForRow:0 inSection:type]];
        };
    }
    return _emoticonToolBar;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = false;
        [_pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
        [_pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
    }
    return _pageControl;
}

#pragma mark -- 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = self.collectionView.bounds.size;
}
@end
