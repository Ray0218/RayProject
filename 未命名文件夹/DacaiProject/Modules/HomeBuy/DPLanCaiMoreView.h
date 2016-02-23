//
//  DPLanCaiMoreView.h
//  DacaiProject
//
//  Created by sxf on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DPJclqMoreDelegate;
@interface DPLanCaiMoreView : UIView


@property(nonatomic,strong)UIView *rfView;
@property(nonatomic,strong,readonly)UIView *dxfView;
@property(nonatomic,strong,readonly)UIView *sfView;
@property(nonatomic,strong,readonly)UIView *sfcView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) int *sprf;//让分
@property (nonatomic, assign) int *spdxf;//大小分
@property (nonatomic, assign) int *spsf;//胜负
@property (nonatomic, assign) int *spsfc;//胜分差

@property (nonatomic, assign) int *isVisible;//是否可见

@property(nonatomic,assign)   int *rfSelect;
@property(nonatomic,assign)   int *dxfSelect;
@property(nonatomic,assign)   int *sfSelect;
@property(nonatomic,assign)   int *sfcSelect;
@property (nonatomic,strong)  UIScrollView *scroView;
@property (nonatomic,assign) GameTypeId gameType;
@property(nonatomic,assign)id<DPJclqMoreDelegate>delegate;
@property(nonatomic,strong)NSString *homeTeamName,*awayTeamName;
@property(nonatomic,assign)int rfIndex,dxfIndex;
@property(nonatomic,strong)UILabel *rangfenLabel,*dxfLabel;
-(void)layOutAllSelectedView;//选择视图布局
@end

@protocol DPJclqMoreDelegate <NSObject>

-(void)jingCaiMoreSureSelected:(DPLanCaiMoreView *)jingCaiView  indexPath:(NSIndexPath *)indexPath;
-(void)jingCaiMoreCancel:(DPLanCaiMoreView *)jingCaiView;
@end
