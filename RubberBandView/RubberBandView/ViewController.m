//
//  ViewController.m
//  RubberBandView
//
//  Created by JianYe on 14-7-1.
//  Copyright (c) 2014年 XiaoZi. All rights reserved.
//

#import "ViewController.h"
#import "RubberBandView.h"
#import "UIColor+MLPFlatColors.h"
#import "RefreshView.h"

@interface ViewController ()
{
    CGPoint _beginPoint;
}
@property (nonatomic,strong)IBOutlet RubberBandView *rubberBandView;
@property (nonatomic,strong)IBOutlet UIButton *actionBtn;
@property (nonatomic, strong) RefreshView *upperRefreshView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    UIScrollView * scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, 320, CGRectGetHeight(self.view.bounds)-200)] ;
    scroView.contentSize = CGSizeMake(320, 800) ;
    scroView.backgroundColor = [UIColor yellowColor] ;
    [self.view addSubview:scroView];
    
    
    self.upperRefreshView = [[RefreshView alloc]initWithFrame:CGRectMake(0, 100, 320,100) inScrollView:scroView withDirection:0];
    self.upperRefreshView.backgroundColor = [UIColor blueColor] ;
    [self.view addSubview:self.upperRefreshView];

    
    _rubberBandView.property = MakeRBProperty(0, 0, 40, 4, 40);
    _rubberBandView.fillColor = [UIColor flatRedColor];
    _rubberBandView.duration = 0.5;
    
    _rubberBandView.startAction = ^(){
    
        NSLog(@"====startAction==== ") ;
    } ;
    
}

- (IBAction)beginAnimation:(UIButton *)sender {

}

- (IBAction)resetState:(id)sender {
    [_rubberBandView resetDefault];
}


- (IBAction)panAction:(UIPanGestureRecognizer *)recoginzer {
    CGPoint touchPoint = [recoginzer locationInView:self.view];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _beginPoint = touchPoint;
    }else if (recoginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offSet = touchPoint.x - _beginPoint.x;
        
        
//        self.upperRefreshView.offsetY = touchPoint.y - _beginPoint.y; ;
//        [self.upperRefreshView setNeedsDisplay];
        
        
        [_rubberBandView pullWithOffSet:offSet*0.5];
    }else {
        [_rubberBandView recoverStateAnimation];
        
        

    }
}

@end
