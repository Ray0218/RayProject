//
//  SkipViewController.m
//  HorizonLight
//
//  Created by lanou on 15/10/6.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "SkipViewController.h"

@interface SkipViewController ()

@end

@implementation SkipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建模糊视图
    BlurImageView *blurImageView = [[BlurImageView alloc] initWithFrame:kBounds imageURL:@"001.jpg"];
    [self.view addSubview:blurImageView];
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
