//
//  ViewController.m
//  ProtocolBuffer
//
//  Created by Ray on 15/6/30.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"
#import "Person.pbobjc.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PBUser *user = [PBUser message] ;
    NSLog(@"%@",user.description) ;
    user.userId = @"123456" ;
    user.avatar = @"23" ;
    user.nick = @"qwert" ; 
    NSLog(@"%@",user.description) ;
    NSLog(@"%@",user.data) ;
    
    NSData *data = [user data];
    
    NSError *error ;
    NSDictionary *dd = [NSJSONSerialization JSONObjectWithData:user.data options:NSJSONReadingMutableContainers error:&error] ;
    NSLog(@"dic === %@ ,, %@",dd,error) ;

    NSDictionary * dic = @{@"userId":@"345678",user.avatar:@"wertyui",user.nick:@"333"};
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] ;
    user = [PBUser parseFromData:data error:nil] ;
    NSLog(@"%@",user.description) ;
    
    
    
//    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13", nil] ;
//    for (NSString *ss  in arr) {
//        if ([ss isEqual:@"3"] || [ss isEqual:@"7"]) {
//            [arr removeObject:ss];
//        }
//    }
//    
//    NSLog(@"ss +%@",arr );
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
