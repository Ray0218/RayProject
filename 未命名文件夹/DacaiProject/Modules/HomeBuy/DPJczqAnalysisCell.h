//
//  DPJczqAnalysisCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPLiveDataCenterViewController.h"

@class DPJczqAnalysisCell ;
typedef void (^clickAnalysisBlock)(DPJczqAnalysisCell*nalysisCell);

@interface DPJczqAnalysisCell : UITableViewCell

@property (nonatomic,assign) GameTypeId gameType;
@property (nonatomic,strong,readonly)UILabel * rqs;
@property(nonatomic,strong,readonly)UILabel *rqWinLabel,* rqTieLabel ,* rqLoseLabel;//让球
@property(nonatomic,strong,readonly)UILabel *ratioWinLabel,* ratioTieLabel,* ratioLoseLabel;//胜平负
@property(nonatomic,strong,readonly)TTTAttributedLabel *historyLabel;
@property(nonatomic,strong,readonly)TTTAttributedLabel *zhanJiLabel;
@property(nonatomic,strong,readonly)UILabel *newestWinLabel,* newestTieLabel,* newestLoseLabel;
@property (nonatomic, strong,readonly) UIActivityIndicatorView   * activityIndicatorView;
-(void)clearAllData;

@property(nonatomic,copy)clickAnalysisBlock clickBlock ;

@end
