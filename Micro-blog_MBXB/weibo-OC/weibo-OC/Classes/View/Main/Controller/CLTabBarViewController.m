//
//  CLTabBarViewController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLNavigationViewController.h"
#import "CLTabBarViewController.h"
#import "CLTabBar.h"
#import "CLComposeView.h"

@interface CLTabBarViewController ()

@end

@implementation CLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义TabBar
    CLTabBar *tabBar = [[CLTabBar alloc] init];
    
    tabBar.composeButtonClick = ^{
        NSLog(@"点击按钮,弹出菜单");
        CLComposeView *composeView = [[CLComposeView alloc] init];
        [composeView showWithController:self];
    };
    
    [self setValue:tabBar forKey:@"tabBar"];
    
    [self addChildViewController];
}

- (void)addChildViewController {
    [self addChildViewControllerWithClassName:@"CLHomeViewController" title:@"首页" imageName:@"tabbar_home"];
    [self addChildViewControllerWithClassName:@"CLMessageViewController" title:@"消息" imageName:@"tabbar_message_center"];
    [self addChildViewControllerWithClassName:@"CLMessageViewController" title:@"发现" imageName:@"tabbar_discover"];
    [self addChildViewControllerWithClassName:@"CLProfileViewController" title:@"我" imageName:@"tabbar_profile"];
}

- (void)addChildViewControllerWithClassName:(NSString *)className title:(NSString *)title imageName:(NSString *)imageName {
    Class Clz = NSClassFromString(className);
    UIViewController *vController = [[Clz alloc] init];
    vController.title = title;
    vController.tabBarItem.image = [UIImage imageNamed:imageName];
    vController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", imageName]];

    [vController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor orangeColor] } forState:UIControlStateNormal];

    CLNavigationViewController *navController = [[CLNavigationViewController alloc] initWithRootViewController:vController];

    [self addChildViewController:navController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
