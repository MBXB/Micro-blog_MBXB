//
//  CLVisitorViewController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/30.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLVisitorViewController.h"
#import "CLVisitorView.h"
#import "UIBarButtonItem+Addition.h"
#import "CLOAuthViewController.h"
#import "CLNavigationViewController.h"
#import "CLUserAccountViewModel.h"

@interface CLVisitorViewController ()

@end

@implementation CLVisitorViewController

-(void)loadView {
    self.isUserLogin = [CLUserAccountViewModel sharedManager].isUserLogin;
    
    if (self.isUserLogin) {
        [super loadView];
    }else {
        [self setupView];
    }
}

- (void)setupView {
    CLVisitorView *visitorView = [[CLVisitorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    visitorView.loginBlock = ^{
        [self visitorViewWillLogin];
    };
    self.view = visitorView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" imageName:nil target:self action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" imageName:nil target:self action:@selector(visitorViewWillLogin)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -- (代理)点击事件
- (void)visitorViewWillLogin {
//    NSLog(@"登陆");
    CLOAuthViewController *vController = [[CLOAuthViewController alloc] init];
    CLNavigationViewController *navController = [[CLNavigationViewController alloc] initWithRootViewController:vController];
    [self presentViewController:navController animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
