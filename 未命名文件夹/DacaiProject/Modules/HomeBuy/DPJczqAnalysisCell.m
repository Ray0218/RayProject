//
//  DPJczqAnalysisCell.m
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJczqAnalysisCell.h"
#import "UIFont+DPAdditions.h"

@interface DPJczqAnalysisCell () {
@private
    BOOL _hasLoaded;
    UILabel *_rqWinLabel,*_rqTieLabel ,*_rqLoseLabel;
    UILabel *_ratioWinLabel,*_ratioTieLabel,*_ratioLoseLabel;
    UILabel *_newestWinLabel,*_newestTieLabel,*_newestLoseLabel;
    UILabel * _rqs;
    TTTAttributedLabel *_historyLabel;
    TTTAttributedLabel *_zhanJiLabel;
}
@end
@implementation DPJczqAnalysisCell
@dynamic rqWinLabel,rqTieLabel ,rqLoseLabel;
@dynamic ratioWinLabel,ratioTieLabel,ratioLoseLabel;
@dynamic newestWinLabel,newestTieLabel,newestLoseLabel;
@dynamic rqs;
@dynamic historyLabel,zhanJiLabel;
@synthesize activityIndicatorView=_activityIndicatorView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         self.contentView.backgroundColor = [UIColor colorWithRed:0.19 green:0.25 blue:0.29 alpha:1];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!_hasLoaded && newSuperview) {
        _hasLoaded = YES;
        
        [self buildLayout];
    }
}

- (void)buildLayout {
    UIImageView * imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(-5, 0, 0, 0));
    }];
    
    UIButton * goAnalysisButton = [[UIButton alloc] init];
    [goAnalysisButton setBackgroundColor:[UIColor colorWithRed:0.35 green:0.58 blue:0.28 alpha:1]];
    [goAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goAnalysisButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goAnalysisButton setTitle:@"详细赛事分析>" forState:UIControlStateNormal];
    //    [goAnalysisButton setImage:[CommonDrawFunc retinaImageNamed:@"football.png" bundle:kDZHLTSportCathecticImagesPath] forState:UIControlStateNormal];
    [goAnalysisButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
    [goAnalysisButton.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];
    [goAnalysisButton.titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
    [goAnalysisButton addTarget:self action:@selector(pvt_onAnalysis) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:goAnalysisButton];
    
    [goAnalysisButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@25);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    switch (self.gameType) {
        case GameTypeJcSpf:
        case GameTypeJcRqspf:
        case GameTypeBdRqspf:
         case GameTypeZc9:
        case GameTypeZc14:
        {
        [self layOutSpfView];
        }
            break;
        case GameTypeJcHt:
        {
            [self layOutHtView];
        }
        break;

        case GameTypeJcBf:
        case GameTypeJcBqc:
        case GameTypeJcZjq:
        case GameTypeBdSxds:
        case GameTypeBdZjq:
        case GameTypeBdBf:
        case GameTypeBdBqc:
        {
            [self layOutBfView];
        }
            break;


        default:
            break;
    }
    
    [self.contentView addSubview:self.activityIndicatorView];
    
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];

    
    
}
-(void)clearAllData
{
    self.rqs.text=@"-";
    self.rqWinLabel.text=@"-";
    self.rqTieLabel.text=@"-";
    self.rqLoseLabel.text=@"-";
    self.ratioWinLabel.text=@"-";
    self.ratioTieLabel.text=@"-";
    self.ratioLoseLabel.text=@"-";
    self.historyLabel.text=@"-";
    self.zhanJiLabel.text=@"-";
    self.newestWinLabel.text=@"-";
    self.newestTieLabel.text=@"-";
     self.newestLoseLabel.text=@"-";
}
//混投
-(void)layOutHtView{
    UILabel * ratioTitleLabel = [self pvt_titleLabelFactory];
    UILabel * historyTitleLabel = [self pvt_titleLabelFactory];
    UILabel * newZhanJiTitleLabel = [self pvt_titleLabelFactory];
    UILabel * newestTitleLabel = [self pvt_titleLabelFactory];
    ratioTitleLabel.text = @"投注比例";
    historyTitleLabel.text = @"历史交锋";
    newZhanJiTitleLabel.text=@"近期战绩";
    newestTitleLabel.text = @"平均赔率";
    
    [self.contentView addSubview:ratioTitleLabel];
    [self.contentView addSubview:historyTitleLabel];
    [self.contentView addSubview:newZhanJiTitleLabel];
    [self.contentView addSubview:newestTitleLabel];
    
    UILabel *rationLabel=[self pvt_gridLabelFactory];
    rationLabel.text=@"0";
//    self.ratioWinLabel = [self pvt_gridLabelFactory];
//    self.ratioTieLabel = [self pvt_gridLabelFactory];
//    self.ratioLoseLabel = [self pvt_gridLabelFactory];
    
//    self.rqs=[self pvt_gridLabelFactory];
   
//    self. rqWinLabel = [self pvt_gridLabelFactory];
//    self. rqTieLabel = [self pvt_gridLabelFactory];
//    self.rqLoseLabel = [self pvt_gridLabelFactory];
    
//   self. historyLabel = [self pvt_mulColorLabel];
//   self. zhanJiLabel = [self pvt_mulColorLabel];
    
//    self. newestWinLabel = [self pvt_gridLabelFactory];
//   self. newestTieLabel = [self pvt_gridLabelFactory];
//    self.newestLoseLabel = [self pvt_gridLabelFactory];
    
    [self.contentView addSubview:rationLabel];
    [self.contentView addSubview:self.ratioWinLabel];
    [self.contentView addSubview:self.ratioTieLabel];
    [self.contentView addSubview:self.ratioLoseLabel];
    [self.contentView addSubview:self.rqs];
    [self.contentView addSubview:self.rqWinLabel];
    [self.contentView addSubview:self.rqTieLabel];
    [self.contentView addSubview:self.rqLoseLabel];
    [self.contentView addSubview:self.historyLabel];
    [self.contentView addSubview:self.zhanJiLabel];
    [self.contentView addSubview:self.newestWinLabel];
    [self.contentView addSubview:self.newestTieLabel];
    [self.contentView addSubview:self.newestLoseLabel];
    
    [@[ historyTitleLabel, newZhanJiTitleLabel,newestTitleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@25);
    }];
    [@[rationLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ratioTitleLabel.mas_right).offset(-1);
        make.top.equalTo(ratioTitleLabel);
        make.height.equalTo(@26);
    }];
    [@[self.rqs] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ratioTitleLabel.mas_right).offset(-1);
        make.bottom.equalTo(ratioTitleLabel);
        make.height.equalTo(@25);
    }];
    [@[self.ratioWinLabel, self.ratioTieLabel, self.ratioLoseLabel, self.rqWinLabel, self.rqTieLabel, self.rqLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(kScreenWidth*0.23));
    }];
    [@[self.newestWinLabel, self.newestTieLabel, self.newestLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kScreenWidth*0.26));
    }];
    
    [ratioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@50);
        make.width.equalTo(historyTitleLabel);
    }];
    [historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ratioTitleLabel.mas_bottom).offset(-1);
    }];
    [newZhanJiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyTitleLabel.mas_bottom).offset(-1);
    }];
    [newestTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newZhanJiTitleLabel.mas_bottom).offset(-1);
    }];
    
    NSArray * ratioLabels = @[rationLabel, self.ratioWinLabel, self.ratioTieLabel, self.ratioLoseLabel];
    for (int i = 0; i < ratioLabels.count - 1; i++) {
        UILabel * preLabel = ratioLabels[i];
        UILabel * curLabel = ratioLabels[i + 1];
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.height.equalTo(@26);
        }];
    }
    NSArray * rqLabels = @[self.rqs, self.rqWinLabel, self.rqTieLabel,self.rqLoseLabel];
    for (int i = 0; i < rqLabels.count - 1; i++) {
        UILabel * preLabel = rqLabels[i];
        UILabel * curLabel = rqLabels[i + 1];
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.height.equalTo(@25);
        }];
    }
    
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(historyTitleLabel.mas_right).offset(-1);
//        make.left.equalTo(rationLabel);
        make.left.equalTo(self.newestWinLabel);
        make.top.equalTo(historyTitleLabel);
        make.bottom.equalTo(historyTitleLabel);
    }];
    
    [self.zhanJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newZhanJiTitleLabel.mas_right).offset(-1);
//        make.left.equalTo(rationLabel);
        make.left.equalTo(self.newestWinLabel);
        make.top.equalTo(newZhanJiTitleLabel);
        make.bottom.equalTo(newZhanJiTitleLabel);
    }];
    
    NSArray * newestLabels = @[newestTitleLabel, self.newestWinLabel, self.newestTieLabel, self.newestLoseLabel];
    for (int i = 0; i < newestLabels.count - 1; i++) {
        UILabel * preLabel = newestLabels[i];
        UILabel * curLabel = newestLabels[i + 1];
        
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.bottom.equalTo(preLabel);
        }];
    }
    [@[self.ratioLoseLabel,self.rqLoseLabel, self.historyLabel, self.zhanJiLabel,self.newestLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(1);
    }];
}

//胜负彩，让球胜负彩
-(void)layOutSpfView{
    UILabel * ratioTitleLabel = [self pvt_titleLabelFactory];
    UILabel * historyTitleLabel = [self pvt_titleLabelFactory];
    UILabel * newZhanJiTitleLabel = [self pvt_titleLabelFactory];
    UILabel * newestTitleLabel = [self pvt_titleLabelFactory];
    ratioTitleLabel.text = @"投注比例";
    historyTitleLabel.text = @"历史交锋";
    newZhanJiTitleLabel.text=@"近期战绩";
    newestTitleLabel.text = @"平均赔率";
    
    [self.contentView addSubview:ratioTitleLabel];
    [self.contentView addSubview:historyTitleLabel];
    [self.contentView addSubview:newZhanJiTitleLabel];
    [self.contentView addSubview:newestTitleLabel];
    
//    self.ratioWinLabel = [self pvt_gridLabelFactory];
//    self.ratioTieLabel = [self pvt_gridLabelFactory];
//   self.ratioLoseLabel = [self pvt_gridLabelFactory];
//    
//   self.historyLabel = [self pvt_mulColorLabel];
//   self.zhanJiLabel = [self pvt_mulColorLabel];
//    
//    self. newestWinLabel = [self pvt_gridLabelFactory];
//    self.newestTieLabel = [self pvt_gridLabelFactory];
//   self. newestLoseLabel = [self pvt_gridLabelFactory];
    
    [self.contentView addSubview:self.ratioWinLabel];
    [self.contentView addSubview:self.ratioTieLabel];
    [self.contentView addSubview:self.ratioLoseLabel];
    [self.contentView addSubview:self.historyLabel];
    [self.contentView addSubview:self.zhanJiLabel];
    [self.contentView addSubview:self.newestWinLabel];
    [self.contentView addSubview:self.newestTieLabel];
    [self.contentView addSubview:self.newestLoseLabel];
    
    [@[ratioTitleLabel, historyTitleLabel, newZhanJiTitleLabel,newestTitleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@25);
    }];
    
    [@[self.ratioWinLabel,self. ratioTieLabel, self.ratioLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView).multipliedBy(0.26);
    }];
    
    [@[self.newestWinLabel, self.newestTieLabel, self.newestLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView).multipliedBy(0.26);
    }];
    
    [ratioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
    }];
    [historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ratioTitleLabel.mas_bottom).offset(-1);
    }];
    [newZhanJiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyTitleLabel.mas_bottom).offset(-1);
    }];
    [newestTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newZhanJiTitleLabel.mas_bottom).offset(-1);
    }];
    
    NSArray * ratioLabels = @[ratioTitleLabel,self.ratioWinLabel, self.ratioTieLabel, self.ratioLoseLabel];
    for (int i = 0; i < ratioLabels.count - 1; i++) {
        UILabel * preLabel = ratioLabels[i];
        UILabel * curLabel = ratioLabels[i + 1];
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.bottom.equalTo(preLabel);
            
        }];
    }

    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(historyTitleLabel.mas_right).offset(-1);
        make.left.equalTo(self.newestWinLabel);
        make.top.equalTo(historyTitleLabel);
        make.bottom.equalTo(historyTitleLabel);
    }];
    
    [self.zhanJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newZhanJiTitleLabel.mas_right).offset(-1);
        make.left.equalTo(self.newestWinLabel);
        make.top.equalTo(newZhanJiTitleLabel);
        make.bottom.equalTo(newZhanJiTitleLabel);
    }];
    
    NSArray * newestLabels = @[newestTitleLabel, self.newestWinLabel, self.newestTieLabel, self.newestLoseLabel];
    for (int i = 0; i < newestLabels.count - 1; i++) {
        UILabel * preLabel = newestLabels[i];
        UILabel * curLabel = newestLabels[i + 1];
        
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.bottom.equalTo(preLabel);
        }];
    }
    [@[self.ratioLoseLabel,self. historyLabel, self.zhanJiLabel,self.newestLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(1);
    }];
}

//比分，半全场，总进球
-(void)layOutBfView{
    UILabel * historyTitleLabel = [self pvt_titleLabelFactory];
    UILabel * newZhanJiTitleLabel = [self pvt_titleLabelFactory];
    UILabel * newestTitleLabel = [self pvt_titleLabelFactory];
    historyTitleLabel.text = @"历史交锋";
    newZhanJiTitleLabel.text=@"近期战绩";
    newestTitleLabel.text = @"平均赔率";

    [self.contentView addSubview:historyTitleLabel];
    [self.contentView addSubview:newZhanJiTitleLabel];
    [self.contentView addSubview:newestTitleLabel];
    
//    self.historyLabel = [self pvt_mulColorLabel];
//   self.zhanJiLabel = [self pvt_mulColorLabel];
    

    [self.contentView addSubview:self.historyLabel];
    [self.contentView addSubview:self.zhanJiLabel];
    [self.contentView addSubview:self.newestWinLabel];
    [self.contentView addSubview:self.newestTieLabel];
    [self.contentView addSubview:self.newestLoseLabel];
    
    [@[historyTitleLabel, newZhanJiTitleLabel,newestTitleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@25);
    }];
    
    [@[self.newestWinLabel, self.newestTieLabel, self.newestLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView).multipliedBy(0.26);
    }];
    
    [historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
    }];
    [newZhanJiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyTitleLabel.mas_bottom).offset(-1);
    }];
    [newestTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newZhanJiTitleLabel.mas_bottom).offset(-1);
    }];
    
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(historyTitleLabel.mas_right).offset(-1);
        make.left.equalTo(self.newestWinLabel);
        make.top.equalTo(historyTitleLabel);
        make.bottom.equalTo(historyTitleLabel);
    }];
    
    [self.zhanJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newZhanJiTitleLabel.mas_right).offset(-1);
        make.left.equalTo(self.newestWinLabel);
        make.top.equalTo(newZhanJiTitleLabel);
        make.bottom.equalTo(newZhanJiTitleLabel);
    }];
    
    NSArray * newestLabels = @[newestTitleLabel, self.newestWinLabel, self.newestTieLabel, self.newestLoseLabel];
    for (int i = 0; i < newestLabels.count - 1; i++) {
        UILabel * preLabel = newestLabels[i];
        UILabel * curLabel = newestLabels[i + 1];
        
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.bottom.equalTo(preLabel);
        }];
    }
    [@[self.historyLabel, self.zhanJiLabel,self.newestLoseLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(1);
    }];
}

- (UILabel *)pvt_titleLabelFactory
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0xfffdbd);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    label.layer.borderWidth = 1;
    return label;
}

- (UILabel *)rqWinLabel
{
    if(_rqWinLabel==nil){
    _rqWinLabel = [[UILabel alloc] init];
    _rqWinLabel.textColor = UIColorFromRGB(0xfffdbd);
    _rqWinLabel.backgroundColor = [UIColor clearColor];
    _rqWinLabel.font = [UIFont dp_boldSystemFontOfSize:12];
    _rqWinLabel.textAlignment = NSTextAlignmentCenter;
    _rqWinLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    _rqWinLabel.layer.borderWidth = 1;
    }
    return _rqWinLabel;
}

- (UILabel *)rqTieLabel
{
    if (_rqTieLabel==nil) {
    
    _rqTieLabel = [[UILabel alloc] init];
    _rqTieLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
    _rqTieLabel.backgroundColor = [UIColor clearColor];
    _rqTieLabel.font = [UIFont dp_systemFontOfSize:12];
    _rqTieLabel.text=@"--";
    _rqTieLabel.textAlignment = NSTextAlignmentCenter;
    _rqTieLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    _rqTieLabel.layer.borderWidth = 1;
    }
    return _rqTieLabel;
}
- (UILabel *)rqLoseLabel
{
    if (_rqLoseLabel==nil) {
  
    _rqLoseLabel = [[UILabel alloc] init];
    _rqLoseLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
    _rqLoseLabel.backgroundColor = [UIColor clearColor];
    _rqLoseLabel.font = [UIFont dp_systemFontOfSize:12];
    _rqLoseLabel.text=@"--";
    _rqLoseLabel.textAlignment = NSTextAlignmentCenter;
    _rqLoseLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    _rqLoseLabel.layer.borderWidth = 1;
    }
    return _rqLoseLabel;
}
- (UILabel *)ratioWinLabel
{
    if (_ratioWinLabel==nil) {
  
    _ratioWinLabel = [[UILabel alloc] init];
    _ratioWinLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
    _ratioWinLabel.backgroundColor = [UIColor clearColor];
    _ratioWinLabel.font = [UIFont dp_systemFontOfSize:12];
    _ratioWinLabel.text=@"--";
    _ratioWinLabel.textAlignment = NSTextAlignmentCenter;
    _ratioWinLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    _ratioWinLabel.layer.borderWidth = 1;
    }
    return _ratioWinLabel;
}
- (UILabel *)ratioTieLabel
{
    if (_ratioTieLabel==nil) {
    _ratioTieLabel = [[UILabel alloc] init];
    _ratioTieLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
    _ratioTieLabel.backgroundColor = [UIColor clearColor];
    _ratioTieLabel.font = [UIFont dp_systemFontOfSize:12];
    _ratioTieLabel.text=@"--";
    _ratioTieLabel.textAlignment = NSTextAlignmentCenter;
    _ratioTieLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    _ratioTieLabel.layer.borderWidth = 1;
    }
    return _ratioTieLabel;
}
- (UILabel *)ratioLoseLabel
{
    if (_ratioLoseLabel==nil) {
        _ratioLoseLabel = [[UILabel alloc] init];
        _ratioLoseLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
        _ratioLoseLabel.backgroundColor = [UIColor clearColor];
        _ratioLoseLabel.font = [UIFont dp_systemFontOfSize:12];
        _ratioLoseLabel.text=@"--";
        _ratioLoseLabel.textAlignment = NSTextAlignmentCenter;
        _ratioLoseLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _ratioLoseLabel.layer.borderWidth = 1;
    }
    return _ratioLoseLabel;
}

- (UILabel *)newestWinLabel
{
    if (_newestWinLabel==nil) {
        _newestWinLabel = [[UILabel alloc] init];
        _newestWinLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
        _newestWinLabel.backgroundColor = [UIColor clearColor];
        _newestWinLabel.font = [UIFont dp_systemFontOfSize:12];
        _newestWinLabel.text=@"--";
        _newestWinLabel.textAlignment = NSTextAlignmentCenter;
        _newestWinLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _newestWinLabel.layer.borderWidth = 1;
    }
    return _newestWinLabel;
}

- (UILabel *)newestTieLabel
{
    if (_newestTieLabel==nil) {
        _newestTieLabel = [[UILabel alloc] init];
        _newestTieLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
        _newestTieLabel.backgroundColor = [UIColor clearColor];
        _newestTieLabel.font = [UIFont dp_systemFontOfSize:12];
        _newestTieLabel.text=@"--";
        _newestTieLabel.textAlignment = NSTextAlignmentCenter;
        _newestTieLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _newestTieLabel.layer.borderWidth = 1;
    }
    return _newestTieLabel;
}

- (UILabel *)newestLoseLabel
{
    if (_newestLoseLabel==nil) {
        _newestLoseLabel = [[UILabel alloc] init];
        _newestLoseLabel.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
        _newestLoseLabel.backgroundColor = [UIColor clearColor];
        _newestLoseLabel.font = [UIFont dp_systemFontOfSize:12];
        _newestLoseLabel.text=@"--";
        _newestLoseLabel.textAlignment = NSTextAlignmentCenter;
        _newestLoseLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _newestLoseLabel.layer.borderWidth = 1;
    }
    return _newestLoseLabel;
}
- (UILabel *)rqs
{
    if (_rqs==nil) {
        _rqs = [[UILabel alloc] init];
        _rqs.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
        _rqs.backgroundColor = [UIColor clearColor];
        _rqs.font = [UIFont dp_systemFontOfSize:12];
        _rqs.text=@"--";
        _rqs.textAlignment = NSTextAlignmentCenter;
        _rqs.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _rqs.layer.borderWidth = 1;
    }
    return _rqs;
}

- (UILabel *)pvt_gridLabelFactory
{
    
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:12];
        label.text=@"--";
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        label.layer.borderWidth = 1;
    return label;
}
-(TTTAttributedLabel *)historyLabel{
    if (_historyLabel==nil) {
    _historyLabel=[[TTTAttributedLabel alloc] init];
    _historyLabel.backgroundColor=[UIColor clearColor];
    _historyLabel.userInteractionEnabled=NO;
    _historyLabel.textAlignment=NSTextAlignmentLeft;
    _historyLabel.font=[UIFont dp_systemFontOfSize:12.0];
    _historyLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    _historyLabel.layer.borderWidth = 1;
    }
    return _historyLabel;
}
-(TTTAttributedLabel *)zhanJiLabel{
    if (_zhanJiLabel==nil) {
        _zhanJiLabel=[[TTTAttributedLabel alloc] init];
        _zhanJiLabel.backgroundColor=[UIColor clearColor];
        _zhanJiLabel.userInteractionEnabled=NO;
        _zhanJiLabel.textAlignment=NSTextAlignmentLeft;
        _zhanJiLabel.font=[UIFont dp_systemFontOfSize:12.0];
        _zhanJiLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _zhanJiLabel.layer.borderWidth = 1;
    }
    return _zhanJiLabel;
}
- (UIActivityIndicatorView *)activityIndicatorView
{
    if (_activityIndicatorView == nil)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.color = [UIColor whiteColor];
    }
    return _activityIndicatorView;
}
- (void)pvt_onAnalysis
{
    if (self.clickBlock) {
        self.clickBlock(self) ;
    }
    
}
-(void)upDateAnalysisCellData{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
