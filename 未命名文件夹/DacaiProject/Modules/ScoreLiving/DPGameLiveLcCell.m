//
//  DPGameLiveLcCell.m
//  DacaiProject
//
//  Created by sxf on 14/12/15.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPGameLiveLcCell.h"

@implementation DPGameLiveLcCell
@dynamic timeLabel;
@dynamic homeTeamImage;
@dynamic awayTeamImage;
@dynamic homeTeamName;
@dynamic awayTeamName;
@dynamic homeTeamRank;
@dynamic awayTeamRank;
@dynamic beginTimeStatusLabel;
@dynamic scoreLabel;
@dynamic dianView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self bulidLayout];
    }
    return self;
}

-(void)bulidLayout{
    UIView *contentView=self.contentView;
    UIView *lineView=[UIView dp_viewWithColor:UIColorFromRGB(0xe7e3d8)];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(contentView);
    }];
    
    UIImageView *dianView=[[UIImageView alloc] init];
    dianView.backgroundColor=[UIColor clearColor];
    dianView.image=dp_GameLiveImage(@"zongdian.png");
    [contentView addSubview:dianView];
    [contentView addSubview:self.timeLabel];
    [dianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.top.equalTo(contentView).offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView);
        make.height.equalTo(@14);
        make.centerY.equalTo(dianView);
    }];
    UIButton *guanzhubtn=[[UIButton alloc] init];
    guanzhubtn.backgroundColor=[UIColor clearColor];
    guanzhubtn.tag=1401;
    [guanzhubtn setImage:dp_GameLiveImage(@"guanzhunormal.png") forState:UIControlStateNormal];
    [guanzhubtn setImage:dp_GameLiveImage(@"guanzhuselected.png") forState:UIControlStateSelected];
    [guanzhubtn addTarget:self action:@selector(guanzhuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:guanzhubtn];
    
    UIImageView *rightralView=[[UIImageView alloc] init];
    rightralView.backgroundColor=[UIColor clearColor];
    rightralView.image=dp_GameLiveImage(@"cellrightselect.png");
    [contentView addSubview:rightralView];
    UIView *homeBackView = [[UIView alloc] init];
    UIView *awayBackView = [[UIView alloc] init];
    homeBackView.layer.cornerRadius = awayBackView.layer.cornerRadius = 20;
    homeBackView.backgroundColor = awayBackView.backgroundColor = [UIColor whiteColor];
    homeBackView.clipsToBounds = awayBackView.clipsToBounds = YES;
    
    UIImageView *homeLogoHoverView=[[UIImageView alloc] initWithImage:dp_GameLiveImage(@"ballnamebg.png")];
    homeLogoHoverView.backgroundColor=[UIColor clearColor];
    UIImageView *awayLogoHoverView=[[UIImageView alloc] initWithImage:dp_GameLiveImage(@"ballnamebg.png")];
    awayLogoHoverView.backgroundColor=[UIColor clearColor];
    
    UILabel *zhulabel=[[UILabel alloc] init];
    zhulabel.text=@"(主)";
    zhulabel.textColor=UIColorFromRGB(0x666666);
    zhulabel.backgroundColor=[UIColor clearColor];
    zhulabel.font=[UIFont dp_regularArialOfSize:10.0];
    [contentView addSubview:zhulabel];
    UILabel *kelabel=[[UILabel alloc] init];
    kelabel.text=@"(客)";
    kelabel.textColor=UIColorFromRGB(0x666666);
    kelabel.backgroundColor=[UIColor clearColor];
    kelabel.font=[UIFont dp_regularArialOfSize:10.0];
    [contentView addSubview:kelabel];
    
    UIView *midbackView=[UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:midbackView];
    UIView *rightView=[UIView dp_viewWithColor:[UIColor clearColor]];
    [contentView addSubview:rightView];
    [contentView addSubview:homeBackView];
    [contentView addSubview:awayBackView];
    [contentView addSubview:homeLogoHoverView];
    [contentView addSubview:awayLogoHoverView];
    [homeBackView addSubview:self.homeTeamImage];
    [awayBackView addSubview:self.awayTeamImage];
    [contentView addSubview:self.homeTeamName];
    [contentView addSubview:self.awayTeamName];
    [contentView addSubview:self.homeTeamRank];
    [contentView addSubview:self.awayTeamRank];
    [contentView addSubview:self.beginTimeStatusLabel];
    [contentView addSubview:self.timedianLabel];
    [contentView addSubview:self.scoreLabel];
    [guanzhubtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(contentView).offset(15);
        make.height.equalTo(@70);
        make.width.equalTo(@50);
    }];
    [rightralView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-17);
        make.top.equalTo(contentView).offset(37.5);
    }];

    [awayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(guanzhubtn.mas_right);
        make.top.equalTo(contentView).offset(25);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [homeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-60);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [homeLogoHoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(homeBackView);
    }];
    [awayLogoHoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(awayBackView);
    }];

    //篮彩主客相反的  因此 home，keLabel为客   away,zhuLabel为主
    [self.homeTeamImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(homeBackView);
    }];
    
    [self.awayTeamImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(awayBackView);
    }];
    [self.awayTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(awayBackView);
        make.top.equalTo(awayBackView.mas_bottom).offset(5);
    }];
    [self.homeTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(homeBackView);
        make.top.equalTo(homeBackView.mas_bottom).offset(5);
    }];
    [kelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayTeamName.mas_right);
        make.top.equalTo(self.awayTeamName).offset(2);
    }];
    [zhulabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.homeTeamName.mas_right);
        make.top.equalTo(self.homeTeamName).offset(3);
    }];
    [self.awayTeamRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.awayTeamName);
        make.top.equalTo(self.awayTeamName.mas_bottom).offset(2);
    }];
    [self.homeTeamRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.homeTeamName);
        make.top.equalTo(self.homeTeamName.mas_bottom).offset(2);
    }];

    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(30);
        make.height.equalTo(@21);
    }];
    [self.beginTimeStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(18);
        make.height.equalTo(@11);
    }];
    [self.timedianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginTimeStatusLabel.mas_right);
        make.centerY.equalTo(self.beginTimeStatusLabel);
    }];

    [contentView addSubview:self.analysisView];
    [self.analysisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.beginTimeStatusLabel.mas_bottom).offset(6);
    }];
    [midbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(awayBackView.mas_right);
        make.right.equalTo(homeBackView.mas_left);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [contentView addSubview:self.dianView];
    [self.dianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
       make.top.equalTo(self.scoreLabel.mas_bottom).offset(-1);
    }];
   [midbackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMatchInfo)]];
    
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView);
        make.left.equalTo(homeBackView.mas_right);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onEventInfo)]];

}
- (void)pvt_onMatchInfo {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(openGameLiveInfoForCell:)]) {
        [self.delegate openGameLiveInfoForCell:self];
    }
}
-(void)guanzhuBtn:(UIButton *)button{
    button.selected=!button.selected;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(guanzhuGameLiveInfoForCell: button: matchId:)]) {
        [self.delegate guanzhuGameLiveInfoForCell:self button:button matchId:self.matchId];
    }
}
- (void)pvt_onEventInfo {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(openGameLiveEVentForCell:)]) {
        [self.delegate openGameLiveEVentForCell:self];
    }
}
-(void)analysisViewIsExpand:(BOOL)isExpand{
    
    if (isExpand) {
        self.analysisView.image = dp_CommonImage(@"brown_smallarrow_down.png");
        
    }else{
        self.analysisView.image = dp_CommonImage(@"brown_smallarrow_up.png");
        
    }
    
}
- (void)awakeFromNib
{
    // Initialization code
}
-(UILabel *)timeLabel{
    if (_timeLabel==nil) {
        _timeLabel=[[UILabel alloc] init];
        _timeLabel.backgroundColor=[UIColor clearColor];
        _timeLabel.textColor=[UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];;
        _timeLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _timeLabel.textAlignment=NSTextAlignmentLeft;
        _timeLabel.text=@"";
    }
    return _timeLabel;
}
-(UIImageView*)homeTeamImage{
    if (_homeTeamImage==nil) {
        _homeTeamImage=[[UIImageView alloc] init];
        _homeTeamImage.backgroundColor=[UIColor clearColor];
        _homeTeamImage.image=dp_SportLotteryImage(@"default.png");
    }
    return _homeTeamImage;
}
-(UIImageView*)awayTeamImage{
    if (_awayTeamImage==nil) {
        _awayTeamImage=[[UIImageView alloc] init];
        _awayTeamImage.backgroundColor=[UIColor clearColor];
        _awayTeamImage.image=dp_SportLotteryImage(@"default.png");
    }
    return _awayTeamImage;
}
-(UILabel *)homeTeamName{
    if (_homeTeamName==nil) {
        _homeTeamName=[[UILabel alloc] init];
        _homeTeamName.backgroundColor=[UIColor clearColor];
        _homeTeamName.textColor=[UIColor dp_flatBlackColor];
        _homeTeamName.font=[UIFont dp_regularArialOfSize:13.0];
        _homeTeamName.textAlignment=NSTextAlignmentCenter;
        _homeTeamName.text=@"";
    }
    return _homeTeamName;
}
-(UILabel *)awayTeamName{
    if (_awayTeamName==nil) {
        _awayTeamName=[[UILabel alloc] init];
        _awayTeamName.backgroundColor=[UIColor clearColor];
        _awayTeamName.textColor=[UIColor dp_flatBlackColor];
        _awayTeamName.font=[UIFont dp_regularArialOfSize:13.0];
        _awayTeamName.textAlignment=NSTextAlignmentCenter;
        _awayTeamName.text=@"";
    }
    return _awayTeamName;
}
-(UILabel *)homeTeamRank{
    if (_homeTeamRank==nil) {
        _homeTeamRank=[[UILabel alloc] init];
        _homeTeamRank.backgroundColor=[UIColor clearColor];
        _homeTeamRank.textColor=[UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];;
        _homeTeamRank.font=[UIFont dp_regularArialOfSize:10.0];
        _homeTeamRank.textAlignment=NSTextAlignmentRight;
        _homeTeamRank.text=@"";
    }
    return _homeTeamRank;
}

-(UILabel *)awayTeamRank{
    if (_awayTeamRank==nil) {
        _awayTeamRank=[[UILabel alloc] init];
        _awayTeamRank.backgroundColor=[UIColor clearColor];
        _awayTeamRank.textColor=[UIColor colorWithRed:0.58 green:0.55 blue:0.48 alpha:1];;
        _awayTeamRank.font=[UIFont dp_regularArialOfSize:10.0];
        _awayTeamRank.textAlignment=NSTextAlignmentLeft;
        _awayTeamRank.text=@"";
    }
    return _awayTeamRank;
}

-(UILabel *)beginTimeStatusLabel{
    if (_beginTimeStatusLabel==nil) {
        _beginTimeStatusLabel=[[UILabel alloc] init];
        _beginTimeStatusLabel.backgroundColor=[UIColor clearColor];
        _beginTimeStatusLabel.textColor=[UIColor dp_flatBlackColor];
        _beginTimeStatusLabel.font=[UIFont dp_regularArialOfSize:11.0];
        _beginTimeStatusLabel.textAlignment=NSTextAlignmentLeft;
        _beginTimeStatusLabel.text=@"";
    }
    return _beginTimeStatusLabel;
}
-(UILabel *)timedianLabel{
    if (_timedianLabel==nil) {
        _timedianLabel=[[UILabel alloc] init];
        _timedianLabel.backgroundColor=[UIColor clearColor];
        _timedianLabel.textColor=[UIColor dp_flatBlackColor];
        _timedianLabel.font=[UIFont boldSystemFontOfSize:11.0];
        _timedianLabel.textAlignment=NSTextAlignmentLeft;
        _timedianLabel.text=@"′";
    }
    return _timedianLabel;
}
-(UILabel *)scoreLabel{
    if (_scoreLabel==nil) {
        _scoreLabel=[[UILabel alloc] init];
        _scoreLabel.backgroundColor=[UIColor clearColor];
        _scoreLabel.textColor=UIColorFromRGB(0x333333);
        _scoreLabel.font=[UIFont systemFontOfSize:20.0];
        _scoreLabel.textAlignment=NSTextAlignmentLeft;
        _scoreLabel.text=@"VS";
    }
    return _scoreLabel;
}
- (UIImageView *)analysisView {
    if (_analysisView == nil) {
        _analysisView = [[UIImageView alloc] init];
        _analysisView.image = dp_CommonImage(@"brown_smallarrow_down.png");
//        _analysisView.highlightedImage = dp_CommonImage(@"brown_smallarrow_up.png");
    }
    return _analysisView;
}

-(UILabel *)dianView{
    if (_dianView==nil) {
        _dianView=[[UILabel alloc] init];
        _dianView.backgroundColor=[UIColor clearColor];
        _dianView.textColor = UIColorFromRGB(0xb6ae9b) ;
        _dianView.font = [UIFont dp_boldArialOfSize:16];
        _dianView.textAlignment = NSTextAlignmentCenter;
        
    }
    return _dianView;

}

- (void)dianlabelTextForMatchState:(NSInteger)matchState {
    NSString *pointNumStr = @"●●●●";
    NSRange range;
    switch (matchState) {
        case 0:
        case 9:
        case 11: {
            return;
        } break;
        case 1: {
            range = NSMakeRange(0, 1);
        } break;
        case 2: {
            range = NSMakeRange(0, 2);
        } break;
        case 3: {
            range = NSMakeRange(0, 3);
        } break;
        case 4: {
            range = NSMakeRange(0, 4);
        } break;
        case 5: {
            range = NSMakeRange(0, 4);
            pointNumStr = @"●●●●●";
        } break;
        case -1: {
            range = NSMakeRange(0, 1);
        } break;
        case -2: {
            range = NSMakeRange(0, 2);
        } break;
        case -3: {
            range = NSMakeRange(0, 3);
        } break;
        case -4: {
            range = NSMakeRange(0, 4);
            pointNumStr = @"●●●●●";
        } break;
        default:
            range = NSMakeRange(0, 0);
            break;
    }
    NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc] initWithString:pointNumStr];
    [atributeStr addAttribute:NSForegroundColorAttributeName value:(id)[UIColor dp_flatRedColor] range:range];
    if (pointNumStr.length > 4) {
        [atributeStr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0x3eaf25) range:NSMakeRange(4, pointNumStr.length - 4)];
    }
    self.dianView.attributedText = atributeStr;
}

////红绿点
//-(void)upDateDianViewAlllayOut:(NSInteger)overTotal  jiasai:(NSInteger)jiasaiTotal  totalSaishi:(NSInteger)totalSaishi{
//    [self.dianView removeFromSuperview];
//    [self.contentView addSubview:self.dianView];
//    [self.dianView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scoreLabel.mas_bottom).offset(3);
//        make.height.equalTo(@6.5);
//        make.left.equalTo(self.scoreLabel);
//        make.right.equalTo(self.scoreLabel);
//    }];
//    NSMutableArray *imageArray=[NSMutableArray array];
//    for (int i=0; i<overTotal; i++) {
//        UIImageView *imageView=[[UIImageView alloc] init];
//        imageView.image=dp_GameLiveImage(@"hongdian.png");
//        imageView.backgroundColor=[UIColor clearColor];
//        [imageArray addObject:imageView];
//    }
//    if (jiasaiTotal>0) {
//        UIImageView *imageView=[[UIImageView alloc] init];
//        imageView.image=dp_GameLiveImage(@"lvdian.png");
//        imageView.backgroundColor=[UIColor clearColor];
//        [imageArray addObject:imageView];
//    }else{
//        UIImageView *imageView=[[UIImageView alloc] init];
//        imageView.image=dp_GameLiveImage(@"huidian.png");
//        imageView.backgroundColor=[UIColor clearColor];
//        [imageArray addObject:imageView];
//    }
//    [imageArray enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
//        [self.dianView addSubview:obj];
//    }];
//    for (int i=0; i<imageArray.count; i++) {
//        UIImageView *obj=imageArray[i];
//        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.dianView);
//            }];
//        if (imageArray.count/2==i) {
//            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(self.dianView);
//            }];
//          }
//        if (i >= imageArray.count - 1) {
//            continue;
//        }
//        UIImageView *obj1 = imageArray[i];
//        UIImageView *obj2 = imageArray[i + 1];
//        [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(obj1.mas_right).offset(4);
//        }];
//
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@implementation DPgameLiveLCInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  eventTotal:(NSInteger)eventTotal
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *contentView=self.contentView;
        UIImageView *backView=[[UIImageView alloc] init];
        backView.image=[dp_GameLiveImage(@"lcinfobg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 2, 0)  resizingMode:UIImageResizingModeStretch];
        backView.backgroundColor=[UIColor clearColor];
        [contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView).offset(-8);
            make.bottom.equalTo(contentView);
        }];
        [backView addSubview:self.fenshuLabel];
        [self.fenshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.top.equalTo(backView).offset(5);
            make.height.equalTo(@26);
        }];
        UIView *hline1=[UIView dp_viewWithColor:UIColorFromRGB(0x1d2a33)];
         UIView *hline2=[UIView dp_viewWithColor:UIColorFromRGB(0x1d2a33)];
         UIView *hline3=[UIView dp_viewWithColor:UIColorFromRGB(0x1d2a33)];
        [backView addSubview:hline1];
        [backView addSubview:hline2];
        [backView addSubview:hline3];
        [backView addSubview:self.homeLabel];
        [backView addSubview:self.drawLabel];
        [hline1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.left.equalTo(backView);
            make.top.equalTo(self.fenshuLabel.mas_bottom);
            make.height.equalTo(@1);
        }];
        [hline2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.left.equalTo(backView);
            make.top.equalTo(hline1.mas_bottom).offset(25);
            make.height.equalTo(@1);
        }];
        [self.homeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@90);
            make.left.equalTo(backView);
            make.top.equalTo(hline2.mas_bottom);
            make.height.equalTo(@25);
        }];
        [hline3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.left.equalTo(backView);
            make.top.equalTo(self.homeLabel.mas_bottom);
            make.height.equalTo(@1);
        }];
        [self.drawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.equalTo(@90);
            make.left.equalTo(backView);
            make.top.equalTo(hline3.mas_bottom);
            make.height.equalTo(@25);
        }];
        float width=(kScreenWidth-90.0)/eventTotal;
        for (int i=0; i<eventTotal; i++) {
            UILabel *titleLabel=[self createLabel:UIColorFromRGB(0x8192a2)];
            titleLabel.text=(i==4?@"加时":[NSString stringWithFormat:@"第%d节",i+1]);
            [backView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(self.homeLabel.mas_right).offset(width*i);
                make.top.equalTo(hline1.mas_bottom);
                make.height.equalTo(@25);
            }];
            
            UILabel *homeScoreLabel=[self createLabel:[UIColor dp_flatWhiteColor]];
            homeScoreLabel.text=@"-";
            homeScoreLabel.tag=homeScoreLabelTag+i;
            [backView addSubview:homeScoreLabel];
            [homeScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(self.homeLabel.mas_right).offset(width*i);
                make.top.equalTo(hline2.mas_bottom);
                make.height.equalTo(@25);
            }];

            
            UILabel *awayScoreLabel=[self createLabel:[UIColor dp_flatWhiteColor]];
             awayScoreLabel.text=@"-";
            awayScoreLabel.tag=awayScoreLabelTag+i;
            [backView addSubview:awayScoreLabel];
            [awayScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(self.homeLabel.mas_right).offset(width*i);
                make.top.equalTo(hline3.mas_bottom);
                make.height.equalTo(@25);
            }];
            UIView *sline=[UIView dp_viewWithColor:UIColorFromRGB(0x1d2a33)];
            [contentView addSubview:sline];
            [sline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(hline1.mas_bottom);
                make.bottom.equalTo(backView);
                make.left.equalTo(titleLabel);
                make.width.equalTo(@1);
            }];
        }
        
    }
    return self;
}
-(UILabel *)createLabel:(UIColor *)textColor{
    UILabel *label=[[UILabel alloc] init];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=textColor;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont dp_regularArialOfSize:12.0];
    return label;
    

}
-(UILabel *)fenshuLabel{
    if (_fenshuLabel==nil) {
        _fenshuLabel=[[UILabel alloc] init];
        _fenshuLabel.backgroundColor=[UIColor clearColor];
        _fenshuLabel.textColor=[UIColor dp_flatWhiteColor];
        _fenshuLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _fenshuLabel.textAlignment=NSTextAlignmentCenter;
        _fenshuLabel.text=@"";
    }
    return _fenshuLabel;
  
}

-(UILabel *)homeLabel{
    if (_homeLabel==nil) {
        _homeLabel=[[UILabel alloc] init];
        _homeLabel.backgroundColor=[UIColor clearColor];
        _homeLabel.textColor=UIColorFromRGB(0xdee4a8);
        _homeLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _homeLabel.textAlignment=NSTextAlignmentCenter;
        _homeLabel.text=@"";
    }
    return _homeLabel;
    
}
-(UILabel *)drawLabel{
    if (_drawLabel==nil) {
        _drawLabel=[[UILabel alloc] init];
        _drawLabel.backgroundColor=[UIColor clearColor];
        _drawLabel.textColor=UIColorFromRGB(0xdee4a8);
        _drawLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _drawLabel.textAlignment=NSTextAlignmentCenter;
        _drawLabel.text=@"";
    }
    return _drawLabel;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

