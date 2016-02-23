//
//  DProjectDetailNumberCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-27.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
@interface DProjectDetailNumberCell : UITableViewCell

@property(nonatomic,strong,readonly)UILabel *titleLabel;
@property(nonatomic,strong,readonly)UILabel *infoLabel;
@property(nonatomic,strong)UIImageView *waveView;

-(void)changeWaveViewBottom:(float)bottomHeight;
@end
