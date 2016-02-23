//
//  ViewController.m
//  TestAnimation
//
//  Created by Liuyu on 14-6-19.
//  Copyright (c) 2014年 Liuyu. All rights reserved.
//

#import "ViewController.h"
#import "LYBgImageView.h"
#import "LYMovePathView.h"
#import "LYFireworksView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1] ;
	// Do any additional setup after loading the view, typically from a nib.
    
    // 背景梦幻星空
    do {
        LYBgImageView *animationView = [[LYBgImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        
        [self.view addSubview:animationView];
    } while (0);
    
    // 第一条移动星星闪烁动画
    do {
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddCurveToPoint(path, NULL, 50.0, 100.0, 50.0, 120.0, 50.0, 275.0);
        CGPathAddCurveToPoint(path, NULL, 50.0, 275.0, 150.0, 275.0, 160.0, 160.0);
        
        LYMovePathView *animationView = [[LYMovePathView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) movePath:path];
        [self.view addSubview:animationView];
    } while (0);

    // 第二条移动星星闪烁动画
    do {
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 320 - 0, 320 - 0);
        CGPathAddCurveToPoint(path, NULL, 320 - 50.0, 320 - 100.0, 320 - 50.0, 320 - 120.0, 320 - 50.0, 320 - 275.0);
        CGPathAddCurveToPoint(path, NULL, 320 - 50.0, 320 - 275.0, 320 - 150.0, 320 - 275.0, 160.0, 160.0);
    
        
        LYMovePathView *animationView = [[LYMovePathView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) movePath:path];
        [self.view addSubview:animationView];
    } while (0);

//     祝贺花筒，彩色炮竹
    do {
        LYFireworksView *animationView = [[LYFireworksView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self.view addSubview:animationView];
    } while (0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
