//
//  DPDigitalBuyCell.h
//  DacaiProject
//
//  Created by sxf on 14-7-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel.h>
@protocol digitalBuyDelegate;
@interface DPDigitalBuyCell : UITableViewCell

@property(nonatomic,strong)TTTAttributedLabel *infoLabel;
@property(nonatomic,strong)UILabel *zhushuLabel;
@property(nonatomic,assign)id<digitalBuyDelegate>delegate;
@property(nonatomic,assign)UIView *allView;
@property(nonatomic,strong)UIView *dbackView;
-(void)changeCurrentViewHeight:(float)height;
@end


@interface DP3DDigitalBuyCell : DPDigitalBuyCell
@property (nonatomic,strong)UILabel *buyTypelabel;
@end

@interface DPQuick3DigitalBuyCell : DPDigitalBuyCell
@property (nonatomic,strong)UILabel *buyTypelabel;
@property(nonatomic,strong)UIImageView *backImageView;
-(void)upDateBuyLabelContstrant:(NSString *)title;
@end

@protocol digitalBuyDelegate <NSObject>
@optional

- (void)DPDigitalBuyDelegate:(DPDigitalBuyCell *)cell;

@end



