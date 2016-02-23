//
//  DPprojectDetailSprotContentCell.h
//  DacaiProject
//
//  Created by sxf on 14-9-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPDragView.h"
#import "DPImageLabel.h"
@class DPProjectDetailSProtSpfView;
@class DPProjectDetailSportBfView;
@class DPProjectDetailContentTitleView;
@class DPProjectDetailSProtDxfView;
@interface DPprojectDetailSprotContentCell : UITableViewCell
{

}
@property(nonatomic,assign)GameTypeId gameType;
@property(nonatomic,strong)NSArray *gameTypeArray;
@property(nonatomic,strong,readonly)  DPProjectDetailContentTitleView *titleInfoView;
@property(nonatomic,strong,readonly)DPProjectDetailSProtSpfView *spfView;
@property(nonatomic,strong,readonly)DPProjectDetailSProtSpfView *rqspfView;
@property(nonatomic,strong,readonly)DPProjectDetailSportBfView *bfView;
@property(nonatomic,strong,readonly)DPProjectDetailSportBfView *zjqView;
@property(nonatomic,strong,readonly)DPProjectDetailSportBfView *bqcView;
@property(nonatomic,strong,readonly) DPProjectDetailSportBfView  *sxdsView;
//篮彩
@property(nonatomic,strong,readonly)DPProjectDetailSProtDxfView *dxfView;
@property(nonatomic,strong,readonly)DPProjectDetailSProtDxfView *sfView;
@property(nonatomic,strong,readonly)DPProjectDetailSProtDxfView *rqsfView;
@property(nonatomic,strong,readonly) DPProjectDetailSportBfView  *sfcView;
@property(nonatomic,strong,readonly)UIView *bottomLineView;
-(void)changeBottomLineHeight:(int)height;
+ (CGFloat)heightWithLineCount:(NSUInteger)lineCount;
@end

//标题
@interface DPProjectDetailContentTitleView : UIView

@property(nonatomic,strong,readonly)UILabel *changLabel;
@property(nonatomic,strong,readonly)UILabel *homeNumberLabel,*awayNumberLabel;
@property(nonatomic,strong,readonly)UILabel *homeLabel,*awayLabel;
@property(nonatomic,strong,readonly)UIButton *danView;
@property(nonatomic,strong,readonly)UILabel *timeLabel;
@property(nonatomic,strong,readonly)UILabel *midVslabel;
@end

//胜平负，让球胜平负
@interface DPProjectDetailSProtSpfView : UIView
@property(nonatomic,strong,readonly)UILabel *titleLabel;
@property(nonatomic,strong,readonly)DPImageLabel *sLabel;
@property(nonatomic,strong,readonly)DPImageLabel *pLabel;
@property(nonatomic,strong,readonly)DPImageLabel *fLabel;
@property(nonatomic,strong,readonly)UILabel *resultLabel;
@end

//总进球，半全场，比分
@interface DPProjectDetailSportBfView : UIView

@property(nonatomic,strong,readonly)UILabel *titleLabel;
@property(nonatomic,strong,readonly)DPDragView *infoLabel;
@property(nonatomic,strong,readonly)UILabel *resultLabel;
@property(nonatomic,strong,readonly)TTTAttributedLabel *attLabel;
@end

//胜负，大小分，让分胜负
@interface DPProjectDetailSProtDxfView : UIView
@property(nonatomic,strong,readonly)UILabel *titleLabel;
@property(nonatomic,strong,readonly)DPImageLabel *sLabel;
@property(nonatomic,strong,readonly)DPImageLabel *fLabel;
@property(nonatomic,strong,readonly)UILabel *rqLabel;
@property(nonatomic,strong,readonly)UILabel *resultLabel;
@end