//
//  DPTogetherBuyViews.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPImageLabel;
@interface DPTogetherBuyCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *gameTypeLabel;
@property (nonatomic, strong, readonly) UILabel *subscriptionLabel;
@property (nonatomic, strong, readonly) DPImageLabel *guaranteeLabel;

@property (nonatomic, strong, readonly) UILabel *userNameLabel;
@property (nonatomic, strong, readonly) UILabel *amountLabel;
@property (nonatomic, strong, readonly) UILabel *surplusLabel;
@property (nonatomic, strong, readonly) UILabel *turnoutLabel;
@property (nonatomic, strong, readonly) UIImageView *arrowView;
@property (nonatomic, strong)NSArray            *dengjiArray;
@end

@protocol DPTogetherBuyAppendCellDelegate;
@interface DPTogetherBuyAppendCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *amountField;
@property (nonatomic, weak) id<DPTogetherBuyAppendCellDelegate> delegate;

@end

@protocol DPTogetherBuyAppendCellDelegate <NSObject>
@optional
- (void)buyoutTogetherBuyAppendCell:(DPTogetherBuyAppendCell *)cell;
- (void)payTogetherBuyAppendCell:(DPTogetherBuyAppendCell *)cell;
@end