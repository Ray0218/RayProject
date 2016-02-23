//
//  DPProjectDetailWInNumberCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DProjectDetailNumberResultView.h"
@interface DPProjectDetailWInNumberCell : UITableViewCell

@property(nonatomic,assign)int gameType;
@property(nonatomic,strong)UILabel *bonusInfo;
@property(nonatomic,strong)DProjectDetailNumberResultView *resultView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  lotteryType:(int)lotteryType;
@end
