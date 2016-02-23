//
//  DPJcLqTransferCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-5.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DPJclqTransferCellEvent) {
    DPJclqTransferCellEventDelete,
    DPJclqTransferCellEventMark,
    DPJclqTransferCellEventOption,
};
@protocol DPJcLqTransferCellDelegate;
@interface DPJcLqTransferCell : UITableViewCell
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, weak) id<DPJcLqTransferCellDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;
@property (nonatomic, strong, readonly) UIButton *markButton;
@property (nonatomic, strong, readonly) UILabel *contentLabel;
@property(nonatomic,strong)UIButton *jclqtleftBtn,*jclqtRightBtn;
- (void)buildLayout;
- (void)loadDragView;
- (void)loadRfDragView;

@end
@protocol DPJcLqTransferCellDelegate <NSObject>
@required
- (void)jclqTransferCell:(DPJcLqTransferCell *)cell event:(DPJclqTransferCellEvent)event;
- (BOOL)shouldMarkJclqTransferCell:(DPJcLqTransferCell *)cell;
-(void)jclqTranCell:(DPJcLqTransferCell *)cell  selectedIndex:(int)selectedIndex isSelected:(int)isSelected;
@end