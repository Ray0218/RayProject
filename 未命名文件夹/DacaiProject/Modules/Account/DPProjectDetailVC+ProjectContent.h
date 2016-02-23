//
//  DPProjectDetailVC+ProjectContent.h
//  DacaiProject
//
//  Created by sxf on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPProjectDetailVC.h"

@interface DPProjectDetailVC (ProjectContent)

- (NSUInteger)numberOfProjectContent;
- (CGFloat)cellHeightAtRow:(NSUInteger)row;
- (UITableViewCell *)tableView:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
