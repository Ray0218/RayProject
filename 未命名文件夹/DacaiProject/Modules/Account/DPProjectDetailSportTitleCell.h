//
//  DPProjectDetailSportTitleCell.h
//  DacaiProject
//
//  Created by sxf on 14-9-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPProjectDetailSportTitleCell : UITableViewCell

@property(nonatomic,strong)UILabel *passModeLabel;
+ (CGFloat)heightWithPassMode:(NSString *)passMode;
- (void)setPassMode:(NSString *)passMode;
@end
