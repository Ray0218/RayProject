//
//  DProjectDetailMyOrderHeaderCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-25.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import "DPImageLabel.h"
@protocol DProjectDetailMyOrderHeaderCellDelegate;
@interface DProjectDetailMyOrderHeaderCell : UITableViewCell

@property(nonatomic,assign)id<DProjectDetailMyOrderHeaderCellDelegate>delegate;
@property (nonatomic, assign) BOOL expand;
- (void)setBuyAmount:(NSString *)buyAmount bonus:(NSString *)bonus;
@end

@interface DProjectDetailMyOrderTitleCell : UITableViewCell

@end

@interface DProjectDetailMyOrderInfoCell : UITableViewCell
@property (nonatomic, strong,readonly) UILabel         * timeLabel;
@property (nonatomic, strong,readonly) DPImageLabel    * rengouLabel;
@property (nonatomic, strong,readonly) TTTAttributedLabel         * bonusLabel;

//奖金
-(void)setBonusLabelTitle:(NSString *)string;
-(void)createLine;
@end

@protocol DProjectDetailMyOrderHeaderCellDelegate <NSObject>

- (void)tapOrderHeaderCell:(DProjectDetailMyOrderHeaderCell *)cell;

@end