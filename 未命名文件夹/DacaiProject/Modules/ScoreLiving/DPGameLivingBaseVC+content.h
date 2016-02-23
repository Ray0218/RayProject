//
//  DPGameLivingBaseVC+content.h
//  DacaiProject
//
//  Created by sxf on 14/12/10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPGameLivingBaseVC.h"
@interface DPGameLivingBaseVC (content)

- (void)reloadFootballCellStatus:(DPGameLiveJczqCell *)cell tab:(NSInteger)tab index:(NSInteger)index;

- (UITableViewCell *)tableView:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView contentExpandCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
