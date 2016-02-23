//
//  DPPksHistoryTrendCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPPksHistoryTrendCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *infoLabel;
@property (nonatomic, strong, readonly) UILabel *waitLabel;


@property (nonatomic, strong, readonly) UILabel *pokerLabel1;
@property (nonatomic, strong, readonly) UILabel *pokerLabel2;
@property (nonatomic, strong, readonly) UILabel *pokerLabel3;

- (void)buildLayout;

@end
