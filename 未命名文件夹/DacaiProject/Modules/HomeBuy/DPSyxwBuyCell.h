//
//  DPSyxwBuyCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-6.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DPSyxwBuyCellDelegate;
@interface DPSyxwBuyCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *commentLabel;
@property (nonatomic, strong, readonly) NSArray *balls;
@property (nonatomic, strong, readonly) NSArray *misses;
@property (nonatomic, strong, readonly) UIView *footLine;
@property (nonatomic, weak) id<DPSyxwBuyCellDelegate> delegate;

- (void)buildLayout;
@end


@protocol DPSyxwBuyCellDelegate <NSObject>
@required
- (void)buyCell:(DPSyxwBuyCell *)cell touchDown:(UIButton *)button;
- (void)buyCell:(DPSyxwBuyCell *)cell touchUp:(UIButton *)button;

@end