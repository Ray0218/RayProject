//
//  DPSdBuyCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-31.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPSdBuyCellDelegate;

@interface DPSdBuyCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *commentLabel;
@property (nonatomic, strong, readonly) NSArray *balls;
@property (nonatomic, strong, readonly) NSArray *misses;
@property (nonatomic, weak) id<DPSdBuyCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIView *footLine;
- (void)buildLayout;

@end

@protocol DPSdBuyCellDelegate <NSObject>
@required
- (void)buyCell:(DPSdBuyCell *)cell touchDown:(UIButton *)button;
- (void)buyCell:(DPSdBuyCell *)cell touchUp:(UIButton *)button;

@end