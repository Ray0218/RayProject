//
//  DPSettingCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-30.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPSettingCell : UITableViewCell

@property(nonatomic,strong,readonly)UIImageView *titleImageView;
@property(nonatomic,strong,readonly)UILabel *titleLabel;
-(void)createRightImageView:(int)imageViewType;
@end
