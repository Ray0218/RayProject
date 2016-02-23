//
//  DPRedPacketView.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-23.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDHTMLLabel.h>

@interface DPRedPacketView : UIView

@property (nonatomic, strong, readonly) MDHTMLLabel *surplusLabel;
@property (nonatomic, strong, readonly) UILabel *limitLabel;
@property (nonatomic, strong, readonly) UILabel *validityLabel;
@property (nonatomic, strong, readonly) UILabel *signLabel;
@property (nonatomic, strong, readonly) UILabel *nameLabel;

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger currentAmt;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@end