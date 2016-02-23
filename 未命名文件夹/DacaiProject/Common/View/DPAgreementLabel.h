//
//  DPAgreementLabel.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-20.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPAgreementLabel : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

+ (DPAgreementLabel *)purchaseLabelWithTarget:(id)target action:(SEL)action;

- (void)setTarget:(id)target action:(SEL)action;

@end
