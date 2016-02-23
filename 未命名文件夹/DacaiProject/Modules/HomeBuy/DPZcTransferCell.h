//
//  DPZcTransferCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DPZcTransferCellEvent) {
    DPZcTransferCellEventDelete,
    DPZcTransferCellEventMark,
    DPZcTransferCellEventOption,
};
@protocol DPZcTransferCellDelegate;
@interface DPZcTransferCell : UITableViewCell
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, weak) id<DPZcTransferCellDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *homeNameLabel;
@property (nonatomic, strong, readonly) UILabel *awayNameLabel;
@property (nonatomic, strong, readonly) UILabel *middleLabel;
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;
@property (nonatomic, strong, readonly) UIButton *markButton;
@property (nonatomic, strong, readonly) UILabel *contentLabel;

@property (nonatomic, strong, readonly) NSArray *betOption9;
@property (nonatomic, strong, readonly) NSArray *betOption14;

- (void)buildLayout;
@end
@protocol DPZcTransferCellDelegate <NSObject>
@optional
- (void)zcTransferCell:(DPZcTransferCell *)cell index:(NSInteger)index selected:(BOOL)selected;
- (void)zcTransferCell:(DPZcTransferCell *)cell mark:(BOOL)selected;
- (void)deleteZcTransferCell:(DPZcTransferCell *)cell;
@end
