//
//  DPRechargeSuccessVC.m
//  DacaiProject
//
//  Created by sxf on 14-9-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPRechargeSuccessVC.h"
#import "DPAppParser.h"
#import "DPFundFlowViewController.h"
@interface DPRechargeSuccessVC ()

@end

@implementation DPRechargeSuccessVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    self.title = @"充值成功";
    self.view.backgroundColor = UIColorFromRGB(0xe9e7e1);
    [self buildLayout];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(pvt_onBack)];
    // Do any additional setup after loading the view.
}
- (void)buildLayout {
    UIView *topView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    topView.layer.cornerRadius = 3;
    topView.layer.borderColor = UIColorFromRGB(0xe7e6e0).CGColor;
    topView.layer.borderWidth = 0.5;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(@130);
    }];

    UIImageView *successView = [[UIImageView alloc] init];
    successView.image = dp_AccountImage(@"account_success.png");
    [topView addSubview:successView];
    [successView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.width.equalTo(@46.5);
        make.top.equalTo(topView).offset(25);
        make.height.equalTo(@46.5);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"恭喜您已充值成功！";
    label.textColor = UIColorFromRGB(0x1d911a);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dp_systemFontOfSize:18.0];
    [topView addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.width.equalTo(@240);
        make.top.equalTo(successView.mas_bottom).offset(5);
        make.height.equalTo(@25);
    }];

    UIButton *gotoButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor redColor]];
        [button addTarget:self action:@selector(pvt_goBuy) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"继续购彩" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button;
    });
    [self.view addSubview:gotoButton];
    [gotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@35);
    }];

    UIButton *lookRechargeBtn = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor dp_flatWhiteColor];
        [button addTarget:self action:@selector(pvt_lookRC) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"查看资金明细" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button.layer.borderColor=[UIColor colorWithRed:0.88 green:0.85 blue:0.79 alpha:1.0].CGColor;
        button.layer.borderWidth=1;
        button;
    });
    [self.view addSubview:lookRechargeBtn];
    [lookRechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gotoButton.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@35);
    }];
}
- (void)pvt_goBuy {
    [DPAppParser backToCenterRootViewController:YES];
}
- (void)pvt_lookRC {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@" DPFundFlowViewController"]) {
            DPFundFlowViewController *viewControler = (DPFundFlowViewController *)vc;
            [self.navigationController popToViewController:viewControler animated:YES];
              return;
        }
      
    }
    DPFundFlowViewController *vc = [[DPFundFlowViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pvt_onBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
