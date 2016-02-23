//
//  ViewController.m
//  ProtoBuffer 使用
//
//  Created by Ray on 15/6/30.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"
#import "Person.pb.h"

@interface ViewController (){

    PBUserBuilder *_builder ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    _builder = [[PBUser defaultInstance]builder] ;
    NSLog(@"debugDescription == %@",[PBUser defaultInstance].debugDescription) ;
    
    
    [_builder setNick:@"dfgh"];
    [_builder setUserId:@"1234"];
    [_builder setAvatar:@"5"];
    PBUser *user = [_builder build];
    NSLog(@"debugDescription == %@",user.debugDescription) ;
    NSLog(@"debugDescription == %@",[_builder buildPartial].description) ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
