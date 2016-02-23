//
//  DPSecurityCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSecurityCell.h"
#define buttonTag 1400
@interface DPSecurityCell ()
@property (nonatomic, strong, readonly) NSLayoutConstraint *moneyOldFieldW;
@end
@implementation DPSecurityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)createView:(BOOL)renzheng indexPath:(NSIndexPath *)path {
    int index = path.row;
    switch (index) {
        case 0: //实名未认证
            if (renzheng) {
                [self createNamedView];
            } else {
                [self createNoNameView];
            }

            break;
        case 1: //手机认证
            if (renzheng) {
                [self createPhonedView];
            } else {

                [self createNoPhoneView];
            }

            break;
        case 2: //修改密码
            [self createPassWordView];
            break;
        default:
            break;
    }
}

- (void)createNoNameView {
    UIView *contetView = self.contentView;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"实名认证";
    label.font = [UIFont systemFontOfSize:11.0];
    label.textColor = UIColorFromRGB(0x9a875f);
    [contetView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contetView);
                make.right.equalTo(contetView);
                make.top.equalTo(contetView).offset(5);
                make.height.equalTo(@20);
    }];

    UIView *fieldView = ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
                view.layer.cornerRadius = 5;
                view.layer.borderWidth = 0.5;
                view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
                view;
    });
    [contetView addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contetView);
                make.right.equalTo(contetView);
                make.top.equalTo(label.mas_bottom);
                make.height.equalTo(@70);
    }];

    UILabel *infolabel = [[UILabel alloc] init];
    infolabel.backgroundColor = [UIColor clearColor];
    infolabel.text = @"实名认证是兑奖和提款的唯一凭证，认证后不可修改";
    infolabel.textColor = UIColorFromRGB(0x666666);
    infolabel.font = [UIFont systemFontOfSize:10.0];
    infolabel.textColor = [UIColor blackColor];
    [contetView addSubview:infolabel];
    [infolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(5);
        make.right.equalTo(fieldView).offset(-5);
        make.top.equalTo(fieldView).offset(5);
        make.height.equalTo(@20);
    }];
    //登录
    UIButton *registerButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onRenzheng:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"立即认证" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button.tag=buttonTag;
        button;
    });
    [fieldView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infolabel.mas_bottom).offset(5);
        make.left.equalTo(fieldView).offset(5);
        make.right.equalTo(fieldView).offset(-5);
        make.height.equalTo(@30);
    }];
}
- (void)createNamedView {
    UIView *contetView = self.contentView;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"实名认证";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = UIColorFromRGB(0x9a875f);
    [contetView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contetView);
        make.right.equalTo(contetView);
        make.top.equalTo(contetView).offset(5);
        make.height.equalTo(@20);
    }];

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [contetView addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contetView);
        make.right.equalTo(contetView);
        make.top.equalTo(label.mas_bottom);
        make.height.equalTo(@88);
    }];
    UILabel *label1 = [self createLabel:@"当前账户：" font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x8e8e8e) alignment:NSTextAlignmentCenter];
    self.usenameLabel = [self createLabel:@"" font:[UIFont dp_systemFontOfSize:11.0] color:[UIColor dp_flatBlackColor] alignment:NSTextAlignmentLeft];
    UILabel *label3 = [self createLabel:@"真实姓名：" font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x8e8e8e) alignment:NSTextAlignmentCenter];
    self.accuNamelabel = [self createLabel:@"" font:[UIFont dp_systemFontOfSize:11.0] color:[UIColor dp_flatBlackColor] alignment:NSTextAlignmentLeft];
    UILabel *label5 = [self createLabel:@"身份证号：" font:[UIFont dp_systemFontOfSize:11.0] color:UIColorFromRGB(0x8e8e8e) alignment:NSTextAlignmentCenter];
    self.idCardlabel = [self createLabel:@"" font:[UIFont dp_systemFontOfSize:11.0] color:[UIColor dp_flatBlackColor] alignment:NSTextAlignmentLeft];
    [fieldView addSubview:label1];
    [fieldView addSubview:self.usenameLabel];
    [fieldView addSubview:label3];
    [fieldView addSubview:self.accuNamelabel];
    [fieldView addSubview:label5];
    [fieldView addSubview:self.idCardlabel];

    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(fieldView).offset(2);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
    [self.usenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.top.equalTo(label1).offset(-1);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@27);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(label1.mas_bottom);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
    [self.accuNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right).offset(5);
        make.top.equalTo(label3).offset(-1);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@27);
    }];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(label3.mas_bottom);
        make.width.equalTo(@60);
        make.height.equalTo(@28);
    }];
    [self.idCardlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label5.mas_right).offset(5);
        make.top.equalTo(label5).offset(-1);
       make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@27);
    }];
    UIView *lineView1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xc8c3b0);
        view;
    });
    UIView *lineView2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xc8c3b0);
        view;
    });
    [fieldView addSubview:lineView1];
    [fieldView addSubview:lineView2];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(fieldView);
            make.right.equalTo(fieldView);
            make.top.equalTo(label1.mas_bottom);
            make.height.equalTo(@0.5);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView);
        make.right.equalTo(fieldView);
        make.top.equalTo(label3.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}
- (void)createNoPhoneView {
    UIView *contetView = self.contentView;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"手机认证";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = UIColorFromRGB(0x9a875f);
    [contetView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contetView);
        make.right.equalTo(contetView);
        make.top.equalTo(contetView).offset(5);
        make.height.equalTo(@20);
    }];

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [contetView addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contetView);
        make.right.equalTo(contetView);
        make.top.equalTo(label.mas_bottom);
        make.height.equalTo(@70);
    }];

    UILabel *infolabel = [[UILabel alloc] init];
    infolabel.backgroundColor = [UIColor clearColor];
    infolabel.text = @"手机认证可享受手机号码登录、找回密码、大奖通知等服务";
    infolabel.textColor = UIColorFromRGB(0x666666);
    infolabel.font = [UIFont systemFontOfSize:11.0];
    [contetView addSubview:infolabel];
    [infolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(5);
        make.right.equalTo(fieldView).offset(-5);
        make.top.equalTo(fieldView).offset(5);
        make.height.equalTo(@20);
    }];
    //手机认证
    UIButton *registerButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onRenzheng:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"立即认证" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
         button.tag=buttonTag+1;
        button;
    });
    [fieldView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infolabel.mas_bottom).offset(5);
        make.left.equalTo(fieldView).offset(5);
        make.right.equalTo(fieldView).offset(-5);
        make.height.equalTo(@30);
    }];
}
- (void)createPhonedView {
    UIView *contetView = self.contentView;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"手机认证";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = UIColorFromRGB(0x9a875f);
    [contetView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contetView);
        make.right.equalTo(contetView);
        make.top.equalTo(contetView).offset(10);
        make.height.equalTo(@20);
    }];
    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [contetView addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contetView);
        make.right.equalTo(contetView);
        make.top.equalTo(label.mas_bottom);
        make.height.equalTo(@60);
    }];
    UILabel *label1 = [self createLabel:@"手机号码：" font:[UIFont dp_boldSystemFontOfSize:11.0] color:UIColorFromRGB(0x8e8e8e) alignment:NSTextAlignmentCenter];
    self.iphoneLabel = [self createLabel:@"" font:[UIFont dp_boldSystemFontOfSize:11.0] color:[UIColor dp_flatBlackColor] alignment:NSTextAlignmentLeft];
    UILabel *label3 = [self createLabel:@"可享受手机号码登录、找回密码、大奖通知等服务。" font:[UIFont dp_boldSystemFontOfSize:10.0] color:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    UIView *lineView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xc8c3b0);
        view;
    });
    UIButton *changeButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onRenzheng:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"修改号码" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:12.0]];
        button.tag=buttonTag+3;
        button;
    });
    [fieldView addSubview:changeButton];
    [contetView addSubview:label1];
    [contetView addSubview:self.iphoneLabel];
    [contetView addSubview:label3];
    [contetView addSubview:lineView];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(5);
        make.top.equalTo(fieldView).offset(2);
        make.width.equalTo(@60);
        make.height.equalTo(@33);
    }];
    [self.iphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(5);
        make.top.equalTo(label1);
        make.width.equalTo(@95);
        make.height.equalTo(@33);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(15);
        make.top.equalTo(self.iphoneLabel.mas_bottom);
        make.right.equalTo(fieldView).offset(-10);
        make.height.equalTo(@25);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView);
        make.top.equalTo(self.iphoneLabel.mas_bottom);
        make.right.equalTo(fieldView);
        make.height.equalTo(@0.5);
    }];

    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.height.equalTo(@24);
        make.left.equalTo(self.iphoneLabel.mas_right);
        make.width.equalTo(@70);
    }];
}

- (void)createPassWordView {
    UIView *contetView = self.contentView;
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.titleLabel.font = [UIFont dp_systemFontOfSize:11.0];
    [leftButton setTitle:@"修改登录密码" forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[dp_AccountImage(@"passleftnormal.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[dp_AccountImage(@"passLeftSel.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(changePassType:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.selected = YES;
    leftButton.tag = buttonTag + 10;
    [leftButton setTitleColor:UIColorFromRGB(0xfa201e) forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
    [contetView addSubview:leftButton];

    UIButton *rightButton = [[UIButton alloc] init];
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.titleLabel.font = [UIFont dp_systemFontOfSize:11.0];
    [rightButton setTitle:@"修改提款密码" forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[dp_AccountImage(@"passRightNormal.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 10)] forState:UIControlStateNormal];

    [rightButton setBackgroundImage:[dp_AccountImage(@"passRightSel.png") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 10)] forState:UIControlStateSelected];
    [rightButton setTitleColor:UIColorFromRGB(0xfa201e) forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(changePassType:) forControlEvents:UIControlEventTouchUpInside];
    [contetView addSubview:rightButton];
    rightButton.tag = buttonTag + 11;
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contetView).offset(10);
        make.right.equalTo(contetView.mas_centerX);
        make.width.equalTo(@110);
        make.height.equalTo(@24.5);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contetView).offset(10);
        make.left.equalTo(contetView.mas_centerX);
        make.width.equalTo(@110);
        make.height.equalTo(@24.5);
    }];

    UIView *fieldView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });
    [contetView addSubview:fieldView];
    [fieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contetView);
        make.right.equalTo(contetView);
        make.top.equalTo(rightButton.mas_bottom).offset(5);
        make.height.equalTo(@170);
    }];
    self.passLabelOld = [self createLabel:@"旧登录密码" font:[UIFont dp_systemFontOfSize:11.0] color:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.passLabelNew = [self createLabel:@"新登录密码" font:[UIFont dp_systemFontOfSize:11.0] color:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    self.passlabelSure = [self createLabel:@"确认新密码" font:[UIFont dp_systemFontOfSize:11.0] color:[UIColor blackColor] alignment:NSTextAlignmentCenter];

    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"忘记密码?"]];
    NSRange contentRange = {0, [content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];

    UIButton *forgetPassbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassbtn.titleLabel.font = [UIFont dp_systemFontOfSize:12];
    forgetPassbtn.titleLabel.textColor = UIColorFromRGB(0x7C95B4);

    forgetPassbtn.backgroundColor = [UIColor clearColor];
    [fieldView addSubview:forgetPassbtn];
    [forgetPassbtn setAttributedTitle:content forState:UIControlStateNormal];
    [forgetPassbtn addTarget:self action:@selector(pvt_onRenzheng:) forControlEvents:UIControlEventTouchUpInside];
    forgetPassbtn.tag = buttonTag + 4;

    UIView *oldPassView = ({
        UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
    view;
    });

    UIView *newPassView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });

    UIView *surePassView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1.0];
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:0.8 green:0.77 blue:0.76 alpha:1].CGColor;
        view;
    });

    [fieldView addSubview:self.passLabelOld];
    [fieldView addSubview:self.passLabelNew];
    [fieldView addSubview:self.passlabelSure];
    [fieldView addSubview:oldPassView];
    [fieldView addSubview:newPassView];
    [fieldView addSubview:surePassView];

    [self.passLabelOld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(fieldView).offset(5);
        make.width.equalTo(@60);
        make.height.equalTo(@35);
    }];

    [self.passLabelNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(self.passLabelOld.mas_bottom).offset(5);
        make.width.equalTo(@60);
        make.height.equalTo(@35);
    }];
    [self.passlabelSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fieldView).offset(10);
        make.top.equalTo(self.passLabelNew.mas_bottom).offset(5);
        make.width.equalTo(@60);
        make.height.equalTo(@35);
    }];
    [oldPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passLabelOld.mas_right);
        make.top.equalTo(self.passLabelOld);
        make.width.equalTo(@170);
        make.height.equalTo(@35);
    }];
    
    for (NSLayoutConstraint *constraint in oldPassView.constraints) {
        if (constraint.firstItem == oldPassView && constraint.firstAttribute == NSLayoutAttributeWidth) {
            _moneyOldFieldW = constraint;
            break;
        }
    }

    [forgetPassbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(oldPassView.mas_right).offset(5);
        make.top.equalTo(fieldView).offset(5);
        make.right.mas_lessThanOrEqualTo(fieldView.mas_right);
        make.centerY.equalTo(oldPassView.mas_centerY) ;
    }];

    [newPassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passLabelNew.mas_right);
        make.top.equalTo(self.passLabelNew);
        make.width.equalTo(@230);
        make.height.equalTo(@35);
    }];
    [surePassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passlabelSure.mas_right);
         make.top.equalTo(self.passlabelSure);
        make.width.equalTo(@230);
        make.height.equalTo(@35);
    }];

    [contetView addSubview:self.passTextfieldOld];
    [contetView addSubview:self.passTextFieldNew];
    [contetView addSubview:self.passTextFieldSure];
    [self.passTextfieldOld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldPassView).offset(5);
        make.top.equalTo(oldPassView).offset(2);
        make.right.equalTo(oldPassView).offset(-5);
        make.bottom.equalTo(oldPassView).offset(-2);
    }];
    [self.passTextFieldNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newPassView).offset(5);
        make.top.equalTo(newPassView).offset(2);
        make.right.equalTo(newPassView).offset(-5);
        make.bottom.equalTo(newPassView).offset(-2);
    }];
    [self.passTextFieldSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surePassView).offset(5);
        make.top.equalTo(surePassView).offset(2);
        make.right.equalTo(surePassView).offset(-5);
        make.bottom.equalTo(surePassView).offset(-2);
    }];
    [contetView addSubview:self.passTextfieldMoneyOld];
    [contetView addSubview:self.passTextFieldMoneyNew];
    [contetView addSubview:self.passTextFieldMoneySure];
    [self.passTextfieldMoneyOld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oldPassView).offset(5);
        make.top.equalTo(oldPassView).offset(2);
        make.right.equalTo(oldPassView).offset(-5);
        make.bottom.equalTo(oldPassView).offset(-2);
    }];
    [self.passTextFieldMoneyNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newPassView).offset(5);
        make.top.equalTo(newPassView).offset(2);
        make.right.equalTo(newPassView).offset(-5);
        make.bottom.equalTo(newPassView).offset(-2);
    }];
    [self.passTextFieldMoneySure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(surePassView).offset(5);
        make.top.equalTo(surePassView).offset(2);
        make.right.equalTo(surePassView).offset(-5);
        make.bottom.equalTo(surePassView).offset(-2);
    }];
    self.passTextfieldOld.hidden = NO;
    self.passTextFieldNew.hidden = NO;
    self.passTextFieldSure.hidden = NO;
    self.passTextfieldMoneyOld.hidden = YES;
    self.passTextFieldMoneyNew.hidden = YES;
    self.passTextFieldMoneySure.hidden = YES;
    UIButton *registerButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor=[UIColor colorWithRed:0.97 green:0.15 blue:0.16 alpha:1.0];
        [button addTarget:self action:@selector(pvt_onRenzheng:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.layer.cornerRadius=2;
        button.tag=buttonTag+2;
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldArialOfSize:14.0]];
        button;
    });
    [fieldView addSubview:registerButton];

    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(surePassView.mas_bottom).offset(5);
        make.left.equalTo(fieldView).offset(5);
        make.right.equalTo(fieldView).offset(-5);
        make.height.equalTo(@35);
    }];
}
- (UITextField *)passTextfieldOld {
    if (_passTextfieldOld == nil) {
        _passTextfieldOld = [[UITextField alloc] init];
        _passTextfieldOld.backgroundColor = [UIColor clearColor];
        _passTextfieldOld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passTextfieldOld.textColor = UIColorFromRGB(0x8e8e8e);
        _passTextfieldOld.textAlignment = NSTextAlignmentLeft;
        _passTextfieldOld.secureTextEntry = YES;
        _passTextfieldOld.font = [UIFont dp_systemFontOfSize:12];
        _passTextfieldOld.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextfieldOld.returnKeyType = UIReturnKeyNext;
        _passTextfieldOld.delegate = self;
    }
    return _passTextfieldOld;
}
- (UITextField *)passTextFieldSure {
    if (_passTextFieldSure == nil) {
        _passTextFieldSure = [[UITextField alloc] init];
        _passTextFieldSure.backgroundColor = [UIColor clearColor];
        _passTextFieldSure.secureTextEntry = YES;
        _passTextFieldSure.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passTextFieldSure.textColor = UIColorFromRGB(0x8e8e8e);
        _passTextFieldSure.textAlignment = NSTextAlignmentLeft;
        _passTextFieldSure.font = [UIFont dp_systemFontOfSize:12];
        _passTextFieldSure.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextFieldSure.returnKeyType = UIReturnKeyDone;
        _passTextFieldSure.enablesReturnKeyAutomatically = YES;
        _passTextFieldSure.delegate = self;
    }
    return _passTextFieldSure;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.passTextfieldOld]) {
        [self.passTextFieldNew becomeFirstResponder];
    } else if ([textField isEqual:self.passTextFieldNew]) {
        [self.passTextFieldSure becomeFirstResponder];
    } else if ([textField isEqual:self.passTextFieldSure]) {
        [textField resignFirstResponder];
        [self pvt_SubmitClick:securityIndexlogin];

    } else if ([textField isEqual:self.passTextfieldMoneyOld]) {
        [self.passTextFieldMoneyNew becomeFirstResponder];
    } else if ([textField isEqual:self.passTextFieldMoneyNew]) {
        [self.passTextFieldMoneySure becomeFirstResponder];
    } else if ([textField isEqual:self.passTextFieldMoneySure]) {
        [textField resignFirstResponder];
        [self pvt_SubmitClick:securityIndexMoney];
    }
    return YES;
}

- (UITextField *)passTextFieldNew {
    if (_passTextFieldNew == nil) {
        _passTextFieldNew = [[UITextField alloc] init];
        _passTextFieldNew.backgroundColor = [UIColor clearColor];
        _passTextFieldNew.secureTextEntry = YES;
        _passTextFieldNew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passTextFieldNew.textColor = UIColorFromRGB(0x8e8e8e);
        _passTextFieldNew.textAlignment = NSTextAlignmentLeft;
        _passTextFieldNew.font = [UIFont dp_systemFontOfSize:12];
        _passTextFieldNew.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextFieldNew.returnKeyType = UIReturnKeyNext;
        _passTextFieldNew.delegate = self;
    }
    return _passTextFieldNew;
}
- (UITextField *)passTextfieldMoneyOld {
    if (_passTextfieldMoneyOld == nil) {
        _passTextfieldMoneyOld = [[UITextField alloc] init];
        _passTextfieldMoneyOld.backgroundColor = [UIColor clearColor];
        _passTextfieldMoneyOld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passTextfieldMoneyOld.textColor = UIColorFromRGB(0x8e8e8e);
        _passTextfieldMoneyOld.textAlignment = NSTextAlignmentLeft;
        _passTextfieldMoneyOld.font = [UIFont dp_systemFontOfSize:12];
        _passTextfieldMoneyOld.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextfieldMoneyOld.returnKeyType = UIReturnKeyNext;
        _passTextfieldMoneyOld.secureTextEntry = YES;
        _passTextfieldMoneyOld.delegate = self;
    }
    return _passTextfieldMoneyOld;
}
- (UITextField *)passTextFieldMoneySure {
    if (_passTextFieldMoneySure == nil) {
        _passTextFieldMoneySure = [[UITextField alloc] init];
        _passTextFieldMoneySure.backgroundColor = [UIColor clearColor];
        _passTextFieldMoneySure.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passTextFieldMoneySure.textColor = UIColorFromRGB(0x8e8e8e);
        _passTextFieldMoneySure.textAlignment = NSTextAlignmentLeft;
        _passTextFieldMoneySure.font = [UIFont dp_systemFontOfSize:12];
        _passTextFieldMoneySure.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextFieldMoneySure.returnKeyType = UIReturnKeyDone;
        _passTextFieldMoneySure.secureTextEntry = YES;
        _passTextFieldMoneySure.enablesReturnKeyAutomatically = YES;
        _passTextFieldMoneySure.delegate = self;
    }
    return _passTextFieldMoneySure;
}
- (UITextField *)passTextFieldMoneyNew {
    if (_passTextFieldMoneyNew == nil) {
        _passTextFieldMoneyNew = [[UITextField alloc] init];
        _passTextFieldMoneyNew.backgroundColor = [UIColor clearColor];
        _passTextFieldMoneyNew.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passTextFieldMoneyNew.textColor = UIColorFromRGB(0x8e8e8e);
        _passTextFieldMoneyNew.textAlignment = NSTextAlignmentLeft;
        _passTextFieldMoneyNew.font = [UIFont dp_systemFontOfSize:12];
        _passTextFieldMoneyNew.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextFieldMoneyNew.returnKeyType = UIReturnKeyNext;
        _passTextFieldMoneyNew.secureTextEntry = YES;
        _passTextFieldMoneyNew.delegate = self;
    }
    return _passTextFieldMoneyNew;
}
- (UILabel *)createLabel:(NSString *)title font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = title;
    label.font = font;
    label.textAlignment = alignment;
    return label;
}
- (void)upDateUIForDrawing {
    UIButton *allButton = (UIButton *)[self.contentView viewWithTag:buttonTag + 11];
    UIButton *forgetButton = (UIButton *)[self.contentView viewWithTag:buttonTag + 4];
    if (self.isdrawing) {
        [allButton setTitle:@"修改提款密码" forState:UIControlStateNormal];
    } else {
        [allButton setTitle:@"设置提款密码" forState:UIControlStateNormal];
    }
    if (self.moneyPass) {
        if (self.isdrawing) {
            self.passLabelOld.text = @"旧提款密码";
            self.passLabelNew.text = @"新提款密码";
            self.passlabelSure.text = @"确认新密码";
            forgetButton.hidden = NO;
            self.moneyOldFieldW.constant = 170;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } else {
            self.passLabelOld.text = @"登录密码";
            self.passLabelNew.text = @"提款密码";
            self.passlabelSure.text = @"确认密码";
            forgetButton.hidden = YES;
            self.moneyOldFieldW.constant = 230;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }
    }
}
- (void)changePassType:(UIButton *)button {
    for (int i = 0; i < 2; i++) {
        UIButton *allButton = (UIButton *)[self.contentView viewWithTag:buttonTag + 10 + i];
        allButton.selected = NO;
    }
    button.selected = YES;
    int index = button.tag - buttonTag - 10;
    UIButton *forgetButton = (UIButton *)[self.contentView viewWithTag:buttonTag + 4];
    switch (index) {
        case 0:
            self.passLabelOld.text = @"旧登录密码";
            self.passLabelNew.text = @"新登录密码";
            self.passlabelSure.text = @"确认新密码";
            self.passTextfieldOld.hidden = NO;
            self.passTextFieldNew.hidden = NO;
            self.passTextFieldSure.hidden = NO;
            self.passTextfieldMoneyOld.hidden = YES;
            self.passTextFieldMoneyNew.hidden = YES;
            self.passTextFieldMoneySure.hidden = YES;
            self.moneyPass = NO;
            forgetButton.hidden = NO;
            self.moneyOldFieldW.constant = 170;
            [self setNeedsLayout];
            [self layoutIfNeeded];
            break;
        case 1:
            self.passLabelOld.text = @"旧提款密码";
            self.passLabelNew.text = @"新提款密码";
            self.passlabelSure.text = @"确认新密码";
            self.passTextfieldOld.hidden = YES;
            self.passTextFieldNew.hidden = YES;
            self.passTextFieldSure.hidden = YES;
            self.passTextfieldMoneyOld.hidden = NO;
            self.passTextFieldMoneyNew.hidden = NO;
            self.passTextFieldMoneySure.hidden = NO;
            self.moneyPass = YES;
//            forgetButton.hidden = NO;
            [self upDateUIForDrawing];
            break;

        default:
            break;
    }
}

- (void)pvt_SubmitClick:(securityIndex)index {
    if (self.delegate && ([self.delegate respondsToSelector:@selector(buttonResponerForCell:butttonIndex:)])) {
        [self.delegate buttonResponerForCell:self butttonIndex:index];
    }
}
- (void)pvt_onRenzheng:(UIButton *)button {
    int index = button.tag - buttonTag;
    int securityIndex = 0;
    switch (index) {
        case 0:
            securityIndex = securityIndexName;
            break;
        case 1:
            securityIndex = securityIndexPhone;
            break;
        case 2:
            if (self.moneyPass) {
                securityIndex = securityIndexMoney;
            } else {
                securityIndex = securityIndexlogin;
            }

            break;
        case 3:
            securityIndex = securityIndexChangePhone;
            break;
        case 4:{
            securityIndex = self.moneyPass == YES ? securityIndexForgetTakeMoneyPSW : securityIndexForgetPassword;
            
        }
            break;
        default:
            break;
    }
    if (self.delegate && ([self.delegate respondsToSelector:@selector(buttonResponerForCell:butttonIndex:)])) {
        [self.delegate buttonResponerForCell:self butttonIndex:securityIndex];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.passTextFieldNew resignFirstResponder];
    [self.passTextfieldOld resignFirstResponder];
    [self.passTextFieldSure resignFirstResponder];
    [self.passTextfieldMoneyOld resignFirstResponder];
    [self.passTextfieldMoneyOld resignFirstResponder];
    [self.passTextFieldMoneySure resignFirstResponder];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
