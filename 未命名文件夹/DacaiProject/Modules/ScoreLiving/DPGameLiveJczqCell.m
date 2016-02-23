//
//  DPGameLiveJczqCell.m
//  DacaiProject
//
//  Created by sxf on 14/12/5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPGameLiveJczqCell.h"

@implementation DPGameLiveJczqCell
@dynamic timeLabel;
@dynamic homeTeamImage;
@dynamic awayTeamImage;
@dynamic homeTeamName;
@dynamic awayTeamName;
@dynamic homeTeamRank;
@dynamic awayTeamRank;
@dynamic beginTimeStatusLabel;
@dynamic scoreLabel;
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
    [contentView addSubview:self.halfscoreLabel];
    [guanzhubtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.top.equalTo(contentView).offset(15);
        make.height.equalTo(@70);
        make.width.equalTo(@60);
    }];
    [rightralView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-17);
        make.top.equalTo(contentView).offset(37.5);
    }];
    
    [homeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(guanzhubtn.mas_right);
        make.top.equalTo(contentView).offset(25);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    [awayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
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

    [self.homeTeamImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(homeBackView);
    }];
   
    [self.awayTeamImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(awayBackView);
    }];
    [self.homeTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(homeBackView);
        make.top.equalTo(homeBackView.mas_bottom).offset(5);
    }];
    [self.awayTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(awayBackView);
        make.top.equalTo(homeBackView.mas_bottom).offset(5);
    }];
    [self.homeTeamRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.homeTeamName.mas_left);
        make.top.equalTo(self.homeTeamName).offset(2);
    }];
    [self.awayTeamRank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayTeamName.mas_right);
        make.top.equalTo(self.awayTeamName).offset(2);
    }];
    
    [self.beginTimeStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).offset(27);
        make.height.equalTo(@11);
    }];
    [self.timedianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginTimeStatusLabel.mas_right);
        make.centerY.equalTo(self.beginTimeStatusLabel);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.beginTimeStatusLabel.mas_bottom).offset(3);
        make.height.equalTo(@21);
    }];
    [contentView addSubview:self.analysisView];
    [self.halfscoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(1);
        make.height.equalTo(@8);
    }];
    [self.analysisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(12);
    }];
    [midbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(homeBackView.mas_right);
        make.right.equalTo(awayBackView.mas_left);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [midbackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMatchInfo)]];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView);
        make.left.equalTo(awayBackView.mas_left);
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
- (void)pvt_onEventInfo {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(openGameLiveEVentForCell:)]) {
        [self.delegate openGameLiveEVentForCell:self];
    }
}
-(void)guanzhuBtn:(UIButton *)button{
    button.selected=!button.selected;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(guanzhuGameLiveInfoForCell: button: matchId:)]) {
        [self.delegate guanzhuGameLiveInfoForCell:self button:button matchId:self.matchId];
    }
}
-(void)analysisViewIsExpand:(BOOL)isExpand{
    
    if (isExpand) {
        self.analysisView.image = dp_CommonImage(@"brown_smallarrow_down.png");
    
    }else{
        self.analysisView.image = dp_CommonImage(@"brown_smallarrow_up.png");
        
    }
    
}
-(NSString *)matchScoreStatus:(NSInteger)status{
    NSString *string=@"";
    switch (status) {
        case 0:
            string=@"未开始";
            break;
        case 11:
            string=@"上半场正在进行";
            break;
        case 21:
            string=@"中场休息";
            break;
        case 31:
            string=@"下半场正在进行";
            break;
        case 41:
            string=@"已结束";
            break;
        case 95:
            string=@"中断";
            break;
        case 96:
            string=@"待定";
            break;
        case 97:
            string=@"腰折";
            break;
        case 98:
            string=@"推迟";
            break;
        case 99:
            string=@"已取消";
            break;
        default:
            break;
    }
    return string;

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
        _scoreLabel.font=[UIFont dp_boldSystemFontOfSize:20.0];
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

-(UILabel *)halfscoreLabel{
    if (_halfscoreLabel==nil) {
        _halfscoreLabel=[[UILabel alloc] init];
        _halfscoreLabel.backgroundColor=[UIColor clearColor];
        _halfscoreLabel.textColor=UIColorFromRGB(0x666666);
        _halfscoreLabel.font=[UIFont dp_boldSystemFontOfSize:9.0];
        _halfscoreLabel.textAlignment=NSTextAlignmentLeft;
        _halfscoreLabel.text=@"";
    }
    return _halfscoreLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DPgameLiveJCInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  eventTotal:(NSInteger)eventTotal
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *contentView=self.contentView;
        UIImageView *backView=[[UIImageView alloc] init];
        backView.image=[dp_GameLiveImage(@"zqinfobg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 2, 0)  resizingMode:UIImageResizingModeStretch];
        backView.backgroundColor=[UIColor clearColor];
        [contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView).offset(-8);
            make.bottom.equalTo(contentView);
        }];
        UIView *titleView=[UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        [contentView addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(5);
            make.right.equalTo(contentView).offset(-5);
            make.top.equalTo(contentView).offset(10);
            make.height.equalTo(@24);
        }];
        UILabel *title1=[[UILabel alloc] init];
        title1.backgroundColor=[UIColor clearColor];
         title1.text=@"主队";
        title1.textAlignment=NSTextAlignmentRight;
        title1.font=[UIFont dp_regularArialOfSize:12.0];
        title1.textColor=UIColorFromRGB(0x666666);
        [titleView addSubview:title1];
        UILabel *title2=[[UILabel alloc] init];
        title2.backgroundColor=[UIColor clearColor];
        title2.text=@"时间";
        title2.textAlignment=NSTextAlignmentCenter;
        title2.font=[UIFont dp_regularArialOfSize:12.0];
        title2.textColor=UIColorFromRGB(0x666666);
        [titleView addSubview:title2];
        UILabel *title3=[[UILabel alloc] init];
        title3.backgroundColor=[UIColor clearColor];
        title3.text=@"客队";
        title3.textAlignment=NSTextAlignmentLeft;
        title3.font=[UIFont dp_regularArialOfSize:12.0];
        title3.textColor=UIColorFromRGB(0x666666);
        [titleView addSubview:title3];
        [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleView);
            make.width.equalTo(@90);
            make.centerY.equalTo(titleView);
        }];
        [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(titleView);
        }];
        [title3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(titleView);
            make.width.equalTo(@90);
            make.centerY.equalTo(titleView);
        }];
        
        NSArray *imageNameArray=[NSArray arrayWithObjects:@"jinqu.png", @"dianqiu.png",@"wulong.png",@"huangpai.png",@"hongpai.png",@"honghuangpai.png",nil];
        NSArray *titleArray=[NSArray arrayWithObjects:@"进球", @"点球",@"乌龙",@"黄牌",@"红牌",@"两黄变红",nil];
        for(int i=0;i<imageNameArray.count;i++){
            DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
            imageLabel.spacing = 3;
            imageLabel.imagePosition = DPImagePositionLeft;
            imageLabel.backgroundColor = [UIColor clearColor];
            imageLabel.font = [UIFont dp_systemFontOfSize:12];
            imageLabel.image=dp_GameLiveImage(imageNameArray[i]);
            imageLabel.text=titleArray[i];
            imageLabel.textColor=UIColorFromRGB(0x666666);
            [contentView addSubview:imageLabel];
            if (i==imageNameArray.count-1) {
                [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(contentView).offset(45*i+10);
                    make.right.equalTo(contentView).offset(-5);
                    make.bottom.equalTo(contentView);
                    make.height.equalTo(@30);
                }];
            }else{
            [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView).offset(45*i+10);
                make.width.equalTo(@40);
                make.bottom.equalTo(contentView);
                make.height.equalTo(@30);
            }];
            }

           
        }
        
        UIView *line1=[UIView dp_viewWithColor:UIColorFromRGB(0xcbc5b4)];
        [contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.width.equalTo(@0.5);
            make.top.equalTo(titleView.mas_bottom);
            make.height.equalTo(@5);
        }];
        UIView *line2=[UIView dp_viewWithColor:UIColorFromRGB(0xc7c3b4)];
        [contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(contentView);
            make.left.equalTo(contentView);
            make.bottom.equalTo(contentView).offset(-30);
            make.height.equalTo(@0.5);
        }];
       
        [self.contentView addSubview:self.noDataIamgeLabel];
        [self.noDataIamgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(contentView);
        }];
        [self.noDataIamgeLabel addSubview:self.noDataLabel];
        [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.noDataIamgeLabel);
            make.centerY.equalTo(self.noDataIamgeLabel).offset(7);
        }];
        self.noDataIamgeLabel.hidden=YES;
        self.noDataLabel.hidden=YES;

        
        
        for (int i=0; i<eventTotal; i++) {
            UIImageView *backImageView=[[UIImageView alloc] initWithImage:dp_GameLiveImage(@"teamnamebg.png")];
            backImageView.backgroundColor=[UIColor clearColor];
            backImageView.tag=gameLiveBgTag+i;
            [contentView addSubview:backImageView];
            
            
            UIImageView *eventImageView=[[UIImageView alloc] init];
            eventImageView.backgroundColor=[UIColor clearColor];
            eventImageView.tag=gameLiveImageTag+i;
            [backImageView addSubview:eventImageView];
            UILabel *eventNamelabel=[[UILabel alloc] init];
            eventNamelabel.textColor=UIColorFromRGB(0x666666);
            eventNamelabel.tag=gameLiveLabelTag+i;
            eventNamelabel.font = [UIFont dp_systemFontOfSize:12];
            eventNamelabel.backgroundColor = [UIColor clearColor];
            [backImageView addSubview:eventNamelabel];
//            DPImageLabel *imageLabel = [[DPImageLabel alloc] init];
//            imageLabel.spacing = 5;
//            imageLabel.imagePosition = DPImagePositionLeft;
//            imageLabel.backgroundColor = [UIColor clearColor];
//            imageLabel.font = [UIFont dp_systemFontOfSize:12];
//            imageLabel.image=dp_GameLiveResizeImage(@"hongpai.png");
//            imageLabel.text=@"";
//            imageLabel.tag=gameLiveImageTag+i;
//            imageLabel.textColor=UIColorFromRGB(0x666666);
//            [backImageView addSubview:imageLabel];
            
            UIImageView *timebackView=[[UIImageView alloc] init];
            timebackView.backgroundColor=[UIColor clearColor];
            timebackView.image=dp_GameLiveImage(@"秒数_03.png");
            [contentView addSubview:timebackView];
            UILabel *timelabel=[[UILabel alloc] init];
            timelabel.backgroundColor=[UIColor clearColor];
            timelabel.text=@"";
            timelabel.tag=gameLiveTimeTag+i;
            timelabel.textColor=UIColorFromRGB(0x333333);
            timelabel.textAlignment=NSTextAlignmentCenter;
            timelabel.font=[UIFont dp_regularArialOfSize:12.0];
            [timebackView addSubview:timelabel];
            
            [timebackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView);
                make.top.equalTo(titleView.mas_bottom).offset(30*i+5);
                make.height.equalTo(@22);
            }];
            [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(timebackView);
                make.height.equalTo(@22.5);
                make.left.equalTo(contentView).offset(30);
                make.width.equalTo(@110);
            }];
            
            [eventImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backImageView).offset(10);
                make.centerY.equalTo(backImageView);
            }];
            [eventNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(eventImageView.mas_right).offset(5);
                make.centerY.equalTo(backImageView);
            }];
            
            UIView *sline=[UIView dp_viewWithColor:UIColorFromRGB(0xcbc5b4)];
            [contentView addSubview:sline];
            [sline mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(contentView);
                make.width.equalTo(@0.5);
                make.top.equalTo(timebackView.mas_bottom);
                make.height.equalTo(@8);
            }];
        }
        
//        UIImageView *tralView=[[UIImageView alloc] init];
//        tralView.backgroundColor=[UIColor clearColor];
//        tralView.image=dp_GameLiveImage(@"graytral.png");
//        [contentView addSubview:tralView];
//        [tralView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(contentView);
//            make.bottom.equalTo(self.contentView.mas_top).offset(0.5);
//        }];
    }
    return self;
}
-(NSString *)gameliveEventForIndex:(NSInteger)index{
    NSString *eventString=@"";
    switch (index) {
        case 1://1:进球
            eventString=@"dajinqiu.png";
            break;
        case 2://2:红牌
             eventString=@"hongpai.png";
            break;
        case 3://黄牌
             eventString=@"huangpai.png";
            break;
        case 6://进球不算
            
            break;
        case 7://点球
             eventString=@"dadianqiu.png";
            break;
        case 8://乌龙
             eventString=@"dawulong.png";
            break;
        case 9://(2黄牌→红牌)
             eventString=@"dahongpai.png";
            break;
        default:
            break;
    }
    return eventString;
}
-(UIImageView *)noDataIamgeLabel{
    if (_noDataIamgeLabel==nil) {
        _noDataIamgeLabel  = [[UIImageView alloc]init];
        _noDataIamgeLabel.backgroundColor=[UIColor clearColor];
        _noDataIamgeLabel.image = dp_GameLiveImage(@"noinfo.png") ;

    }
    return _noDataIamgeLabel;
   
}
-(UILabel *)noDataLabel{
    if (_noDataLabel==nil) {
        _noDataLabel=[[UILabel alloc] init];
        _noDataLabel.backgroundColor=[UIColor clearColor];
        _noDataLabel.text=@"暂无数据";
        _noDataLabel.font=[UIFont dp_boldArialOfSize:20.0];
        _noDataLabel.textColor=UIColorFromRGB(0xb9b1a4);
    }
    return _noDataLabel;

}
-(void)changeBackViewLayOut:(NSInteger)index  ishome:(BOOL)ishome{
    UIImageView *imageView=(UIImageView *)[self.contentView viewWithTag:gameLiveBgTag+index];
    
    float leftWidth=kScreenWidth-30-110;
    if (ishome) {
        leftWidth=30;
    }else{
    imageView.image=dp_GameLiveImage(@"teamnamebgright.png");
    }
    [self.contentView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == imageView && constraint.firstAttribute == NSLayoutAttributeLeft) {
            constraint.constant = leftWidth;
            *stop = YES;
        }
        [self.contentView layoutIfNeeded];
    }];
    
//    UIImageView *teamNameView=(UIImageView *)[self.contentView viewWithTag:gameLiveImageTag+index];
//    [imageView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
//        if (constraint.firstItem == teamNameView && constraint.firstAttribute == NSLayoutAttributeLeft) {
//            constraint.constant = 10;
//            *stop = YES;
//        }
//        [self.contentView layoutIfNeeded];
//    }];
    


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

