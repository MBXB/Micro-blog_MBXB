//
//  CLTempViewController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLTempViewController.h"
#import "UIBarButtonItem+Addition.h"

@implementation CLTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"PUSH" imageName:nil target:self action:@selector(push)];
}

- (void)push {
    [self.navigationController pushViewController:[CLTempViewController new] animated:YES];
}

@end
