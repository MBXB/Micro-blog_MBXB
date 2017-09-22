//
//  CLOAuthViewController.m
//  weibo-OC
//
//  Created by Oboe_b on 16/9/1.
//  Copyright © 2016年 Oboe_b. All rights reserved.
//

#import "CLOAuthViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "SVProgressHUD.h"
#import "CLUserAccountViewModel.h"

@interface CLOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

@end

@implementation CLOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // OAuth的授权地址
    NSURL *oauthURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",WB_APPKEY, WB_REDIRECTURI]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL: oauthURL];
    [webView loadRequest:request];
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    
    self.title = @"新浪微博";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" imageName:nil target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自动填充" imageName:nil target:self action:@selector(autoFill)];

}

- (void)close {
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)autoFill {
    NSString *jsString = @"document.getElementById('userId').value='Oboe_bluo0114@sina.com';document.getElementById('passwd').value='xx'";
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![request.URL.absoluteString hasPrefix:WB_REDIRECTURI]) {
        return true;
    }
    
    NSString *code = [request.URL.query substringFromIndex:[@"code=" length]];
    NSLog(@"%@",code);
    [[CLUserAccountViewModel sharedManager] loadAccessTokenWithCode:code completion:^(BOOL isSuccess) {
        if(isSuccess){
        // 如果成功，跳转导欢迎界面
            NSLog(@"如果成功，跳转导欢迎界面");
            [self dismissViewControllerAnimated:false completion:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:CLChangeRootVCNotification object:self];
            }];
        } else {
            NSLog(@"登录失败");
        }
    }];
    // 根据授获取accessToken
    return false;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
