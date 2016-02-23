//
//  ViewController.m
//  制表图
//
//  Created by Ray on 15/8/25.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"


@interface DPChartView : UIView

@end

@implementation DPChartView

#define ZeroPoint CGPointMake(30,460)

- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //画背景线条------------------
    
    
    CGContextSetLineWidth(context, 1.0);//主线宽度
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSaveGState(context) ;
    
    
    int x = 320 ;
    int y = 460 ;
    
    
    CGPoint bPoint = ZeroPoint;
    CGPoint ePoint = CGPointMake(x, y);
    
    
    
    CGContextMoveToPoint(context, bPoint.x, bPoint.y-15);
    CGContextAddLineToPoint(context, bPoint.x, 0);
    
    CGContextRestoreGState(context) ;
    
    
    
    CGContextSetLineWidth(context, 0.5f);//主线宽度
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGContextSaveGState(context) ;
    
    
    for (int i=0; i<vDesc.count; i++) {
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [view setCenter:CGPointMake(bPoint.x-10, bPoint.y-hInterval)];
        [view setBackgroundColor:[UIColor greenColor]];
        [self addSubview:view];
        
        CGContextMoveToPoint(context, bPoint.x, bPoint.y-hInterval);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y-hInterval);
        
        bPoint = CGPointMake(30, y-hInterval) ;
        ePoint = CGPointMake(x, y-hInterval) ;
        
        y -= hInterval;
        
    }
    
    for (int i=0; i<array.count-1; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((i+1)*vInterval+30-2.5, 442.5, 5, 5)];
        [view setBackgroundColor:[UIColor blueColor]];
        [self addSubview:view];
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context) ;
    
    
    
    //    //画点线条------------------
    CGFloat pointLineWidth = 1.5f;
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    
    
    
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSaveGState(context) ;
    
    
    
    //绘图
    CGPoint p1 = [[array objectAtIndex:0] CGPointValue];
    int i = 1;
    CGContextMoveToPoint(context, 30-2.5, 430-p1.y);
    for (; i<[array count]; i++)
    {
        p1 = [[array objectAtIndex:i] CGPointValue];
        CGPoint goPoint = CGPointMake(p1.x, 430-p1.y*vInterval/20);
        CGContextAddLineToPoint(context, goPoint.x, goPoint.y);;
        
        
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context) ;
    
    
}


@end



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    DPChartView *chartView = [[DPChartView alloc]initWithFrame:CGRectMake(30, 50, 100, 200)];
    chartView.backgroundColor = [UIColor greenColor] ;
    [self.view addSubview:chartView];
    
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
