//
//  DPSetPushCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-30.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SevenSwitch/SevenSwitch.h>
@protocol DPSetPushCellDelegate;
@interface DPSetPushCell : UITableViewCell

@property(nonatomic,strong,readonly)UIImageView *titleImageView;
@property(nonatomic,strong,readonly)UILabel *topTitleLabel,*bottomTitleLabel;
@property(nonatomic,strong,readonly)SevenSwitch *sevSwitch;
@property(nonatomic,assign)id<DPSetPushCellDelegate>delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  indexPath:(NSIndexPath *)indexpath;
@end

@protocol DPSetPushCellDelegate <NSObject>

-(void)pushViewSwitchClick:(DPSetPushCell *)cell;
@end
