//
//  DPHelpWebViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPHelpWebViewController.h"

@interface DPHelpWebViewController () <UIWebViewDelegate> {
@private
    UIWebView *_webView;
}

@property (nonatomic, strong, readonly) UIWebView *webView;

@end

@implementation DPHelpWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor dp_flatBackgroundColor]];
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)]];
    
    if (self.request == nil) {
        [self.navigationItem setTitle:@"帮助中心"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kHelpCenterURL]]];
    } else {
        [self.navigationItem setTitle:@"帮助详情"];
        [self.webView loadRequest:self.request];
    }
}

- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DPHelpWebViewController *viewController = [[DPHelpWebViewController alloc] init];
            viewController.request = request;
            [self.navigationController pushViewController:viewController animated:YES];
        });
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self dismissHUD];
    [webView dp_removeTapCSS];
}

@end
