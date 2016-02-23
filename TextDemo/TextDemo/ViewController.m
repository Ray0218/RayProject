//
//  ViewController.m
//  TextDemo
//
//  Created by Ray on 15/4/2.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{

    CATextLayer *_textLayer ;
    CADisplayLink *_link;
    CAKeyframeAnimation *keyAnimation ;
    int count ;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 280, 100)];
    view.backgroundColor = [UIColor greenColor] ;
//    view.layer.masksToBounds = YES ;
    [self.view addSubview:view];
    
    count = 0 ;
    _textLayer = [self createTextsWitView:view] ;
    
     keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"] ;
    keyAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:130.0],[NSNumber numberWithFloat:40.0],[NSNumber numberWithFloat:40.0], [NSNumber numberWithFloat:-30],nil] ;
    keyAnimation.keyTimes = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:0.3],

                             [NSNumber numberWithFloat:0.6],
                             [NSNumber numberWithFloat:1.0], nil];
    keyAnimation.duration = 4;
//    keyAnimation.repeatCount = 50 ;
    keyAnimation.delegate = self ;
    
    
    [_textLayer addAnimation:keyAnimation forKey:@"keysss"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd] ;
    btn.frame = CGRectMake(30, 300, 40, 10);
    [btn addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

-(void)pressBtn{

    [_textLayer removeAnimationForKey:@"keysss"];
    

}



-(CATextLayer*)createTextsWitView:(UIView *)containerView{
    
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor redColor].CGColor ;
    
    textLayer.frame = CGRectMake(5, 70, 100, 30);
    [containerView.layer addSublayer:textLayer];
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
   
    
    NSString *text = @"第一条";
    textLayer.string = text;
    
    textLayer.contentsScale =  [UIScreen mainScreen].scale;
    
    return textLayer ;
    
}

-(void)animationDidStart:(CAAnimation *)anim{

    NSLog(@"start") ;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    NSLog(@"stop") ;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _textLayer.position = CGPointMake(60, 120) ;
    
    [CATransaction commit];
    if (flag) {
        
        [keyAnimation runActionForKey:@"position.y" object:_textLayer arguments:nil];
        _textLayer.string = [NSString stringWithFormat:@"第%d条",count++] ;

    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
