//
//  ViewController.m
//  littleMapView
//
//  Created by fuqiang on 13-7-2.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "ViewController.h"
#import "SmallMapView.h"

@interface ViewController ()

@property (nonatomic,retain)UIScrollView *myScrollView;
@property (nonatomic,retain)UIView *contentView;
@property (nonatomic,retain,readonly)SmallMapView *smallMapView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mn.jpg"]] autorelease];
    _contentView = [[UIView alloc] initWithFrame:imageView.frame];
    [_contentView addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
    button.frame = CGRectMake(0,0,200,100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:button];

    
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, 320, 320)];
    [_myScrollView  setBackgroundColor:[UIColor grayColor]];
    _myScrollView.contentSize=CGSizeMake(_contentView.frame.size.width, _contentView.frame.size.height);
    _myScrollView.minimumZoomScale=0.1;
    _myScrollView.maximumZoomScale=2.0;
    _myScrollView.showsHorizontalScrollIndicator=YES;
    _myScrollView.showsVerticalScrollIndicator=YES;
    _myScrollView.bounces=NO; //反弹效果
    _myScrollView.alwaysBounceVertical=YES;
    _myScrollView.alwaysBounceHorizontal=YES;
    _myScrollView.delegate=self;
    [_myScrollView addSubview:_contentView];
    [self.view addSubview:_myScrollView];

    //
//    _smallMapView = [[SmallMapView alloc] initWithUIScrollView:_myScrollView frame:CGRectMake(0, 0, 150, 150 * _myScrollView.contentSize.height / _myScrollView.contentSize.width)];
//    _smallMapView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_smallMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_myScrollView release];
    [_contentView release];
    [_smallMapView release];
    [super dealloc];
}

// 滚动时触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_smallMapView scrollViewDidScroll:scrollView];
}


//需要进行放缩的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
      return _contentView;
}

-(void)buttonClick:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if (button.backgroundColor == [UIColor redColor])
    {
        button.backgroundColor = [UIColor blueColor];
    }
    else
    {
        button.backgroundColor = [UIColor redColor];
    }
    [self performSelector:@selector(reloadSmallMapView:) withObject:nil afterDelay:0.2];
}

-(void)reloadSmallMapView:(id)sender
{
    [_smallMapView reloadSmallMapView];
}
@end
