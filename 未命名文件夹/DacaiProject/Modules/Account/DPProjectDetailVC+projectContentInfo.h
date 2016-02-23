//
//  DPProjectDetailVC+projectContentInfo.h
//  DacaiProject
//
//  Created by sxf on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailVC.h"

@interface DPProjectDetailVC (projectContentInfo)

-(float)digitalLotteryHeightAtRow:(int)row;
- (UITableViewCell *)tableView:(UITableView *)tableView numberContentCellForRowAtIndexPath:(NSIndexPath *)indexPath;
////足彩
//- (UITableViewCell *)tableView:(UITableView *)tableView ZCContentCellForRowAtIndexPath:(NSIndexPath *)indexPath;
//
- (CGFloat)numberCellHeightAtRow:(NSUInteger)row;

@end
