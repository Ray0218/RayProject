//
//  DPLotteryInfoWebViewController.m
//  DacaiProject
//
//  Created by WUFAN on 14-10-22.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
#import "DPWF3DTicketTransferVC.h"
#import "DPDoubleHappyTransferVC.h"
#import "DPBigHappyTransferVC.h"
#import "DPSevenLuckTransferVC.h"
#import "DPRank3TransferVC.h"
#import "DPRank5TransferVC.h"
#import "DPSevenStartransferVC.h"
#import "DPElevnSelectFiveVC.h"
#import "DPElevnSelectFiveTransferVC.h"
#import "DPQuick3LotteryVC.h"
#import "DPQuick3transferVC.h"
#import "DPPksBuyViewController.h"
#import "DPPoker3transferVC.h"
#import "DPJczqBuyViewController.h"
#import "DPBdBuyViewController.h"
#import "DPJclqBuyViewController.h"
#import "DPSfcViewController.h"
#import "DPZcNineViewController.h"
#import "DPLotteryInfoWebViewController.h"
#import "DPShareView.h"
@interface DPLotteryInfoWebViewController () <UIWebViewDelegate, DPShareViewDelegate>
{
    UIView *_bottomView;
}
@end
@implementation DPLotteryInfoWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, - 44, 0));
//    }];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"share.png") target:self action:@selector(navRightItemClick)];
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor dp_colorFromHexString:@"#e9e7e1"];
    bottomView.hidden = YES;
    _bottomView = bottomView;
    
    UIButton *goTouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goTouBtn setTitle:@"去投注" forState:UIControlStateNormal];
    [goTouBtn setBackgroundColor:[UIColor dp_flatRedColor]];
    [goTouBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [goTouBtn addTarget:self action:@selector(touzhuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepLine = [[UIView alloc]init];
    sepLine.backgroundColor = [UIColor dp_colorFromHexString:@"#bcb682"];
    
    [self.view addSubview:bottomView];
    [bottomView addSubview:goTouBtn];
    [bottomView addSubview:sepLine];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
//        make.height.equalTo(@44);
        make.top.equalTo(self.webView.mas_bottom);
    }];
    
    [goTouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(10);
        make.right.equalTo(bottomView).offset(-10);
        make.centerY.equalTo(bottomView);
        make.height.equalTo(@35);
    }];

    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.top.equalTo(bottomView);
        make.height.equalTo(@0.5);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_thirdShareFinish:) name:dp_ThirdShareFinishKey object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)dp_thirdShareFinish:(NSNotification *)notificaiton
{
    BOOL result = [notificaiton.userInfo[dp_ThirdShareResultKey] boolValue];
//    int thirdType = [notificaiton.userInfo[dp_ThirdType] intValue];
    if (result) {
        for (UIView *view in [self.navigationController.view subviews]) {
            if ([view isKindOfClass:[DPShareView class]]) {
                [view removeFromSuperview];
            }
        }
        [[DPToast makeText:@"分享成功" color:[UIColor dp_colorFromHexString:@"#54b146"] style:DPToastStyleCorrect] show];
    }
}
- (void)navRightItemClick
{
    for (UIView *view in self.navigationController.view.subviews) {
        if ([view isKindOfClass:[DPShareView class]]) {
            return;
        }
    }
    DPShareView *shareView = [[DPShareView alloc]init];
    shareView.delegate = self;
    shareView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight + 20);
    [self.navigationController.view addSubview:shareView];
    
//    DPAppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
//    [appdelegate.rootController.view.window makeKeyAndVisible];
    
}
#pragma mark - share view delegate
- (void)shareViewCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ThirdShareFinishKey object:nil];
}
- (void)shareWithThirdType:(kThirdShareType)type
{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *content = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    if (content.length > 200){
        content = [content substringToIndex:200];
    }
    DPLog(@"title =%@, body =%@", title, content);
//    NSString *title = @"资讯标题";
//    NSString *content = @"资讯内容------测试";
    NSString *urlstr = self.requset.URL.absoluteString;
    DPLog(@"lotteryinfo ----------- url =%@", urlstr);
    if (urlstr.length == 0 || urlstr == nil) {
        urlstr = @"https://m.dacai.com/";
    }
    [[DPThirdCallCenter sharedInstance] dp_shareWithType:type title:title content:content image:nil urlString:urlstr];
}
- (void)touzhuBtnClick {
    switch (self.gameType) {
        case GameTypeSd: {
            [self.navigationController setViewControllers:@[ [[DPWF3DTicketTransferVC alloc] init] ] animated:YES];
        } break;
        case GameTypeSsq: {
            [self.navigationController setViewControllers:@[ [[DPDoubleHappyTransferVC alloc] init] ] animated:YES];

        } break;
        case GameTypeDlt: {
            [self.navigationController setViewControllers:@[ [[DPBigHappyTransferVC alloc] init] ] animated:YES];
        } break;
        case GameTypeQlc: {
            [self.navigationController setViewControllers:@[ [[DPSevenLuckTransferVC alloc] init] ] animated:YES];
        } break;
        case GameTypePs: {
            [self.navigationController setViewControllers:@[ [[DPRank3TransferVC alloc] init] ] animated:YES];
        } break;
        case GameTypePw: {
            [self.navigationController setViewControllers:@[ [[DPRank5TransferVC alloc] init] ] animated:YES];
        } break;
        case GameTypeQxc: {
            [self.navigationController setViewControllers:@[ [[DPSevenStartransferVC alloc] init] ] animated:YES];
        } break;
        case GameTypeJxsyxw: {
            DPElevnSelectFiveVC *vc = [[DPElevnSelectFiveVC alloc] init];
            DPElevnSelectFiveTransferVC *transVC = [[DPElevnSelectFiveTransferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeNmgks: {
            DPQuick3LotteryVC *vc = [[DPQuick3LotteryVC alloc] init];
            DPQuick3transferVC *transVC = [[DPQuick3transferVC alloc] init];
            NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
            [vcs addObject:transVC];
            [vcs addObject:vc];
            [self.navigationController setViewControllers:vcs animated:YES];
        } break;
        case GameTypeSdpks: {
            DPPksBuyViewController *vc = [[DPPksBuyViewController alloc] init];
            DPPoker3transferVC *transVC = [[DPPoker3transferVC alloc] init];
            NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
            [viewControllers addObject:transVC];
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        } break;
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcGJ:
        case GameTypeJcGYJ:
        case GameTypeJcHt:
        case GameTypeJcSpf:
        case GameTypeJcNone: {
            [self.navigationController setViewControllers:@[ [[DPJczqBuyViewController alloc] init] ] animated:YES];
        } break;
        case GameTypeBdRqspf:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
        case GameTypeBdNone: {
            [self.navigationController setViewControllers:@[ [[DPBdBuyViewController alloc] init] ] animated:YES];
        } break;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
        case GameTypeLcNone: {
            [self.navigationController setViewControllers:@[ [[DPJclqBuyViewController alloc] init] ] animated:YES];
        } break;
        case GameTypeZc14:
        case GameTypeZc9:
        case GameTypeZcNone: {
            [self.navigationController setViewControllers:@[ [[DPSfcViewController alloc] init] ] animated:YES];
        } break;
        default:
            break;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (DPWebViewLoadingTypeHUD == self.type) {
        [self dismissHUD];
    }
    
    if (self.shouldFitWidth) {
        [webView dp_fitWidth];
    }
    if (!self.canHighlight) {
        [webView dp_removeTapCSS];
    }
    
    switch (self.gameType) {
        case GameTypeSd:
        case GameTypeSsq:
        case GameTypeDlt:
        case GameTypeQlc:
        case GameTypePs:
        case GameTypePw:
        case GameTypeQxc:
        case GameTypeJxsyxw:
        case GameTypeNmgks:
        case GameTypeSdpks:
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcGJ:
        case GameTypeJcGYJ:
        case GameTypeJcHt:
        case GameTypeJcSpf:
        case GameTypeJcNone:
        case GameTypeBdRqspf:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
        case GameTypeBdNone:
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
        case GameTypeLcNone:
        case GameTypeZc14:
        case GameTypeZc9:
        case GameTypeZcNone:{
            _bottomView.hidden = NO;
            [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
            }];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
            break;
        default:
            _bottomView.hidden = YES;
            break;
    }


}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dp_ThirdShareFinishKey object:nil];

}
@end
