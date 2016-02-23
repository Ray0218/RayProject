//
//  DPBdBuyCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

typedef NS_ENUM(NSInteger, DPBdBuyCellEvent) {
    DPBdBuyCellEventMore,
    DPBdBuyCellEventOption,
};

@protocol DPBdBuyCellDelegate;
@interface DPBdBuyCell : UITableViewCell

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, weak) id<DPBdBuyCellDelegate> delegate;

@property (nonatomic, strong, readonly) UILabel *competitionLabel;
@property (nonatomic, strong, readonly) UILabel *orderNameLabel;
@property (nonatomic, strong, readonly) UILabel *matchDateLabel;    // start time or end time
@property (nonatomic, strong, readonly) UIImageView *analysisView;

@property (nonatomic, strong, readonly) UILabel *homeNameLabel;
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;
@property (nonatomic, strong, readonly) UILabel *homeRankLabel;
@property (nonatomic, strong, readonly) UILabel *awayRankLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;

@property (nonatomic, strong, readonly) UILabel *optionLabel;

@property (nonatomic, strong, readonly) NSArray *optionButtonRqspf;
@property (nonatomic, strong, readonly) NSArray *optionButtonSxds;
@property (nonatomic, strong, readonly) NSArray *optionButtonZjq;

- (void)buildLayout;
-(void)analysisViewIsExpand:(BOOL)isExpand;
@end

@protocol DPBdBuyCellDelegate <NSObject>
@required
- (void)bdBuyCell:(DPBdBuyCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected;
- (void)bdBuyCellInfo:(DPBdBuyCell *)cell;
- (void)moreBdBuyCell:(DPBdBuyCell *)cell;
@end
