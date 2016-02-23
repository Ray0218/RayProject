//
//  DPPksBuyCell.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-14.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPPksBuyCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *pokerView;
@property (nonatomic, strong, readonly) UIImageView *circleView;
@property (nonatomic, strong, readonly) UIImageView *chipView;
@property (nonatomic, strong, readonly) UILabel *missLabel;

- (void)buildLayout;

@end

@interface DPPksBuyHeaderReusableView : UICollectionReusableView

@property (nonatomic, strong, readonly) UILabel *bonusLabel;
@property (nonatomic, strong, readonly) UIButton *shakeButton;

- (void)buildLayout;

@end

@interface DPPksBuyDrawView : UIImageView

@property (nonatomic, strong) NSString *text;

- (void)setType:(NSInteger)type;    // 1: 方块 2:红桃 3:梅花 4:黑桃 5:?(未开奖状态)

@end