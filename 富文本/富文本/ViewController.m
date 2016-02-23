//
//  ViewController.m
//  富文本
//
//  Created by Ray on 15/8/17.
//  Copyright (c) 2015年 Ray. All rights reserved.
//

#import "ViewController.h"
#import <MTStringAttributes/MTStringParser.h>

@interface ViewController (){

    UILabel *_label ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _label= ({
    
        UILabel *lab = [[UILabel alloc]init];
        lab.backgroundColor = [UIColor grayColor] ;
        lab.frame = CGRectMake(20, 100, 260, 40) ;
        
        lab ;
    
    });
    
    [self.view addSubview:_label];
    [self testExample];
    
    [self testExampleParser];
}

- (void)testExample
{
    MTStringAttributes *attributes = [[MTStringAttributes alloc] init];
    attributes.font = [UIFont systemFontOfSize:18];
    attributes.textColor = [UIColor redColor];
    attributes.backgroundColor = [UIColor blackColor];
    attributes.strikethrough = YES; //中间线（类似错误画线）
    attributes.underline = YES; //底部线
    
    attributes.ligatures = YES;
    attributes.kern = 1.0f; //文字间距

    
    NSAttributedString *str  = [[NSAttributedString alloc] initWithString:@"The attributed string!"
                                                                  attributes:[attributes dictionary]];
    
    _label.attributedText = str ;

}

-(void)testExampleParser {
    
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor grayColor] ;
    lab.frame = CGRectMake(20, 160, 260, 240) ;
    lab.numberOfLines = 0 ;
    [self.view addSubview:lab];
    
    MTStringAttributes *attributes  = [[MTStringAttributes alloc] init];
    attributes.font                 = [UIFont fontWithName:@"HelveticaNeue" size:14];
    attributes.textColor            = [UIColor greenColor];
    
    [[MTStringParser sharedParser] setDefaultAttributes:attributes];

    

    [[MTStringParser sharedParser] addStyleWithTagName:@"red"
                                                  font:[UIFont systemFontOfSize:12]
                                                 color:[UIColor redColor]];
    
    [[MTStringParser sharedParser] addStyleWithTagName:@"relative-time"
                                                  font:[UIFont fontWithName:@"HelveticaNeue" size:14]
                                                 color:[UIColor blueColor]];

    
    [[MTStringParser sharedParser] addStyleWithTagName:@"em"
                                                  font:[UIFont systemFontOfSize:14]
                                                 color:[UIColor whiteColor]
                                       backgroundColor:[UIColor blackColor]
                                         strikethrough:NO
                                             underline:YES];
    
    [[MTStringParser sharedParser] addStyleWithTagName:@"emNo"
                                                  font:[UIFont systemFontOfSize:14]
                                                 color:[UIColor whiteColor]
                                       backgroundColor:[UIColor blackColor]
                                         strikethrough:YES
                                             underline:YES];
    
    
    
    NSString *markup = [NSString stringWithFormat:@"You can have a <emNo>complex</emNo> string that  \
                        uses <em>tags</em> to define where you want <em>styles</em> to be defined. You needed       \
                        this <relative-time>timeAgo</relative-time>."];
    
    
    NSAttributedString *string = [[MTStringParser sharedParser]
                                  attributedStringFromMarkup:markup];
    
    lab.attributedText  = string ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
