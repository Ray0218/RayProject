//
//  BaseTBViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/18.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "BaseTBViewController.h"
#import "MainTableViewController.h"
#import "ClassificationViewController.h"

@interface BaseTBViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BaseTBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MainTableViewController *mainTVC = [[MainTableViewController alloc] init];
    ClassificationViewController *classificationVC = [[ClassificationViewController alloc] init];
    
    [self addChildVC:mainTVC title:@"今日精选" imageName:@"" selectedImage:@""];
    [self addChildVC:classificationVC title:@"往期分类" imageName:@"" selectedImage:@""];
    self.tabBar.tintColor = [UIColor cyanColor];
    self.tabBar.barTintColor = [UIColor blackColor];
    
}

- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage
{
    //设置默认图标
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置选中图标
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    //设置导航控制器
    UINavigationController *childNVC = [[UINavigationController alloc]initWithRootViewController:childVC];
//    childVC.navigationItem.title = title;
    childNVC.tabBarItem.title = title;
    //将我们设置好的视图控制器添加至TabbarController
    [self addChildViewController:childNVC];
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
