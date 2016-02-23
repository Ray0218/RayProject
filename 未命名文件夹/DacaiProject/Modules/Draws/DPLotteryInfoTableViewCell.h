//
//  DPLotteryInfoTableViewCell.h
//  DacaiProject
//
//  Created by jacknathan on 14-9-19.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kInfoTableViewCellTitleFont 14
#define kInfoTabelViewCellHeightDelta 41
@interface DPLotteryInfoTableViewCell : UITableViewCell

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subTitle;
@property (nonatomic, copy)NSString *urlString;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)GameTypeId gameType;
@property (nonatomic, assign)BOOL showSel;

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle urlString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath;
@end
