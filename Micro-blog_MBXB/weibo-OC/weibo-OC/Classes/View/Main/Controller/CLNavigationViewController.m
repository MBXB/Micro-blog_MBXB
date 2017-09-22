//
//  CLNavigationViewController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLNavigationViewController.h"
#import "UIBarButtonItem+Addition.h"

@interface CLNavigationViewController ()

@end

@implementation CLNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSString *title = @"返回";
    if (self.viewControllers.count > 0) {
        if(self.viewControllers.count == 1) {
            title = self.childViewControllers[0].title;
        }
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title imageName:@"navigationbar_back_withtext" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:true];
}

@end
