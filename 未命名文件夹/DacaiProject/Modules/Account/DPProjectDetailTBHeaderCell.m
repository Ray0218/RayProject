//
//  DPProjectDetailTBHeaderCell.m
//  DacaiProject
//
//  Created by sxf on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailTBHeaderCell.h"

@implementation DPProjectDetailTBHeaderCell
@synthesize projectMoneyLabel = _projectMoneyLabel;
@synthesize projectStatelabel = _projectStatelabel;
@synthesize baodiLabel = _baodiLabel;
@synthesize renzhouLabel = _renzhouLabel;
@synthesize yongjinLabel = _yongjinLabel;
@synthesize winyjImage = _winyjImage ;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize endTimeLabel = _endTimeLabel;
@synthesize peopleNameLabel = _peopleNameLabel;
@synthesize winLabel = _winLabel;
@synthesize lottertNameLabel = _lottertNameLabel;
@synthesize lotteryImageView = _lotteryImageView;
@synthesize levelView = _levelView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier lottery:(int)gametype {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self buildLayout];
        [self lotteryImageView:gametype];
    }
    return self;
}
- (void)buildLayout {
    UIView *contentView = self.contentView;
    self.contentView.backgroundColor=[UIColor clearColor];
    self.backgroundColor=[UIColor clearColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor dp_flatWhiteColor];
    [contentView addSubview:topView];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@115);
        make.top.equalTo(contentView);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@60);
        make.bottom.equalTo(contentView);
    }];

    //顶部
    UILabel *zonge = [self createlable:@"方案总额" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *baodi = [self createlable:@"保底" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    self.kerengouLabel = [self createlable:@"可认购" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *yongjin = [self createlable:@"佣金" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *beginTime = [self createlable:@"发起时间:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *endTime = [self createlable:@"截止时间:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    [topView addSubview:zonge];
    [topView addSubview:baodi];
    [topView addSubview:self.kerengouLabel];
    [topView addSubview:yongjin];
    [topView addSubview:beginTime];
    [topView addSubview:endTime];
    [topView addSubview:self.lotteryImageView];
    [topView addSubview:self.lottertNameLabel];
    [topView addSubview:self.projectStatelabel];
    [topView addSubview:self.projectMoneyLabel];
    [topView addSubview:self.baodiLabel];
    [topView addSubview:self.renzhouLabel];
    [topView addSubview:self.yongjinLabel];
    [topView addSubview:self.winyjImage];
    [topView addSubview:self.startTimeLabel];
    [topView addSubview:self.endTimeLabel];
    [self.lottertNameLabel setText:[[NSMutableString alloc] initWithString:@""]];
    [self.projectStatelabel setText:[[NSMutableString alloc] initWithString:@""]];
    [self.baodiLabel setText:[[NSMutableString alloc] initWithString:@""]];
    [self.yongjinLabel setText:[[NSMutableString alloc] initWithString:@""]];
    [self.lotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(3);
        make.width.equalTo(@24);
        make.top.equalTo(topView).offset(4);
        make.height.equalTo(@24);
    }];
    [self.lottertNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(30);
        make.width.equalTo(@140);
        make.top.equalTo(topView).offset(7);
        make.height.equalTo(@20);
    }];
    [self.projectStatelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-5);
        make.width.equalTo(@100);
        make.top.equalTo(self.lottertNameLabel);
        make.bottom.equalTo(self.lottertNameLabel);
    }];
    [zonge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(4);
        make.width.equalTo(@78);
        make.height.equalTo(@15);
        make.top.equalTo(self.lottertNameLabel.mas_bottom).offset(10);
    }];
    [self.projectMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(4);
        make.width.equalTo(@78);
        make.height.equalTo(@25);
        make.top.equalTo(zonge.mas_bottom);
    }];
    [baodi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zonge.mas_right);
        make.width.equalTo(@78);
        make.height.equalTo(@15);
        make.bottom.equalTo(zonge);
    }];
    
    [self.winyjImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(baodi.mas_top).offset(-15) ;
        make.centerX.equalTo(baodi.mas_right) ;
    }];
    [self.baodiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zonge.mas_right);
        make.width.equalTo(@78);
        make.height.equalTo(@25);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    [self.kerengouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baodi.mas_right);
        make.width.equalTo(@78);
        make.height.equalTo(@15);
        make.bottom.equalTo(zonge);
    }];
    [self.renzhouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.kerengouLabel);
        make.width.equalTo(@78);
        make.height.equalTo(@25);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    [yongjin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-4);
        make.width.equalTo(@78);
        make.height.equalTo(@15);
        make.bottom.equalTo(zonge);
    }];
    [self.yongjinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yongjin);
        make.width.equalTo(@78);
        make.height.equalTo(@25);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    
   
    
    [beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(20);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.bottom.equalTo(topView).offset(-5);
    }];
    [endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.left.equalTo(contentView).offset(180);
        make.height.equalTo(@25);
        make.bottom.equalTo(topView).offset(-5);
    }];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beginTime.mas_right);
        make.right.equalTo(endTime.mas_left);
        make.top.equalTo(beginTime);
        make.bottom.equalTo(beginTime);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endTime.mas_right);
        make.right.equalTo(contentView);
        make.top.equalTo(endTime);
        make.bottom.equalTo(endTime);
    }];

    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    UIView *hLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    UIView *hLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    UIView *hLine3 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    UIImageView *waveLine = [[UIImageView alloc] init];
    waveLine.backgroundColor = [UIColor clearColor];
    waveLine.image = dp_ProjectImage(@"maginaryline.png");
    [contentView addSubview:waveLine];
    [contentView addSubview:vLine1];
    [contentView addSubview:hLine1];
    [contentView addSubview:hLine2];
    [contentView addSubview:hLine3];
    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.projectMoneyLabel.mas_bottom).offset(5);
    }];
    [hLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zonge.mas_right).offset(1);
        make.width.equalTo(@0.5);
        make.top.equalTo(zonge);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    [hLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baodi.mas_right).offset(1);
        make.width.equalTo(@0.5);
        make.top.equalTo(zonge);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    [hLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.kerengouLabel.mas_right).offset(1);
        make.width.equalTo(@0.5);
        make.top.equalTo(zonge);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    [waveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.lotteryImageView.mas_bottom).offset(2);
        make.height.equalTo(@0.5);
    }];
    UIImageView *bottomLine = [[UIImageView alloc] init];
    bottomLine.backgroundColor = [UIColor clearColor];
    bottomLine.image = dp_ProjectImage(@"waveLine.png");
    [contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.startTimeLabel.mas_bottom).offset(4);
        make.height.equalTo(@4);
    }];
    //底部
    UILabel *faqiren = [self createlable:@"发起人:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    faqiren.textAlignment = NSTextAlignmentRight;
    UILabel *zhongjiang = [self createlable:@"中奖记录:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    zhongjiang.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:self.peopleNameLabel];
    [bottomView addSubview:self.winLabel];
    [bottomView addSubview:faqiren];
    [bottomView addSubview:zhongjiang];
    [faqiren mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.width.equalTo(@60);
        make.top.equalTo(bottomView).offset(9);
        make.height.equalTo(@20);
    }];
    [self.peopleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(faqiren.mas_right);
        make.width.equalTo(@150);
        make.top.equalTo(faqiren);
        make.bottom.equalTo(faqiren);
    }];

    [zhongjiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.width.equalTo(@60);
        make.bottom.equalTo(bottomView).offset(-9);
        make.height.equalTo(@20);
    }];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhongjiang.mas_right);
        make.width.equalTo(@150);
        make.top.equalTo(zhongjiang);
        make.bottom.equalTo(zhongjiang);
    }];

    UIView *vLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    [contentView addSubview:vLine2];
    [vLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(contentView).offset(0.5);
    }];
}

- (void)lotteryImageView:(int)gameType {
    NSString *imageName = @"";
    switch (gameType) {
        case GameTypeSd:
            imageName = @"fucai3D.png";
            break;
        case GameTypeSsq:
            imageName = @"ssq.png";
            break;
        case GameTypeQlc:
            imageName = @"qlc.png";
            break;
        case GameTypeDlt:
            imageName = @"dlt.png";
            break;
        case GameTypePs:
            imageName = @"pls.png";
            break;
        case GameTypePw:
            imageName = @"plw.png";
            break;
        case GameTypeQxc:
            imageName = @"qxc.png";
            break;
        case GameTypeJxsyxw:
            imageName = @"11xw.png";
            break;
        case GameTypeNmgks:
            imageName = @"ks.png";
            break;
        case GameTypeSdpks:
            imageName = @"pks.png";
            break;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            imageName = @"jclq.png";
            break;
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcHt:
        case GameTypeJcSpf:
            imageName = @"jczq.png";

            break;
        case GameTypeBdRqspf:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            imageName = @"bjdc.png";
            break;
        case GameTypeZc9:
            imageName = @"rxj.png";
            break;
        case GameTypeZc14:
            imageName = @"sfc.png";
            break;
        default:
            break;
    }
    self.lotteryImageView.image = dp_ProjectImage(imageName);
}
- (void)setLottertNameLabelText:(NSString *)gameName issue:(NSString *)issue {
    UIFont *font = [UIFont dp_systemFontOfSize:10.0];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if ([issue integerValue]==0) {
        NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 不定期", gameName]];
        [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(gameName.length + 1, 3)];
        [self.lottertNameLabel setText:buyString];
        CFRelease(fontRef);
        return;
    }
    
    NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 第%@期", gameName, issue]];
    [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(gameName.length + 1, issue.length + 2)];
    [self.lottertNameLabel setText:buyString];
    CFRelease(fontRef);
}
- (void)setBaodiLabelText:(float)money {
    UIFont *font1 = [UIFont dp_systemFontOfSize:13.5];
    CTFontRef fontRef1 = CTFontCreateWithName((__bridge CFStringRef)font1.fontName, font1.pointSize, NULL);
    UIFont *font2 = [UIFont dp_systemFontOfSize:10.0];
    CTFontRef fontRef2 = CTFontCreateWithName((__bridge CFStringRef)font2.fontName, font2.pointSize, NULL);
    NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%%", (int)(money*100)]];
    [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef1 range:NSMakeRange(0, buyString.length - 1)];
    [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef2 range:NSMakeRange(buyString.length - 1, 1)];
    [self.baodiLabel setText:buyString];
    CFRelease(fontRef1);
    CFRelease(fontRef2);
}

- (void)setYongjinLabeText:(float)money {
    UIFont *font1 = [UIFont dp_systemFontOfSize:13.5];
    CTFontRef fontRef1 = CTFontCreateWithName((__bridge CFStringRef)font1.fontName, font1.pointSize, NULL);
    UIFont *font2 = [UIFont dp_systemFontOfSize:10.0];
    CTFontRef fontRef2 = CTFontCreateWithName((__bridge CFStringRef)font2.fontName, font2.pointSize, NULL);
    NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.f%%", money]];
    [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef1 range:NSMakeRange(0, buyString.length - 1)];
    [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef2 range:NSMakeRange(buyString.length - 1, 1)];
    [self.yongjinLabel setText:buyString];
    CFRelease(fontRef1);
    CFRelease(fontRef2);
}
- (void)setLevelImageView:(NSString *)scores {

    if (_levelView == nil) {
        [self.contentView addSubview:self.levelView];
        [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.width.equalTo(@150);
            make.top.equalTo(self.peopleNameLabel);
            make.bottom.equalTo(self.peopleNameLabel);
        }];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (scores.length == 4) {
        int chCount = 5;
        for (int i = scores.length-1; i >=0; i--) {
            unichar ch = [scores characterAtIndex:i] - '0';

            if (ch > 0) {
                chCount = chCount - 1;
                NSString *imageName = [NSString stringWithFormat:@"dengji%d.png", i + 1];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_ProjectImage(imageName)];
                imageView.backgroundColor = [UIColor clearColor];
                [self.levelView addSubview:imageView];
                [array addObject:imageView];

                UIImageView *backImageView = [[UIImageView alloc] initWithImage:dp_ProjectImage(@"textback.png")];
                imageView.backgroundColor = [UIColor clearColor];
                [imageView addSubview:backImageView];
                UILabel *label = [[UILabel alloc] init];
                label.text = [NSString stringWithFormat:@"%d", ch];
                label.textColor = [UIColor colorWithRed:0.99 green:0.4 blue:0.11 alpha:1];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:9];
                label.textAlignment = NSTextAlignmentRight;
                [imageView addSubview:label];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.levelView).offset(-20*(4-chCount));
                    make.centerY.equalTo(self.levelView);
                    make.width.equalTo(@18);
                    make.height.equalTo(@18);
                }];
                [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(imageView);
                    make.bottom.equalTo(imageView);
                    make.width.equalTo(@9);
                    make.height.equalTo(@9);
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(backImageView);
                    make.width.equalTo(@7);
                    make.height.equalTo(@7);
                }];
            }
        }
    }
    [array enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {}];
}
#pragma mark--getter,setter
- (TTTAttributedLabel *)lottertNameLabel {
    if (_lottertNameLabel == nil) {
        _lottertNameLabel = [[TTTAttributedLabel alloc] init];
        _lottertNameLabel.backgroundColor = [UIColor clearColor];
        _lottertNameLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _lottertNameLabel.textColor = UIColorFromRGB(0x2e2e2e);
        _lottertNameLabel.textAlignment = NSTextAlignmentLeft;
        _lottertNameLabel.userInteractionEnabled=NO;
    }
    return _lottertNameLabel;
}
- (UILabel *)projectStatelabel {
    if (_projectStatelabel == nil) {
        _projectStatelabel = [[UILabel alloc] init];
        _projectStatelabel.backgroundColor = [UIColor clearColor];
        _projectStatelabel.textColor = UIColorFromRGB(0x2e2e2e);
        _projectStatelabel.font = [UIFont dp_systemFontOfSize:13.5];
        _projectStatelabel.textAlignment = NSTextAlignmentRight;
    }
    return _projectStatelabel;
}
- (UILabel *)projectMoneyLabel {
    if (_projectMoneyLabel == nil) {
        _projectMoneyLabel = [[UILabel alloc] init];
        _projectMoneyLabel.backgroundColor = [UIColor clearColor];
        _projectMoneyLabel.textColor = [UIColor dp_flatBlackColor];
        _projectMoneyLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _projectMoneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _projectMoneyLabel;
}

- (TTTAttributedLabel *)baodiLabel {
    if (_baodiLabel == nil) {
        _baodiLabel = [[TTTAttributedLabel alloc] init];
        _baodiLabel.backgroundColor = [UIColor clearColor];
        _baodiLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _baodiLabel.textColor = [UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1];
        _baodiLabel.textAlignment = NSTextAlignmentCenter;
        _baodiLabel.userInteractionEnabled=NO;
    }
    return _baodiLabel;
}
- (UILabel *)renzhouLabel {
    if (_renzhouLabel == nil) {
        _renzhouLabel = [[UILabel alloc] init];
        _renzhouLabel.backgroundColor = [UIColor clearColor];
        _renzhouLabel.textColor = [UIColor dp_flatBlackColor];
        _renzhouLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _renzhouLabel.textAlignment = NSTextAlignmentCenter;
        _renzhouLabel.userInteractionEnabled=NO;
    }
    return _renzhouLabel;
}
- (TTTAttributedLabel *)yongjinLabel {
    if (_yongjinLabel == nil) {
        _yongjinLabel = [[TTTAttributedLabel alloc] init];
        _yongjinLabel.backgroundColor = [UIColor clearColor];
        _yongjinLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _yongjinLabel.textColor = [UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1];
        _yongjinLabel.textAlignment = NSTextAlignmentCenter;
        _yongjinLabel.userInteractionEnabled=NO;
    }
    return _yongjinLabel;
}
-(UIImageView*)winyjImage
{
    if (_winyjImage == nil) {
        _winyjImage = [[UIImageView alloc]init];
        _winyjImage.backgroundColor = [UIColor clearColor] ;
        _winyjImage.image = dp_ProjectImage(@"winseal.png") ;
        _winyjImage.hidden = YES ;
    }
    return _winyjImage ;
}

- (UILabel *)startTimeLabel {
    if (_startTimeLabel == nil) {
        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.backgroundColor = [UIColor clearColor];
        _startTimeLabel.textColor = [UIColor dp_flatBlackColor];
        _startTimeLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _startTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _startTimeLabel;
}
- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
        _endTimeLabel.textColor = [UIColor dp_flatBlackColor];
        _endTimeLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _endTimeLabel;
}
- (UILabel *)peopleNameLabel {
    if (_peopleNameLabel == nil) {
        _peopleNameLabel = [[UILabel alloc] init];
        _peopleNameLabel.backgroundColor = [UIColor clearColor];
        _peopleNameLabel.textColor = [UIColor dp_flatBlackColor];
        _peopleNameLabel.font = [UIFont dp_systemFontOfSize:11.0];
    }
    return _peopleNameLabel;
}
- (UILabel *)winLabel {
    if (_winLabel == nil) {
        _winLabel = [[UILabel alloc] init];
        _winLabel.backgroundColor = [UIColor clearColor];
        _winLabel.textColor = UIColorFromRGB(0x1d1d1d);
        _winLabel.font = [UIFont dp_systemFontOfSize:12.0];
    }
    return _winLabel;
}
- (UIImageView *)lotteryImageView {
    if (_lotteryImageView == nil) {
        _lotteryImageView = [[UIImageView alloc] init];
        _lotteryImageView.backgroundColor = [UIColor clearColor];
    }
    return _lotteryImageView;
}
- (UIImageView *)levelView {
    if (_levelView == nil) {
        _levelView = [UIImageView dp_viewWithColor:[UIColor clearColor]];
    }
    return _levelView;
}
- (UILabel *)createlable:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont {
    UILabel *lable = [[UILabel alloc] init];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = color;
    lable.font = titleFont;
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DPProjectDetailDaiGouHeaderCell
@synthesize projectMoneyLabel = _projectMoneyLabel;
@synthesize projectStatelabel = _projectStatelabel;
@synthesize winLabel = _winLabel;
@synthesize startTimeLabel = _startTimeLabel;
@synthesize endTimeLabel = _endTimeLabel;
@synthesize lottertNameLabel = _lottertNameLabel;
@synthesize lotteryImageView = _lotteryImageView;
@synthesize peopleNameLabel = _peopleNameLabel;
@synthesize winInfoLabel = _winInfoLabel;
@synthesize winImage = _winImage ;
@synthesize levelView = _levelView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier lottery:(int)gametype {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self buildLayout];
        [self lotteryImageView:gametype];
    }
    return self;
}
- (void)buildLayout {
    UIView *contentView = self.contentView;
    contentView.backgroundColor = [UIColor clearColor];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor dp_flatWhiteColor];
    [contentView addSubview:topView];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor clearColor];
    [contentView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@110);
        make.top.equalTo(contentView);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@60);
        make.bottom.equalTo(contentView);
    }];
    //顶部
    UILabel *zonge = [self createlable:@"方案总额" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *yongjin = [self createlable:@"中奖金额" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *beginTime = [self createlable:@"发起时间:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    UILabel *endTime = [self createlable:@"截止时间:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    [topView addSubview:zonge];
    [topView addSubview:yongjin];
    [topView addSubview:beginTime];
    [topView addSubview:endTime];
    [topView addSubview:self.lotteryImageView];
    [topView addSubview:self.lottertNameLabel];
    [topView addSubview:self.projectStatelabel];
    [topView addSubview:self.projectMoneyLabel];
    [topView addSubview:self.winLabel];
    [topView addSubview:self.winImage];
    [topView addSubview:self.startTimeLabel];
    [topView addSubview:self.endTimeLabel];
    [self.lottertNameLabel setText:[[NSMutableString alloc] initWithString:@""]];
    [self.projectStatelabel setText:[[NSMutableString alloc] initWithString:@""]];

    [self.lotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(3);
        make.width.equalTo(@24);
        make.top.equalTo(topView).offset(4);
        make.height.equalTo(@24);
    }];
    [self.lottertNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(30);
        make.width.equalTo(@140);
        make.top.equalTo(topView).offset(7);
        make.height.equalTo(@20);
    }];
    [self.projectStatelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-5);
        make.width.equalTo(@100);
        make.top.equalTo(self.lottertNameLabel);
        make.bottom.equalTo(self.lottertNameLabel);
    }];
    [zonge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(@(self.frame.size.width/2));
        make.height.equalTo(@15);
        make.top.equalTo(self.lottertNameLabel.mas_bottom).offset(10);
    }];
    
    [self.winImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(zonge.mas_right) ;
        make.centerY.equalTo(zonge.mas_top).offset(-15) ;
    }];
    [self.projectMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(4);
        make.right.equalTo(zonge);
        make.height.equalTo(@25);
        make.top.equalTo(zonge.mas_bottom);
    }];
    [yongjin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView);
        make.left.equalTo(zonge.mas_right);
        make.height.equalTo(@15);
        make.bottom.equalTo(zonge);
    }];
    [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yongjin);
        make.left.equalTo(yongjin);
        make.height.equalTo(@25);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    
    
    [beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(20);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
        make.bottom.equalTo(topView).offset(-5);
    }];
    [endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.left.equalTo(contentView).offset(180);
        make.height.equalTo(@25);
        make.bottom.equalTo(topView).offset(-5);
    }];
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(beginTime.mas_right);
        make.right.equalTo(endTime.mas_left);
        make.top.equalTo(beginTime);
        make.bottom.equalTo(beginTime);
    }];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endTime.mas_right);
        make.right.equalTo(contentView);
        make.top.equalTo(endTime);
        make.bottom.equalTo(endTime);
    }];

    UIView *vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    UIView *hLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    UIImageView *waveLine = [[UIImageView alloc] init];
    waveLine.backgroundColor = [UIColor clearColor];
    waveLine.image = dp_ProjectImage(@"maginaryline.png");
    [contentView addSubview:waveLine];
    [contentView addSubview:vLine1];
    [contentView addSubview:hLine1];

    [vLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.projectMoneyLabel.mas_bottom).offset(5);
    }];
    [hLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zonge.mas_right).offset(-0.5);
        make.width.equalTo(@0.5);
        make.top.equalTo(zonge);
        make.bottom.equalTo(self.projectMoneyLabel);
    }];
    [waveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.lotteryImageView.mas_bottom).offset(2);
        make.height.equalTo(@0.5);
    }];
    UIImageView *bottomLine = [[UIImageView alloc] init];
    bottomLine.backgroundColor = [UIColor clearColor];
    bottomLine.image = dp_ProjectImage(@"waveLine.png");
    [contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(self.startTimeLabel.mas_bottom).offset(4);
        make.height.equalTo(@4);
    }];
    
    //底部
    UILabel *faqiren = [self createlable:@"发起人:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    faqiren.textAlignment = NSTextAlignmentRight;
    UILabel *zhongjiang = [self createlable:@"中奖记录:" titleColor:UIColorFromRGB(0x948f89) titleFont:[UIFont dp_systemFontOfSize:11.0]];
    zhongjiang.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:self.peopleNameLabel];
    [bottomView addSubview:self.winInfoLabel];
    [bottomView addSubview:faqiren];
    [bottomView addSubview:zhongjiang];
    [faqiren mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.width.equalTo(@60);
        make.top.equalTo(bottomView).offset(9);
        make.height.equalTo(@20);
    }];
    [self.peopleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(faqiren.mas_right);
        make.width.equalTo(@150);
        make.top.equalTo(faqiren);
        make.bottom.equalTo(faqiren);
    }];
    
    [zhongjiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(5);
        make.width.equalTo(@60);
        make.bottom.equalTo(bottomView).offset(-9);
        make.height.equalTo(@20);
    }];
    [self.winInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhongjiang.mas_right);
        make.width.equalTo(@150);
        make.top.equalTo(zhongjiang);
        make.bottom.equalTo(zhongjiang);
    }];
    
    UIView *vLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xeadecb)];
    [contentView addSubview:vLine2];
    [vLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(contentView).offset(0.5);
    }];

}

- (void)lotteryImageView:(int)gameType {
    NSString *imageName = @"";
    switch (gameType) {
        case GameTypeSd:
            imageName = @"fucai3D.png";
            break;
        case GameTypeSsq:
            imageName = @"ssq.png";
            break;
        case GameTypeQlc:
            imageName = @"qlc.png";
            break;
        case GameTypeDlt:
            imageName = @"dlt.png";
            break;
        case GameTypePs:
            imageName = @"pls.png";
            break;
        case GameTypePw:
            imageName = @"plw.png";
            break;
        case GameTypeQxc:
            imageName = @"qxc.png";
            break;
        case GameTypeJxsyxw:
            imageName = @"syxw.png";
            break;
        case GameTypeNmgks:
            imageName = @"ks.png";
            break;
        case GameTypeSdpks:
            imageName = @"pks.png";
            break;
        case GameTypeLcSf:
        case GameTypeLcRfsf:
        case GameTypeLcSfc:
        case GameTypeLcDxf:
        case GameTypeLcHt:
            imageName = @"jclq.png";
            break;
        case GameTypeJcRqspf:
        case GameTypeJcBf:
        case GameTypeJcZjq:
        case GameTypeJcBqc:
        case GameTypeJcHt:
        case GameTypeJcSpf:
            imageName = @"jczq.png";

            break;
        case GameTypeBdRqspf:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        case GameTypeBdSf:
            imageName = @"bjdc.png";
            break;
        case GameTypeZc9:
            imageName = @"rxj.png";
            break;
        case GameTypeZc14:
            imageName = @"sfc.png";
            break;
        default:
            break;
    }
    self.lotteryImageView.image = dp_ProjectImage(imageName);
}
- (void)setLottertNameLabelText:(NSString *)gameName issue:(NSString *)issue {
    UIFont *font = [UIFont dp_systemFontOfSize:10.0];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 第%@期", gameName, issue]];
    [buyString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(gameName.length + 1, issue.length + 2)];
    [self.lottertNameLabel setText:buyString];
    CFRelease(fontRef);
}

- (void)setYongjinLabeText:(NSString *)money {
//    if ([money integerValue]==0) {
//        money=@"--";
//        NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:money];
//        [self.winLabel setText:buyString];
//        return;
//    }
    if ([money isEqualToString:@"--"]) {
        NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:money];
        [self.winLabel setText:buyString];
        return;
    }
    
    NSMutableAttributedString *buyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", money]];
    [buyString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0, money.length)];
    [buyString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatBlackColor] CGColor] range:NSMakeRange(money.length, 1)];
    [self.winLabel setText:buyString];
}

- (void)setLevelImageView:(NSString *)scores {
    
    if (_levelView == nil) {
        [self.contentView addSubview:self.levelView];
        [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.width.equalTo(@150);
            make.top.equalTo(self.peopleNameLabel);
            make.bottom.equalTo(self.peopleNameLabel);
        }];
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (scores.length == 4) {
        int chCount = 5;
        for (int i =scores.length-1; i >=0; i--) {
            unichar ch = [scores characterAtIndex:i] - '0';
            
            if (ch > 0) {
                chCount = chCount - 1;
                NSString *imageName = [NSString stringWithFormat:@"dengji%d.png", i + 1];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:dp_ProjectImage(imageName)];
                imageView.backgroundColor = [UIColor clearColor];
                [self.levelView addSubview:imageView];
                [array addObject:imageView];
                
                UIImageView *backImageView = [[UIImageView alloc] initWithImage:dp_ProjectImage(@"textback.png")];
                imageView.backgroundColor = [UIColor clearColor];
                [imageView addSubview:backImageView];
                UILabel *label = [[UILabel alloc] init];
                label.text = [NSString stringWithFormat:@"%d", ch];
                label.textColor = [UIColor colorWithRed:0.99 green:0.4 blue:0.11 alpha:1];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:9];
                label.textAlignment = NSTextAlignmentRight;
                [imageView addSubview:label];
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.levelView).offset(-20*(4-chCount));
                    //                    make.left.equalTo(self.levelView).offset(20*(4-chCount));
                    
                    make.centerY.equalTo(self.levelView);
                    make.width.equalTo(@18);
                    make.height.equalTo(@18);
                }];
                [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(imageView);
                    make.bottom.equalTo(imageView);
                    make.width.equalTo(@9);
                    make.height.equalTo(@9);
                }];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(backImageView);
                    make.width.equalTo(@7);
                    make.height.equalTo(@7);
                }];
            }
        }
    }
    [array enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {}];
}



#pragma mark--getter,setter
- (TTTAttributedLabel *)lottertNameLabel {
    if (_lottertNameLabel == nil) {
        _lottertNameLabel = [[TTTAttributedLabel alloc] init];
        _lottertNameLabel.backgroundColor = [UIColor clearColor];
        _lottertNameLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _lottertNameLabel.textColor = UIColorFromRGB(0x2e2e2e);
        _lottertNameLabel.textAlignment = NSTextAlignmentLeft;
        _lottertNameLabel.userInteractionEnabled=NO;
    }
    return _lottertNameLabel;
}
- (UILabel *)projectStatelabel {
    if (_projectStatelabel == nil) {
        _projectStatelabel = [[UILabel alloc] init];
        _projectStatelabel.backgroundColor = [UIColor clearColor];
        _projectStatelabel.textColor = UIColorFromRGB(0x2e2e2e);
        _projectStatelabel.text=@"--";
        _projectStatelabel.font = [UIFont dp_systemFontOfSize:13.5];
        _projectStatelabel.textAlignment = NSTextAlignmentRight;
    }
    return _projectStatelabel;
}
- (UILabel *)projectMoneyLabel {
    if (_projectMoneyLabel == nil) {
        _projectMoneyLabel = [[UILabel alloc] init];
        _projectMoneyLabel.backgroundColor = [UIColor clearColor];
        _projectMoneyLabel.textColor = [UIColor dp_flatBlackColor];
        _projectMoneyLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _projectMoneyLabel.text=@"--";
        _projectMoneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _projectMoneyLabel;
}

- (TTTAttributedLabel *)winLabel {
    if (_winLabel == nil) {
        _winLabel = [[TTTAttributedLabel alloc] init];
        _winLabel.backgroundColor = [UIColor clearColor];
        _winLabel.font = [UIFont dp_systemFontOfSize:13.5];
        _winLabel.textColor = [UIColor colorWithRed:0.35 green:0.29 blue:0.16 alpha:1];
        _winLabel.textAlignment = NSTextAlignmentCenter;
         _winLabel.userInteractionEnabled=NO;
    }
    return _winLabel;
}
- (UILabel *)startTimeLabel {
    if (_startTimeLabel == nil) {
        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.backgroundColor = [UIColor clearColor];
        _startTimeLabel.textColor = [UIColor dp_flatBlackColor];
        _startTimeLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _startTimeLabel.textAlignment = NSTextAlignmentLeft;
        _startTimeLabel.text=@"--";
    }
    return _startTimeLabel;
}
- (UILabel *)endTimeLabel {
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.backgroundColor = [UIColor clearColor];
        _endTimeLabel.textColor = [UIColor dp_flatBlackColor];
        _endTimeLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
         _endTimeLabel.text=@"--";
    }
    return _endTimeLabel;
}

- (UIImageView *)lotteryImageView {
    if (_lotteryImageView == nil) {
        _lotteryImageView = [[UIImageView alloc] init];
        _lotteryImageView.backgroundColor = [UIColor clearColor];
    }
    return _lotteryImageView;
}
- (UILabel *)peopleNameLabel {
    if (_peopleNameLabel == nil) {
        _peopleNameLabel = [[UILabel alloc] init];
        _peopleNameLabel.backgroundColor = [UIColor clearColor];
        _peopleNameLabel.textColor = [UIColor dp_flatBlackColor];
        _peopleNameLabel.font = [UIFont dp_systemFontOfSize:11.0];
        _peopleNameLabel.text=@"--";
    }
    return _peopleNameLabel;
}

-(UIImageView*)winImage
{

    if (_winImage == nil) {
        _winImage = [[UIImageView alloc]init];
        _winImage.backgroundColor = [UIColor clearColor] ;
        _winImage.image = dp_ProjectImage(@"winseal.png") ;
        _winImage.hidden = YES ;
    }
    return _winImage ;
}
- (UILabel *)winInfoLabel {
    if (_winInfoLabel == nil) {
        _winInfoLabel = [[UILabel alloc] init];
        _winInfoLabel.backgroundColor = [UIColor clearColor];
        _winInfoLabel.textColor = UIColorFromRGB(0x1d1d1d);
        _winInfoLabel.font = [UIFont dp_systemFontOfSize:12.0];
    }
    return _winInfoLabel;
}

- (UIImageView *)levelView {
    if (_levelView == nil) {
        _levelView = [UIImageView dp_viewWithColor:[UIColor clearColor]];
        
    }
    return _levelView;
}

- (UILabel *)createlable:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)titleFont {
    UILabel *lable = [[UILabel alloc] init];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = color;
    lable.font = titleFont;
    lable.text = title;
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
