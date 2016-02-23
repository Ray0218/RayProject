//
//  DPProjectDetailTBHeaderCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
@interface DPProjectDetailTBHeaderCell : UITableViewCell

@property(nonatomic,strong,readonly)UIImageView *lotteryImageView;
@property(nonatomic,strong,readonly)TTTAttributedLabel *lottertNameLabel;//彩种名字+期号
@property(nonatomic,strong,readonly)UILabel *projectStatelabel;//方案状态
@property(nonatomic,strong,readonly)UILabel *projectMoneyLabel;//方案总额
@property(nonatomic,strong,readonly)TTTAttributedLabel *baodiLabel;//保底
@property(nonatomic,strong,readonly)UILabel *renzhouLabel;//可认购
@property(nonatomic,strong,readonly)TTTAttributedLabel *yongjinLabel;//佣金
@property(nonatomic,strong,readonly)UIImageView* winyjImage ;//中奖图标

@property(nonatomic,strong,readonly)UILabel *startTimeLabel;//发起时间
@property(nonatomic,strong,readonly)UILabel *endTimeLabel;//截止时间
@property(nonatomic,strong,readonly)UILabel *peopleNameLabel;//发起人
@property(nonatomic,strong,readonly)UILabel *winLabel;//中奖记录；
@property(nonatomic,strong,readonly)UIImageView *levelView;//等级视图

@property(nonatomic,strong)UILabel *kerengouLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier lottery:(int)gametype;
//标题
-(void)setLottertNameLabelText:(NSString *)gameName issue:(NSString *)issue;
//保底
-(void)setBaodiLabelText:(float)money;
//佣金
-(void)setYongjinLabeText:(float)money;

- (void)setLevelImageView:(NSString *)scores;
@end

@interface DPProjectDetailDaiGouHeaderCell : UITableViewCell
@property(nonatomic,strong,readonly)UIImageView *lotteryImageView;
@property(nonatomic,strong,readonly)TTTAttributedLabel *lottertNameLabel;//彩种名字+期号
@property(nonatomic,strong,readonly)UILabel *projectStatelabel;//方案状态
@property(nonatomic,strong,readonly)UILabel *projectMoneyLabel;//方案总额
@property(nonatomic,strong,readonly)TTTAttributedLabel *winLabel;//中奖金额
@property(nonatomic,strong,readonly)UIImageView* winImage ;//中奖图标
@property(nonatomic,strong,readonly)UILabel *startTimeLabel;//发起时间
@property(nonatomic,strong,readonly)UILabel *endTimeLabel;//截止时间
@property(nonatomic,strong,readonly)UILabel *peopleNameLabel;//发起人
@property(nonatomic,strong,readonly)UILabel *winInfoLabel;//中奖记录；
@property(nonatomic,strong,readonly)UIImageView *levelView;//等级视图


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier lottery:(int)gametype;
//标题
-(void)setLottertNameLabelText:(NSString *)gameName issue:(NSString *)issue;
-(void)setYongjinLabeText:(NSString *)money;
- (void)setLevelImageView:(NSString *)scores;

@end