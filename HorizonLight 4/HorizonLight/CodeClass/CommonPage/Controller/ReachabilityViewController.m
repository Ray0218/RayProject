//
//  ReachabilityViewController.m
//  HorizonLight
//
//  Created by lanou on 15/10/8.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "ReachabilityViewController.h"
#import "Reachability.h"
@interface ReachabilityViewController ()

@property (nonatomic, strong) Reachability *conn;
@end

@implementation ReachabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    [self checkNetworkState];
}
-(void)networkStateChange
{
    [self checkNetworkState];

}
-(void)dealloc
{
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}
-(void)checkNetworkState
{
    //检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //检测手机是否能上网(wifi\3G);
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    //判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"有wifi");
    }else if ([conn currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"使用手机自带网络进行上网");
    }else
    {
        NSLog(@"没有网络");
    }
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
