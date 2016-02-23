//
//  DPLiveOddsPositionDetailVC.h
//  DacaiProject
//
//  Created by Ray on 14/12/16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPLiveOddsPositionDetailVC : UIViewController
//@property(strong,nonatomic)NSIndexPath* defaultIndexPath ;//默认选择行
- (instancetype)initWIthGameType:(GameTypeId)gameType withSelectIndex:(NSInteger)index companyIndx:(NSInteger)companyIndx withMatchId:(NSInteger)matchid;


@end


//详情页面左侧tableViewCell
@interface OddsPositionDetailCell : UITableViewCell

@property(nonatomic,strong)UILabel* nameLabel ;

@end
