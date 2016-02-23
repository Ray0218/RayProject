//
//  DPDrawingSuccessVC.m
//  DacaiProject
//
//  Created by feifei on 14-9-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDrawingSuccessVC.h"
#import "DPFundFlowViewController.h"
#import "DPAppParser.h"


@interface DPDrawingSuccessVC ()

@end

@implementation DPDrawingSuccessVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"提款成功";

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_goBack)];
}
- (void)bulidLayout:(NSString*)drawingMoney shouxuMoney:(NSString*)shouxuMoney yueMoney:(NSString *)yueMoney arriveTime:(NSString *)arriveTime{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];   // 类型
    [formatter setMaximumFractionDigits:2];                     // 保留2位小数
    [formatter setMinimumFractionDigits:2];                     // 保留2位小数
    [formatter setRoundingMode:NSNumberFormatterRoundFloor];
    NSDecimalNumber *drawAmt=[NSDecimalNumber decimalNumberWithString:drawingMoney];
    NSDecimalNumber *shouxuAmt=[NSDecimalNumber decimalNumberWithString:shouxuMoney];
    NSDecimalNumber *daoplusAmt = [drawAmt decimalNumberBySubtracting:shouxuAmt];
    
    UIView *topView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    topView.layer.borderColor = UIColorFromRGB(0xdcd8c8).CGColor;
    topView.layer.borderWidth = 1;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(@230);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = dp_AccountImage(@"account_success.png");
    [topView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.height.equalTo(@46.5);
        make.top.equalTo(topView).offset(35);
        make.height.equalTo(@46.5);
    }];

    UILabel *label1 = [self createlabel:@"提款成功" titleColor:UIColorFromRGB(0x1d911a) titleFont:[UIFont dp_systemFontOfSize:16.0] alignment:NSTextAlignmentCenter];
    [topView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.left.equalTo(topView);
        make.top.equalTo(imageView.mas_bottom);
        make.height.equalTo(@25);
    }];

    UIView *liebiaoView = [UIView dp_viewWithColor:[UIColor clearColor]];
    [topView addSubview:liebiaoView];
    [liebiaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.width.equalTo(@240);
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.height.equalTo(@72);
    }];
    UILabel *label2 = [self createlabel:@"提款金额" titleColor:UIColorFromRGB(0x666666) titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentCenter];
    [liebiaoView addSubview:label2];
    UILabel *label3 = [self createlabel:@"手续费" titleColor:UIColorFromRGB(0x666666) titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentCenter];
    [liebiaoView addSubview:label3];
    UILabel *label4 = [self createlabel:@"账户余额" titleColor:UIColorFromRGB(0x666666) titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentCenter];
    [liebiaoView addSubview:label4];
    UILabel *label5 = [self createlabel:[NSString stringWithFormat:@"%@元", drawingMoney] titleColor:UIColorFromRGB(0x666666) titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentLeft];
    [liebiaoView addSubview:label5];
    UILabel *label6 = [self createlabel:[NSString stringWithFormat:@"%@元（到账%@元）", shouxuMoney, [formatter stringFromNumber:daoplusAmt]] titleColor:[UIColor dp_flatRedColor] titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentLeft];
    [liebiaoView addSubview:label6];
    UILabel *label7 = [self createlabel:[NSString stringWithFormat:@"%@元", yueMoney] titleColor:[UIColor dp_flatRedColor] titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentLeft];
    [liebiaoView addSubview:label7];

    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liebiaoView);
        make.width.equalTo(@60);
        make.top.equalTo(liebiaoView);
        make.height.equalTo(@24);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2);
        make.right.equalTo(label2);
        make.top.equalTo(label2.mas_bottom);
        make.height.equalTo(@24);
    }];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3);
        make.right.equalTo(label3);
        make.top.equalTo(label3.mas_bottom);
        make.height.equalTo(@24);
    }];

    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(10);
        make.right.equalTo(liebiaoView);
        make.top.equalTo(label2);
        make.bottom.equalTo(label2);
    }];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right).offset(10);
        make.right.equalTo(liebiaoView);
        make.top.equalTo(label3);
        make.bottom.equalTo(label3);
    }];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label4.mas_right).offset(10);
        make.right.equalTo(liebiaoView);
        make.top.equalTo(label4);
        make.bottom.equalTo(label4);
    }];

    UIView *hLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcd8c8)];
    UIView *hLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcd8c8)];
    UIView *hLine3 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcd8c8)];
    UIView *hLine4 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcd8c8)];
    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcd8c8)];
    UIView *vLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcd8c8)];
    UIView *vLine3 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcd8c8)];
    [liebiaoView addSubview:hLine1];
    [liebiaoView addSubview:hLine2];
    [liebiaoView addSubview:hLine3];
    [liebiaoView addSubview:hLine4];
    [liebiaoView addSubview:vLine1];
    [liebiaoView addSubview:vLine2];
    [liebiaoView addSubview:vLine3];
    [hLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liebiaoView);
        make.right.equalTo(liebiaoView);
        make.top.equalTo(liebiaoView);
        make.height.equalTo(@0.5);
    }];
    [hLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liebiaoView);
        make.right.equalTo(liebiaoView);
        make.top.equalTo(label3);
        make.height.equalTo(@0.5);
    }];
    [hLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liebiaoView);
        make.right.equalTo(liebiaoView);
        make.top.equalTo(label4);
        make.height.equalTo(@0.5);
    }];
    [hLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liebiaoView);
        make.right.equalTo(liebiaoView);
        make.bottom.equalTo(liebiaoView);
        make.height.equalTo(@0.5);
    }];

    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(liebiaoView);
        make.width.equalTo(@0.5);
        make.top.equalTo(liebiaoView);
        make.bottom.equalTo(liebiaoView);
    }];
    [vLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right);
        make.width.equalTo(@0.5);
        make.top.equalTo(liebiaoView);
        make.bottom.equalTo(liebiaoView);
    }];
    [vLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(liebiaoView);
        make.width.equalTo(@0.5);
        make.top.equalTo(liebiaoView);
        make.bottom.equalTo(liebiaoView);
    }];

    UILabel *label8 = [self createlabel:[NSString stringWithFormat:@"预计到账时间：%@",[arriveTime stringByReplacingOccurrencesOfString:@"|" withString:@"\n"]] titleColor:UIColorFromRGB(0x333333) titleFont:[UIFont dp_systemFontOfSize:12.0] alignment:NSTextAlignmentCenter];
    label8.numberOfLines=2;
    label8.textAlignment=NSTextAlignmentRight;
    [topView addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView);
        make.right.equalTo(topView).offset(-50);
        make.top.equalTo(liebiaoView.mas_bottom).offset(5);
        make.height.equalTo(@30);
    }];

    UIButton *myAccountButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor redColor]];
        button.layer.cornerRadius=5;
        [button addTarget:self action:@selector(pvt_myAccount) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"我的账户" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:15.0]];
        button;
    });
    [self.view addSubview:myAccountButton];
    [myAccountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_centerX).offset(-5);
        make.height.equalTo(@40);
    }];

    UIButton *myBuyButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor redColor]];
        button.layer.cornerRadius=5;
        [button addTarget:self action:@selector(pvt_goBuy) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"继续购彩" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:15.0]];
        button;
    });
    [self.view addSubview:myBuyButton];
    [myBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view.mas_centerX).offset(5);
        make.height.equalTo(@40);
    }];
}
- (void)pvt_myAccount {
       [DPAppParser backToLeftRootViewController:YES] ;
//    for (UIViewController* vc in self.navigationController.viewControllers) {
//        if ([NSStringFromClass([vc class]) isEqualToString:@"DPFundFlowViewController"]) {
//            DPFundFlowViewController * viewCon = (DPFundFlowViewController*)vc ;
//            [self.navigationController popToViewController:viewCon animated:YES];
//            return ;
//        }
//    }
//    [self.navigationController pushViewController:[[DPFundFlowViewController alloc]init] animated:YES] ;

    
}
- (void)pvt_goBuy {

    [DPAppParser backToCenterRootViewController:YES] ;
    
}
- (void)pvt_goBack
{
     [DPAppParser backToLeftRootViewController:YES] ;
}
- (UILabel *)createlabel:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.font = titleFont;
    label.text = title;
    label.textAlignment = alignment;
    return label;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
