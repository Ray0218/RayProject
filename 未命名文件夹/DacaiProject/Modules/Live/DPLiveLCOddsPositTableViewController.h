//
//  DPLiveLCOddsPositTableViewController.h
//  DacaiProject
//
//  Created by Ray on 14/12/8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLiveDataCenterViews.h"


@interface DPLiveLCOddsPositTableViewController : UITableViewController

@end

@interface DPLiveOddsPositionCell : UITableViewCell
@property (nonatomic, strong)DPLiveOddsHeaderView * cellView ;
@property(nonatomic,strong)DPImageLabel* noDataImgLabel ;

-(instancetype)initWithItemWithArray:(NSArray*)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height;


@end
