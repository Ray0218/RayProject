//
//  DPHistoryTendencyCell.h
//  DacaiProject
//
//  Created by sxf on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>

@interface DPHistoryTendencyCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *gameNameLab;
@property (nonatomic, strong, readonly) UIImageView *ballView;
@property (nonatomic, strong, readonly) TTTAttributedLabel *gameInfoLab;
@property(nonatomic,assign)NSInteger lotteryType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  digitalType:(int)digitalType;
@end


@interface DPQuick3HistoryCell : UITableViewCell

@property(nonatomic,strong)UILabel *issueLabel;
@property(nonatomic,strong)UIImageView *dic1,*dic2,*dic3;
@property(nonatomic,strong)UILabel *infoLabel;
@property (nonatomic, strong, readonly) UIImageView *ballView;
@property(nonatomic,strong,readonly)UILabel *bonuslabel;
@end