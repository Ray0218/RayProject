//
//  DProjectDetailFollowHeaderCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
// 追号cell


#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPImageLabel.h"
@protocol DProjectDetailFollowHeaderCellDelegate;
@protocol DProjectDetailFollowListCellDelegate;
//追号section
@interface DProjectDetailFollowHeaderCell : UITableViewCell
@property (nonatomic, assign) id<DProjectDetailFollowHeaderCellDelegate> delegate;
@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) int followIssues; // 追的总期数
-(void)setConditionLabelText:(int)textType stopMoney:(int)stopMoney;
@end

@protocol DProjectDetailFollowHeaderCellDelegate <NSObject>

- (void)tapFollowHeaderCell:(DProjectDetailFollowHeaderCell *)cell;

@end

//追号标题
@interface DProjectDetailFollowTitleCell : UITableViewCell

@end
//追号列表
@interface DProjectDetailFollowListCell : UITableViewCell
@property (nonatomic, assign) id<DProjectDetailFollowListCellDelegate> delegate;
@property (nonatomic, assign) BOOL expand;
@property(nonatomic,strong)UIView *lineView;

-(void)setIssueLabelText:(NSString *)string;
-(void)setBeishuLabelText:(NSString *)string;
-(void)setStateLabelText:(NSString *)string;
@end

@protocol DProjectDetailFollowListCellDelegate <NSObject>

- (void)tapFollowListCell:(DProjectDetailFollowListCell *)cell;

@end

//追号 开奖结果
@interface DProjectDetailFollowResultCell : UITableViewCell
@property(nonatomic,strong,readonly)TTTAttributedLabel *resultlabel;
-(void)setResultLabelText:(NSString *)resultString  lotteryType:(int)gameType;

@end

//追号 开奖结果
@interface DProjectDetailFollowResultPK3Cell : UITableViewCell
@property(nonatomic,strong,readonly)DPImageLabel *imageLabel1,*imageLabel2,*imageLabel3;
-(void)setResultLabelText:(NSString *)resultString;

@end

