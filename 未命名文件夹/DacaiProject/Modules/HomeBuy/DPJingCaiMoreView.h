//
//  DPJingCaiMoreView.h
//  DacaiProject
//
//  Created by sxf on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPJingCaiMoreDelegate;
@interface DPJingCaiMoreView : UIView<UIScrollViewDelegate>
{
    UIImageView *_rqDanView,*_spfDanView,*_bfDanView,*_zjqDanView,*_bqcDanView;
    UIImageView *_hotView;

}
@property(nonatomic,strong)UIView *winView;//胜平负
@property(nonatomic,strong,readonly)UIView *rqWinView;//让球胜平负
@property(nonatomic,strong,readonly)UIView *scoreView;//比分
@property(nonatomic,strong,readonly)UIView *totalBallView;//总进球
@property(nonatomic,strong,readonly)UIView *halfView;//班全程
@property(nonatomic,strong,readonly)UIView *singlehalfView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) int *sp1;//让球胜平负
@property (nonatomic, assign) int *sp2;//比分
@property (nonatomic, assign) int *sp3;//总进球
@property (nonatomic, assign) int *sp4;//半全场
@property (nonatomic, assign) int *sp5;//胜平负
@property (nonatomic, assign) int *isVisible;//是否可见
@property (nonatomic, assign) int *isSel1;//选中状态
@property (nonatomic, assign) int *isSel2;
@property (nonatomic, assign) int *isSel3;
@property (nonatomic, assign) int *isSel4;
@property (nonatomic, assign) int *isSel5;
@property (nonatomic,strong)  UIScrollView *scroView;
@property (nonatomic,assign) GameTypeId gameType;//彩种类型
@property(nonatomic,assign)id<DPJingCaiMoreDelegate>delegate;
@property(nonatomic,strong)NSString *homeTeamName,*awayTeamName;//主队，客队
@property(nonatomic,assign)int rqs;//让球数
@property(nonatomic,strong,readonly)UIImageView *rqDanView;//让球单关
@property(nonatomic,strong,readonly)UIImageView *spfDanView;//胜平负单关
@property(nonatomic,strong,readonly)UIImageView *bfDanView;//比分单关
@property(nonatomic,strong,readonly)UIImageView *zjqDanView;//总进球单关
@property(nonatomic,strong,readonly)UIImageView *bqcDanView;//半全场单关
@property (nonatomic, strong, readonly) UIImageView *hotView;//热门赛事

-(void)layOutAllSelectedView;//选择视图布局
@end

@protocol DPJingCaiMoreDelegate <NSObject>

-(void)jingCaiMoreSureSelected:(DPJingCaiMoreView *)jingCaiView  indexPath:(NSIndexPath *)indexPath;
-(void)jingCaiMoreCancel:(DPJingCaiMoreView *)jingCaiView;
@end
