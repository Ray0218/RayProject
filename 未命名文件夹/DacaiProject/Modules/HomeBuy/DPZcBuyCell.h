//
//  DPZcBuyCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DPzcBuyCellDelegate;
@interface DPZcBuyCell : UITableViewCell


@property (nonatomic, weak) id<DPzcBuyCellDelegate> delegate;
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong, readonly) UILabel *competitionLabel;
@property (nonatomic, strong, readonly) UILabel *orderNameLabel;
@property (nonatomic, strong, readonly) UILabel *matchDateLabel;    // start time or end time
@property (nonatomic, strong, readonly) UIImageView *analysisView;

@property (nonatomic, strong, readonly) UILabel *homeNameLabel;
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;
@property (nonatomic, strong, readonly) UILabel *homeRankLabel;
@property (nonatomic, strong, readonly) UILabel *awayRankLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;

//@property (nonatomic, strong, readonly) UILabel *optionLabel;

@property (nonatomic, strong, readonly) NSArray *optionButtonSpf;

- (void)buildLayout;
-(void)analysisViewIsExpand:(BOOL)isExpand;
@end

@protocol DPzcBuyCellDelegate <NSObject>
@required
- (void)zcBuyCell:(DPZcBuyCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected;
- (void)zcBuyCellInfo:(DPZcBuyCell *)cell;
//- (void)bdBuyCell:(DPBdBuyCell *)cell event:(DPBdBuyCellEvent)event info:(NSDictionary *)info;
@end