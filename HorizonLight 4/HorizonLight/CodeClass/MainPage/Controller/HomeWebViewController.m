//
//  HomeWebViewController.m
//  HorizonLight
//
//  Created by BaQi on 15/10/5.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "HomeWebViewController.h"

@interface HomeWebViewController ()<UIWebViewDelegate>

@end

@implementation HomeWebViewController
{
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置webView的大小
    webView = [[UIWebView alloc]initWithFrame:kBounds];
//    webView.backgroundColor = [UIColor whiteColor ];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    
    [LORequestManger GET:[NSString stringWithFormat: kHomepageUrl, self.ID] success:^(id response) {
        
        //获取屏幕宽度, 这个宽度用来约束图片的大小
        int width = [UIScreen mainScreen].bounds.size.width / 1.05;
        NSString *imageWidth = [NSString stringWithFormat:@"<img width=\"%d\"",width];
        NSString *lenghtH = [NSString stringWithFormat:@"width=\"%d\"",width];
        
        //数据解析
        NSDictionary *dic = (NSDictionary *)response;
        NSDictionary *DIC = [dic objectForKey:@"data"];
        NSDictionary *name = [DIC objectForKey:@"user"];
        NSString *user = [name objectForKey:@"name"];
        NSString *title = [DIC objectForKey:@"title"];
        NSString *str = [DIC objectForKey:@"body_html"];
        NSString *created = [DIC objectForKey:@"created_at"];
        NSString *strings = nil;
        
        for (int i = 0; i < created.length; i++)
        {
            //去掉" + "
            if ([[created substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"+"])
            {
                strings = [created substringToIndex:i];
                //去掉" T "
                for (int j = 0; j < strings.length; j++)
                {
                    if ([[strings substringWithRange:NSMakeRange(j, 1)] isEqualToString:@"T"])
                    {
                        NSString *a = [strings substringToIndex:j];
                        NSString *b = [strings substringFromIndex:j + 1];
                        strings = [NSString stringWithFormat:@"%@ %@", a, b ];
                    }
                }
            }
        }
        
        str = [str stringByReplacingOccurrencesOfString:@"height=\"498\"" withString:lenghtH];
        
        str = [str stringByReplacingOccurrencesOfString:@"<img " withString:imageWidth];
        
        //设置布局, 输入的内容前后对应 <H2>是指字体的大小
        str = [NSString stringWithFormat:@"<h3>%@发表于%@</h2>%@<h4 style=\"text- align:left;color:black\">%@</h3>", title, user, strings, str];
        
        [webView loadHTMLString:str baseURL:nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
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
