//
//  DPAboutVC.m
//  DacaiProject
//
//  Created by jacknathan on 14-9-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPAboutVC.h"
#import <MDHTMLLabel.h>

@interface DPAboutVC ()

@end

@implementation DPAboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"关于大彩";
    }
    return self;
}
- (void)buildUI {
    UIView *contentView = self.view;
    contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#F4F4F4"];
    UIView *logoView = [[UIView alloc] init];
    logoView.backgroundColor = [UIColor clearColor];

    UIImageView *logo = [[UIImageView alloc] initWithImage:dp_AccountImage(@"aboutLogo.png")];
    logo.backgroundColor = [UIColor clearColor];

    UIView *backContent = [[UIView alloc] init];
    backContent.backgroundColor = [UIColor clearColor];

    UIImageView *backView = [[UIImageView alloc] initWithImage:dp_AccountImage(@"aboutBack.png")];

    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];

    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor dp_colorFromHexString:@"#D9D1D3"];
    ;

    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor dp_colorFromHexString:@"#D9D1D3"];
    ;
    NSString *appVersion = [NSString stringWithFormat:@"V%@     build %@", [DPSystemUtilities appVersion], [DPSystemUtilities devVersion]];
    NSArray *headStrings = @[ @"版  本  号 : ", @"网站网址 : ", @"客服热线 : ", @"客服邮箱 : ", @"版权所有 : " ];
    NSArray *detailStrings = @[ appVersion, @"www.dacai.com", @"400-826-5536", @"kefu@daicai.com", @"杭州大彩网络科技有限公司" ];
    UIView *upView = infoView;
    for (int i = 0; i < 5; i++) {

        UIView *cellView = [[UIView alloc] init];
        cellView.backgroundColor = [UIColor clearColor];
        
        UILabel* label =({
            UILabel * lab = [[UILabel alloc]init];
            lab.font= [UIFont dp_systemFontOfSize:13] ;
            lab.backgroundColor = [UIColor clearColor] ;
            lab ;
        });
        
        NSString *firstStr = headStrings[i] ;
        NSString* secondString = detailStrings[i] ;
        NSMutableAttributedString * baseStr = [[NSMutableAttributedString alloc]initWithString:firstStr];
        NSAttributedString* secondStr = [[NSAttributedString alloc]initWithString:secondString] ;
        [baseStr appendAttributedString:secondStr];
        
        [baseStr addAttribute:NSForegroundColorAttributeName  value:(id)UIColorFromRGB(0x87836a) range:NSMakeRange(0, firstStr.length)];
        [baseStr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0x333333) range:NSMakeRange(firstStr.length, secondString.length)] ;
        label.attributedText = baseStr ;
        
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor dp_colorFromHexString:@"#D9D1D3"];

        [infoView addSubview:cellView];
        [cellView addSubview:label];
        [cellView addSubview:bottomLine];

        [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (i == 0) {
                make.top.equalTo(upView);
            }else{
                make.top.equalTo(upView.mas_bottom);
            }
            make.left.equalTo(infoView);
            make.right.equalTo(infoView);
            make.height.equalTo(@37);
        }];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cellView).offset(20);
            make.centerY.equalTo(cellView);
        }];

        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label);
            make.right.equalTo(cellView).offset(- 20);
            make.bottom.equalTo(cellView);
            make.height.equalTo(@0.5);
        }];

        if (i == 4) {
            [bottomLine removeFromSuperview];
        }

        upView = cellView;
    }
    [logoView addSubview:logo];
    [backContent addSubview:backView];
    [infoView addSubview:topLine];
    [infoView addSubview:bottomLine];
    [contentView addSubview:logoView];
    [contentView addSubview:backContent];
    [contentView addSubview:infoView];

    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(logoView);
        make.centerY.equalTo(logoView);
    }];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backContent);
        make.top.equalTo(backContent);
    }];

    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView);
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];

    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoView);
        make.left.equalTo(infoView);
        make.right.equalTo(infoView);
        make.height.equalTo(@0.5);
    }];

    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@180);
    }];

    [backContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];

    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@185);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(navBackItemClick)];
    [self buildUI];
}

- (void)navBackItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
