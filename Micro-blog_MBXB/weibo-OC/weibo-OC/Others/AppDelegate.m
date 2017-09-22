//
//  AppDelegate.m
//  weibo-OC
//
//  Created by Oboe_b on 16/8/29.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战
//简书地址:http://www.jianshu.com/u/a437e8f87a81

#import "AppDelegate.h"
#import "CLUserAccountViewModel.h"
#import "CLWelcomeViewController.h"
#import "CLTabBarViewController.h"
#import "CLStatusdDAL.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootVC:) name:CLChangeRootVCNotification object:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [CLUserAccountViewModel sharedManager].isUserLogin? [[CLWelcomeViewController alloc]init] : [[CLTabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)switchRootVC:(NSNotification *)sender {
//    self.window.rootViewController = sender.object ? [[CLWelcomeViewController alloc] init] : [[CLTabBarViewController alloc] init];
    if (sender.object != nil) {
        self.window.rootViewController = [[CLWelcomeViewController alloc] init];
    }else {
        self.window.rootViewController = [[CLTabBarViewController alloc] init];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [CLStatusdDAL clearCache];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
