//
//  CLHomeViewController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLHomeViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "CLTempViewController.h"
#import "CLVisitorView.h"
#import "CLStatusCell.h"
#import "CLHomeViewModel.h"
#import "CLRefreshControl.h"

static NSString *homeCell = @"home_cell";
@interface CLHomeViewController ()

@property (strong, nonatomic) CLHomeViewModel *homeViewModel;
/**
 上拉加载
 */
@property (strong, nonatomic) UIActivityIndicatorView *pullUpView;
@property (strong, nonatomic) NSArray<CLStatusViewModel *> *statusArray;
/**
 下拉刷新
 */
@property (strong, nonatomic) CLRefreshControl *clRefreshControl;
@property (strong, nonatomic) UILabel *pullDownTipLabel;

@end

@implementation CLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isUserLogin) {
        [(CLVisitorView *)self.view setVisitorViewInfoWithImageName:nil message:@"关注一些人，回这里看看有什么惊喜"];
        return;
    }
    
    [self setupUI];
    [self loadData];
}

- (void)setupUI {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil imageName:@"navigationbar_friendsearch" target:self action:@selector(push)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil imageName:@"navigationbar_pop" target:self action:@selector(push)];
    
    // 注册
    [self.tableView registerClass:[CLStatusCell class] forCellReuseIdentifier:homeCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 设置行高
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    
    self.tableView.tableFooterView = self.pullUpView;
    
    // 添加下拉刷新
    _clRefreshControl = [[CLRefreshControl alloc] init];
    
    [self.view addSubview:_clRefreshControl];
    [_clRefreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    // 添加下拉刷新提示的label
    [self.navigationController.view insertSubview:self.pullDownTipLabel belowSubview:self.navigationController.navigationBar];
    CGRect rect = _pullDownTipLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame) - _pullDownTipLabel.frame.size.height;
    self.pullDownTipLabel.frame = rect;
    
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [self.homeViewModel loadDataWithIsPullUp:_pullUpView.isAnimating completion:^(NSArray *statusArray, NSInteger count) {
        weakSelf.statusArray = statusArray;
        [weakSelf.tableView reloadData];
        
        if (!_pullUpView.isAnimating) {
            [self showTipLabelWithCount:count];
        }
        
        [_pullUpView stopAnimating];
        // 数据加载回来后结束刷新
        [_clRefreshControl endRefreshing];
    }];
}

// 下拉刷新提示的框的文字
- (void)showTipLabelWithCount:(NSInteger)count {
    if (_pullDownTipLabel.hidden == false) {
        return;
    }
    
    NSString *str = count == 0 ? @"没有微博数据" : [NSString stringWithFormat:@"%zd条微博数据",count];
    _pullDownTipLabel.text = str;
    _pullDownTipLabel.hidden = false;
    
    [UIView animateWithDuration:1 animations:^{
        self.pullDownTipLabel.transform = CGAffineTransformMakeTranslation(0, self.pullDownTipLabel.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:1 options:0 animations:^{
            self.pullDownTipLabel.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.pullDownTipLabel.hidden = true;
        }];
    }];
}

- (void)push {
    CLTempViewController *vc = [[CLTempViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusArray.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLStatusCell *cell =[tableView dequeueReusableCellWithIdentifier:homeCell forIndexPath:indexPath];
    cell.statusViewModel = self.statusArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.statusArray.count - 1 && _pullUpView.isAnimating == false) {
        [_pullUpView startAnimating];
        [self loadData];
    }
}

#pragma mark -- 懒加载
- (CLHomeViewModel *)homeViewModel {
    if (!_homeViewModel) {
        _homeViewModel = [[CLHomeViewModel alloc] init];
    }
    return _homeViewModel;
}

- (UIActivityIndicatorView *)pullUpView {
    if (!_pullUpView) {
        _pullUpView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _pullUpView.color = [UIColor blackColor];
    }
    return _pullUpView;
}

- (UILabel *)pullDownTipLabel {
    if (!_pullDownTipLabel) {
        _pullDownTipLabel = [UILabel labelWithText:@"微博数量" andTextColor:[UIColor whiteColor] andFontSize:14];
        _pullDownTipLabel.backgroundColor = [UIColor orangeColor];
        _pullDownTipLabel.textAlignment = NSTextAlignmentCenter;
        _pullDownTipLabel.hidden = true;
        _pullDownTipLabel.frame = CGRectMake(0, 0, CLScreenW, 44);
    }
    return _pullDownTipLabel;
}

@end
