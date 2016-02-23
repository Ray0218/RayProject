//
//  DPWebViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import "DPWebViewController.h"
#import "FrameWork.h"

@interface DPWebViewController () <UIWebViewDelegate, NJKWebViewProgressDelegate> {
@private
    UIWebView *_webView;
    UIToolbar *_toolBar;
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_forwardItem;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (nonatomic, strong, readonly) UIToolbar *toolBar;
@property (nonatomic, strong, readonly) UIBarButtonItem *backItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardItem;

@property (nonatomic, strong, readonly) NJKWebViewProgressView *progressView;
@property (nonatomic, strong, readonly) NJKWebViewProgress *progressProxy;

@end

@implementation DPWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.canHighlight = YES;
        self.shouldFitWidth = NO;
        self.bounces = NO;
        self.customTitle = YES;
        self.type = DPWebViewLoadingTypeHUD;
    }
    return self;
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onClose)]];
    [self.view addSubview:self.webView];
    
    if (self.type == DPWebViewLoadingTypeProgress) {
        self.webView.delegate = self.progressProxy;
    }
    
    if (self.showToolBar) {
        [self.view addSubview:self.toolBar];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 40, 0));
        }];
        [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@40);
        }];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *fixedItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem1.width = 5;
        UIBarButtonItem *fixedItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem2.width = 20;
        UIBarButtonItem *fixedItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem3.width = 5;
        UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithImage:dp_CommonImage(@"reload.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onReload)];
        [self.toolBar setItems:@[fixedItem1, self.backItem, fixedItem2, self.forwardItem, flexibleItem, reloadItem, fixedItem3]];
    } else {
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.webView loadRequest:self.requset];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.type == DPWebViewLoadingTypeProgress) {
        [self.navigationController.navigationBar addSubview:self.progressView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_progressView.superview) {
        [_progressView removeFromSuperview];
    }
}

- (void)dealloc {
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
}

#pragma mark - setter
- (void)setRequset:(NSURLRequest *)requset {
    int channelId; string deviceToken, userToken, appVersion, activeGUID;
    CFrameWork::GetInstance()->GetHTTPField(channelId, deviceToken, userToken, appVersion, activeGUID);
    
    NSMutableURLRequest *mutableRequset = requset.mutableCopy;
    [mutableRequset setValue:[NSString stringWithFormat:@"%d", channelId] forHTTPHeaderField:@"COperateChanel"];
    [mutableRequset setValue:[NSString stringWithUTF8String:appVersion.c_str()] forHTTPHeaderField:@"CAppVersion"];
    [mutableRequset setValue:[NSString stringWithUTF8String:deviceToken.c_str()] forHTTPHeaderField:@"CDeviceToken"];
    [mutableRequset setValue:[NSString stringWithUTF8String:activeGUID.c_str()] forHTTPHeaderField:@"CActiveGUID"];
    if (userToken.length()) {
        [mutableRequset setValue:[NSString stringWithUTF8String:userToken.c_str()] forHTTPHeaderField:@"CUserToken"];
    }
//    [mutableRequset setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    _requset = mutableRequset;
}

-(void)setPostRequest:(NSURLRequest *)requset postData:(NSData *)postData {
    int channelId; string deviceToken, userToken, appVersion, activeGUID;
    CFrameWork::GetInstance()->GetHTTPField(channelId, deviceToken, userToken, appVersion, activeGUID);
    
    NSMutableURLRequest *mutableRequset = requset.mutableCopy;
    [mutableRequset setValue:[NSString stringWithFormat:@"%d", channelId] forHTTPHeaderField:@"COperateChanel"];
    [mutableRequset setValue:[NSString stringWithUTF8String:appVersion.c_str()] forHTTPHeaderField:@"CAppVersion"];
    [mutableRequset setValue:[NSString stringWithUTF8String:deviceToken.c_str()] forHTTPHeaderField:@"CDeviceToken"];
    [mutableRequset setValue:[NSString stringWithUTF8String:activeGUID.c_str()] forHTTPHeaderField:@"CActiveGUID"];
    if (userToken.length()) {
        [mutableRequset setValue:[NSString stringWithUTF8String:userToken.c_str()] forHTTPHeaderField:@"CUserToken"];
    }
//    [mutableRequset setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    [mutableRequset setHTTPMethod:@"POST"];     // 设置请求方式
    [mutableRequset setHTTPBody:postData];      // 设置请求数据
    
    _requset = mutableRequset;
}

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    self.webView.scrollView.bounces = self.bounces;
}

#pragma mark - getter
- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor dp_flatBackgroundColor];
        _webView.opaque = NO;
    }
    return _webView;
}

- (UIToolbar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.translucent = YES;
        _toolBar.opaque = NO;
    }
    return _toolBar;
}

- (UIBarButtonItem *)backItem {
    if (_backItem == nil) {
        _backItem = [[UIBarButtonItem alloc] initWithImage:dp_CommonImage(@"back.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onBack)];
        _backItem.enabled = NO;
    }
    return _backItem;
}

- (UIBarButtonItem *)forwardItem {
    if (_forwardItem == nil) {
        _forwardItem = [[UIBarButtonItem alloc] initWithImage:dp_CommonImage(@"forward.png") style:UIBarButtonItemStylePlain target:self action:@selector(pvt_onForward)];
        _forwardItem.enabled = NO;
    }
    return _forwardItem;
}

- (NJKWebViewProgress *)progressProxy {
    if (_progressProxy == nil) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}

- (NJKWebViewProgressView *)progressView {
    if (_progressView == nil) {
        CGFloat progressBarHeight = 2.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _progressView.progressBarView.backgroundColor = UIColorFromRGB(0xf6de2b);//[UIColor dp_oppositeColorOf:[UIColor dp_flatDarkRedColor]];
    }
    return _progressView;
}

#pragma mark - event
- (void)pvt_onClose {
    if (self.navigationController.viewControllers.firstObject != self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)pvt_onBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.backItem setEnabled:NO];
    }
}

- (void)pvt_onForward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    } else {
        [self.forwardItem setEnabled:NO];
    }
}

- (void)pvt_onReload {
    [self.webView reload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL.scheme lowercaseString] isEqualToString:dp_URLScheme]) {
        NSString *resourceSpecifier = [request.URL resourceSpecifier];
        if (resourceSpecifier.length > 9 && [[[resourceSpecifier substringToIndex:9] lowercaseString] hasPrefix:@"//mutual?"]) {
            resourceSpecifier = [resourceSpecifier substringFromIndex:9];
            if (resourceSpecifier.length) {
                CFrameWork::GetInstance()->SetSessionContent(resourceSpecifier.UTF8String);
            }
            return NO;
        }
    }
    return YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (DPWebViewLoadingTypeHUD == self.type) {
        [self showHUD];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (DPWebViewLoadingTypeHUD == self.type) {
        [self dismissHUD];
    }
    if (self.shouldFitWidth) {
        [self.webView dp_fitWidth];
    }
    if (!self.canHighlight) {
        [self.webView dp_removeTapCSS];
    }
    if (!self.customTitle) {
        NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (title.length) {
            self.title = title;
        }
    }
    
    [self reloadToolBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (DPWebViewLoadingTypeHUD == self.type) {
        [self dismissHUD];
    }
    
    [self reloadToolBar];
}

- (void)reloadToolBar {
    if (self.showToolBar) {
        self.backItem.enabled = [self.webView canGoBack];
        self.forwardItem.enabled = [self.webView canGoForward];
    }
}

@end

@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame;

@end

@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame {
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    
    [customAlert show];
}

@end
