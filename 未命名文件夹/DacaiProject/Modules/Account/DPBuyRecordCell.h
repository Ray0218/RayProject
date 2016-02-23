//
//  DPBuyRecordCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-12.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@interface DPBuyRecordCell : UITableViewCell
@property (nonatomic, strong, readonly) UIView              *colorLine;         // 彩色线
@property (nonatomic, strong, readonly) UIImageView         *clockView;         // 闹钟图标
@property (nonatomic, strong, readonly) UILabel             *monthLabel;        // 月
@property (nonatomic, strong, readonly) UILabel             *dayLabel;          // 日
@property (nonatomic, strong, readonly) UILabel             *timeLabel;         // 时间
@property (nonatomic, strong, readonly) UILabel             *buyTypeLabel;      // 购买类型
@property (nonatomic, strong, readonly) UIImageView         *sealView;          // 中奖印章
@property (nonatomic, strong, readonly) TTTAttributedLabel  *attrTitleLabel;    // 标题(彩种+其他)
@property (nonatomic, strong, readonly) TTTAttributedLabel  *attrAmtLabel;      // 总金额
@property (nonatomic, strong, readonly) TTTAttributedLabel  *attrStatusLabel;   // 状态
@property (nonatomic, strong, readonly) TTTAttributedLabel  *attrScheduleLabel; // 进度
@property (nonatomic, strong, readonly) UILabel             *guaranteedLabel;   // 保底

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, assign) NSInteger buyType;
@property (nonatomic, assign) NSInteger purchaseOrderId;

- (void)buildLayout;

@end
