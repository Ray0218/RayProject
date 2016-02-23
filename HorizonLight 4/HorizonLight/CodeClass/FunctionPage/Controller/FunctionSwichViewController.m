//
//  FunctionSwichViewController.m
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "FunctionSwichViewController.h"
#import "FunctionSwichView.h"

@interface FunctionSwichViewController ()

@end

@implementation FunctionSwichViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FunctionSwichView *functionSwichV = [[FunctionSwichView alloc] initWithFrame:kBounds];
    [self.view addSubview:functionSwichV];
    
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
