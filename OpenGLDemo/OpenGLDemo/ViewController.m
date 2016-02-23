//
//  ViewController.m
//  OpenGLDemo
//
//  Created by Ray on 15/4/1.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    EAGLContext *_context ;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)createOPen{

    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];
    _context = context ;
    
    [EAGLContext setCurrentContext:context];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
