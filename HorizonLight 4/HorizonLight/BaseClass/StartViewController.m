//
//  StartViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/22.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()
@property (nonatomic, strong) UIImageView *Logo;
@property (nonatomic, strong) UIImageView *secondView;
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.startView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.startView.image = [UIImage imageNamed:@"abc.png"];
    self.startView.alpha = 0.0;
    [self.view addSubview:self.startView];
    //绑定观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openHorizonLight) name:@"地平线之光" object:nil];
    
    
    self.Logo = [[UIImageView alloc] initWithFrame:CGRectMake(110, 200, 100, 100)];
    self.Logo.image = [UIImage imageNamed:@"Icon-60@3x.png"];
    self.Logo.alpha = 0.0;
    [self.view addSubview:self.Logo]; 
    
    self.secondView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.secondView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    self.secondView.alpha = 0.0;
    [self.view addSubview:self.secondView];
}
-(void)openHorizonLight
{
    [UIView animateWithDuration:3.0 animations:^{
        self.secondView.alpha = 1.0;
    }];
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(setUoImageView) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}
-(void)setUoImageView
{
    [UIView animateWithDuration:2.0 animations:^{
        self.Logo.alpha = 1.0;
    }];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(closeHorizonLight) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}
-(void)closeHorizonLight
{
    [UIView animateWithDuration:2.0 animations:^{
        self.startView.alpha = 0.0;
        self.secondView.alpha = 0.0;
        self.Logo.alpha = 0.0;
    }];
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(dismissMainPage) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}
-(void)dismissMainPage
{
    [self dismissViewControllerAnimated:YES completion:nil];

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
