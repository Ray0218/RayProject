//
//  DPLotteryInfoRandomChipView.h
//  DPLotteryInfoRandomChipView
//
//  Created by jacknathan on 14-9-22.
//  Copyright (c) 2014年 jacknathan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KRandomChipViewTypeDefault,
    KRandomChipViewTypeSsq,
    KRandomChipViewTypeDlt
} KRandomChipViewType;

@interface DPLotteryInfoRandomChipView : UIView

@property (nonatomic, assign)KRandomChipViewType viewType;
- (NSArray *)randomNumberWithMax:(int)max count:(int)count;

- (id)initWithViewType:(KRandomChipViewType)viewType;
@end
