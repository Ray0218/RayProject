//
//  MessageViewController.m
//  PresentationControlerDemo
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "MessageViewController.h"
#import "CustomPresentationController.h"
#import "CustomPresentationAnimationController.h"

@interface MessageViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation MessageViewController

-(void)commonInit{
    self.modalPresentationStyle = UIModalPresentationCustom ;
    self.transitioningDelegate = self ;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (IBAction)dismiss:(id)sender {
    NSLog(@"asdfsdfs");
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self commonInit];
    }
    
    return self ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor] ;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 120, 120, 30)];
    label.text = @"sdhrtyjk" ;
    [self.view addSubview:label];
    
  
}


#pragma mark- UIViewControllerTransitioningDelegate methods

-(UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{

    if (presented == self) {
        return [[CustomPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting] ;
    }
    
    return nil ;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{

    if (presented == self) {
        return  [[CustomPresentationAnimationController  alloc]initWithPrestiong:YES];
     }
    
    return nil ;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    if (dismissed) {
        return [[CustomPresentationAnimationController alloc]initWithPrestiong:NO] ;
    }

    return nil ;
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
