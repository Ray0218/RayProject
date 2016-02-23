//
//  DPBdTransferCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPBdTransferCellDelegate;

@interface DPBdTransferCell : UITableViewCell

@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, weak) id<DPBdTransferCellDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;
@property (nonatomic, strong, readonly) UIButton *markButton;
@property (nonatomic, strong, readonly) UILabel *contentLabel;

@property (nonatomic, strong, readonly) NSArray *betOptionSpf;
@property (nonatomic, strong, readonly) NSArray *betOptionSdxs;

- (void)buildLayout;

@end

@protocol DPBdTransferCellDelegate <NSObject>
@required
- (void)bdTransferCell:(DPBdTransferCell *)cell index:(NSInteger)index selected:(BOOL)selected;
- (void)bdTransferCell:(DPBdTransferCell *)cell mark:(BOOL)selected;
- (BOOL)shouldMarkBdTransferCell:(DPBdTransferCell *)cell;
- (void)deleteBdTransferCell:(DPBdTransferCell *)cell;
@end
