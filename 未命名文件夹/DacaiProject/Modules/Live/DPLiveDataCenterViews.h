//
//  DPLiveDataCenterViews.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDHTMLLabel/MDHTMLLabel.h>
#import "DPImageLabel.h"

#define labelTag 10000

extern NSString* g_homeName ;
extern NSString* g_awayName ;
extern NSInteger g_matchId ;
extern NSInteger g_oddsFirst ;
extern NSInteger g_oddsSecond ;
extern NSInteger g_oddsThird ;

@interface DPLiveOddsHeaderView : UIView
//@interface DPLiveOddsHeaderView : UILabel

@property(nonatomic,strong)UIFont* titleFont ;
@property(nonatomic,strong)UIColor* textColors ;
@property (nonatomic, strong)CALayer *bottmoLayer ;//底部线条
@property(nonatomic,assign)NSInteger numberOfLabLines ;


-(instancetype)initWithNoLayer ;
-(instancetype)initWithTopLayer:(BOOL)yesOrno withHigh:(CGFloat)height withWidth:(CGFloat)width;

/**
 *  改变行数 默认1行
 *
 *  @param index       label的位置
 *  @param  number 行数
 */

-(void)changeNumberOfLinesWithIndex:(NSInteger)index withNumber:(NSInteger)number ;
/**
 *  改变某行字体大小
 *
 *  @param index       label的位置
 *  @param font       文字大小

 */
-(void)changeFontWithIndex:(NSInteger)index withFont:(UIFont*)font ;
/**
 *  根据宽和高创建label
 *
 *  @param widthArray       各个label的宽度
 *  @param hight           各个label的高度
 *  @param yesOrNo           是否有分隔线

 */

-(void)createHeaderWithWidthArray:(NSArray*)widthArray whithHigh:(CGFloat)hight withSeg:(BOOL)yesOrNo;
/**
 *  根据宽和高创建label
 *
 *  @param widthArray       各个label的宽度
 *  @param hight           各个label的高度
 *  @param indexArray          分隔线位置 0不要右边分割线  1:要右边分割线
 
 */

-(void)createHeaderWithWidthArray:(NSArray*)widthArray whithHigh:(CGFloat)hight withSegIndexArray:(NSArray*)indexArray;

/**
 *  设置各个label的文字
 *
 *  @param titleArray       各个label文字
 
 */

//-(void)settitles:(NSArray*)titleArray ;
//-(void)setHtmtitles:(NSArray*)titleArray ;
-(void)setTitles:(NSArray*)titleArray;

/**
 *  设置各个label的文字颜色
 *
 *  @param colorsArray       各个label文字颜色
 
 */
-(void)changeAllTitleColor:(UIColor*)color ;
-(void)settitleColors:(NSArray*)colorsArray ;
-(void)setBgColors:(NSArray*)bgColorsArray ;


@end


//// 技术统计

@interface DPLiveCompetitionStateCell : UITableViewCell
@property (nonatomic, strong)DPLiveOddsHeaderView * cellView ;
@property (nonatomic, strong) UIView *homeBar;
@property (nonatomic, strong) UIView *awayBar;
@property (nonatomic, strong)CALayer *bottmoLayer ;//底部线条
-(instancetype)initWithItemWithArray:(NSArray*)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height;

@end


@interface DPLiveDataCenterSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *arrowView;
@property (nonatomic, strong, readonly)UIImageView *lineView ;

@end

@interface DPLiveAnalysisViewCell : UITableViewCell
@property (nonatomic, strong)DPLiveOddsHeaderView * rootbgView ;
- (instancetype)initWithWidthArray:(NSArray*)widArray reuseIdentifier:(NSString *)reuseIdentifier withHight:(CGFloat)height ;
@end



////详情页面
//@interface DPLiveOddsPositionDetailVC : UIViewController
//
//@end




@interface DPLiveNoDataCell : UITableViewCell

@property(nonatomic,strong)DPImageLabel* noDataImgView ;


@end



