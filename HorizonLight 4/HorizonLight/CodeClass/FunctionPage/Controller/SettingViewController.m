//
//  SettingViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"
#define kMyCollect @"我的收藏"
#define kFunctionSwich @"功能开关"
#define kContribute @"我要投稿"
#define kFeedBack @"意见反馈"
#import "MyCollectTableViewController.h"
#import "MyCacheTableViewController.h"
#import "FunctionSwichViewController.h"
#import "ContributeViewController.h"
#import "FeedbackViewController.h" 

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置navigationBar为透明
    self.navigationController.navigationBar.translucent = YES;
    
    //创建左UIButton
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"linea_2b(0)_32"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    //隐藏下一界面的UITabBar
    [self.tabBarController.tabBar setHidden:YES];
    
    SettingView *settingView = [[SettingView alloc] initWithFrame:kBounds];
    [self.view addSubview:settingView];
    
    NSArray *array = @[kMyCollect, kFunctionSwich, kContribute, kFeedBack];
    for (int i = 0; i < [array count]; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000 + i];
        [button setTitle:array[i] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    settingView.version.text = [NSString stringWithFormat:@"Version %@", kVersions];
    settingView.maker.text = [NSString stringWithFormat:@"- %@出品 -", kMaker];
}
//点击方法
-(void)leftButtonClick
{
    [[TheDrawerSwitch shareSwitchDrawer] openOrCloseTheDrawer];
}
- (void)btnClick:(UIButton *)button
{
    switch (button.tag)
    {
            //我的收藏
        case 1000:
        {
            MyCollectTableViewController *myCollectTVC = [[MyCollectTableViewController alloc] init];
            [self.navigationController pushViewController:myCollectTVC animated:YES];
        }
            break;
            
            //功能开关
        case 1001:
        {
            FunctionSwichViewController *functionSwichVC = [[FunctionSwichViewController alloc] init];
            [self.navigationController pushViewController:functionSwichVC animated:YES];
        }
            break;
            
            //我要投稿
        case 1002:
        {
            ContributeViewController *contributeVC = [[ContributeViewController alloc] init];
            [self.navigationController pushViewController:contributeVC animated:YES];
        }
            break;
            
            //意见反馈
        case 1003:
        {
            FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        
        default:
            break;
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
