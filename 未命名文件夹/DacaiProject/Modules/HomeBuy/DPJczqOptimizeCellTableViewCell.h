//
//  DPJczqOptimizeCellTableViewCell.h
//  DacaiProject
//
//  Created by Ray on 14/11/10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDHTMLLabel/MDHTMLLabel.h>
#import "DPBetToggleControl.h"


@protocol DPJczqOptimizeCellDelegate  ;

@interface DPJczqOptimizeCellTableViewCell : UITableViewCell
@property (nonatomic, weak) id<DPJczqOptimizeCellDelegate> delegate;
@property(nonatomic,strong)UITextField* numberField ;
@property(nonatomic,strong) MDHTMLLabel* awardLabel ;
@property(nonatomic,assign)NSInteger lastNum;

-(void)stopChangeNum; //停止改变数字
-(void)buildLayout ;

@end
@protocol DPJczqOptimizeCellDelegate <NSObject>

-(void)changnum:(NSString*)num OptimizeCell:(DPJczqOptimizeCellTableViewCell*)cell ;

@end



@protocol  DPJczqOptimizeTextCellDelegate ;

@interface DPJczqOptimizeTextCell : UITableViewCell

@property(nonatomic,strong) UILabel* matchLabel ;//比赛名称
@property(nonatomic,strong,readonly) UIImageView* rightImg ;
@property (nonatomic, weak) id<DPJczqOptimizeTextCellDelegate> delegate;


-(void)buildLayout ;
-(void)analysisViewIsExpand:(BOOL)isExpand;//箭头变化

@end

@protocol DPJczqOptimizeTextCellDelegate <NSObject>

- (void)jczqOptimizeInfo:(DPJczqOptimizeTextCell *)cell;

@end




@interface DPJczqOptimizeAnalysisCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray*  sessionArray ;
@property(nonatomic,strong)NSMutableArray* homeArray ;
@property(nonatomic,strong)NSMutableArray* awayArray ;
@property(nonatomic,strong)NSMutableArray* contentArray ;



-(void)buildLayout ;
-(void)buildContentWithSportCount:(NSInteger)sportCount ;


@end

#define offSet 33
#define cellHigh 25