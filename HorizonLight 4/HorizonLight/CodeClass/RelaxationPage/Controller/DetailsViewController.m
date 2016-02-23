//
//  DetailsViewController.m
//  HorizonLight
//
//  Created by lanou on 15/10/5.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "DetailsViewController.h"
#import "LORefresh.h"
@interface DetailsViewController ()<UIWebViewDelegate>

@end

@implementation DetailsViewController
{
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    //创建一个UIWebView
    webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.delegate = self;
    //设置属性
    //自动对页面进行缩放以适应屏幕
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];

    //加载内容
    //加载
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [webView loadRequest:request];
    
}

#pragma mark----网页开始加载的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [view setTag:100];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    [view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];
    
}

#pragma mark----网页加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:100];
    [view removeFromSuperview];
}

#pragma mark----网页加载错误的时候调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:100];
    [view removeFromSuperview];
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
