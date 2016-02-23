//
//  ViewController.m
//  PresentationControlerDemo
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"
#import "MessageViewController.h"
#import "CustomPresentationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor =  [UIColor greenColor] ;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
    [btn addTarget:self action:@selector(pvt_dismiss) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 7 ;
    btn.clipsToBounds = YES ;
    btn.titleLabel.font = [UIFont systemFontOfSize:17] ;
    btn.frame = CGRectMake(20, 200, 200, 30) ;
    [self.view addSubview:btn];
    
    
    
    UITextField *textField= [[UITextField alloc]init];
    textField.placeholder = @"测试inputView" ;
    textField.frame = CGRectMake(20, 270, 200, 25) ;
    textField.backgroundColor = [UIColor grayColor] ;
    textField.inputAccessoryView = ({
        
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        btn.backgroundColor = [UIColor greenColor] ;
        btn.frame = CGRectMake(0, 0, 100, 30) ;
        [btn setTitle:@"Button" forState:UIControlStateNormal];
        btn ;
    });
    [self.view addSubview:textField];
}

- (IBAction)didddddd:(UIStoryboardSegue *)sender {
    NSLog(@"zzzzzzz");
}


-(void)pvt_dismiss{

    MessageViewController *vc =[[MessageViewController alloc]init];
    
    [self presentViewController:vc animated:YES completion:nil];
    
//    UIPresentationController *control = [[CustomPresentationController alloc]initWithPresentedViewController:[[MessageViewController alloc]init] presentingViewController:self];
    
    
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
