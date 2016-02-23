//
//  DPJczqTransferCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPJczqTransferCellDelegate;

@interface DPJczqTransferCell : UITableViewCell

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, weak) id<DPJczqTransferCellDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;
@property (nonatomic, strong, readonly) UIButton *markButton;
@property (nonatomic, strong, readonly) UILabel *contentLabel;

@property (nonatomic, strong, readonly) NSArray *betOptionSpf;

- (void)buildLayout;

@end

@protocol DPJczqTransferCellDelegate <NSObject>
@required
- (void)jczqTransferCell:(DPJczqTransferCell *)cell gameType:(GameTypeId)gameType index:(NSInteger)index selected:(BOOL)selected;
- (void)jczqTransferCell:(DPJczqTransferCell *)cell mark:(BOOL)selected;
- (BOOL)shouldMarkJczqTransferCell:(DPJczqTransferCell *)cell;
- (void)deleteJczqTransferCell:(DPJczqTransferCell *)cell;
@end