//
//  DPDigitalBallCell.h
//  DacaiProject
//
//  Created by sxf on 14-7-2.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define yilouSpace  20
#define noYilouSpace 7
#define ballHeight   35
@protocol digitalBallDelegate;
@interface DPDigitalBallCell : UITableViewCell

@property(nonatomic,strong,readonly)UILabel *titleLabel;
@property(nonatomic,assign)NSInteger ballstotal;//球的总数
@property(nonatomic,assign)NSInteger ballsColor;//球的颜色
@property(nonatomic,assign)NSInteger selectedMaxTotal;
@property(nonatomic,assign)id<digitalBallDelegate>delegate;
@property(nonatomic,assign)NSInteger lotteryType;
@property(nonatomic,strong)UIView *ballView;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          balltotal:(NSInteger)balltotal
          ballColor:(NSInteger)ballColorIndex
       ballSelected:(NSInteger)selectedTotal
        lotteryType:(NSInteger)type;

//遗漏值
-(void)openOrCloseYilouZhi:(BOOL)isOpen;
//改变Top距离
-(void)oneRowTitleRect:(float)height;
//改变高度
-(void)oneRowTitleHeight:(float)height;
@end

@protocol digitalBallDelegate <NSObject>

////计算注数
//-(void)calculateBall:(DPDigitalBallCell*)cell;
//让当前tableview不能滑动
- (void)tableViewScroll:(BOOL)stop;
- (void)buyCell:(DPDigitalBallCell *)cell touchUp:(UIButton *)button;
@end