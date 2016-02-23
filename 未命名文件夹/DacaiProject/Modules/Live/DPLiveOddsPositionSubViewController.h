//
//  DPLiveOddsPositionSubViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLiveDataCenterViews.h"
@interface DPLiveOddsPositionSubViewController : UITableViewController


@end


@interface DPLiveOddsPositionSubCell : UITableViewCell

@property(nonatomic,strong)DPImageLabel* noDataImgLabel ;

@property(nonatomic,strong)DPLiveOddsHeaderView *itemView ;
-(instancetype)initWithWidArray:(NSArray*)widArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height ;

@end


