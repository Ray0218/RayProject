//
//  DProjectDetailOptimizeHeaderCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DProjectDetailOptimizeHeaderCellDelegate;
@interface DProjectDetailOptimizeHeaderCell : UITableViewCell

@property (nonatomic, assign) id<DProjectDetailOptimizeHeaderCellDelegate> delegate;
@property (nonatomic, assign) BOOL expand;
@end

@protocol DProjectDetailOptimizeHeaderCellDelegate <NSObject>

- (void)tapOptimizeHeaderCell:(DProjectDetailOptimizeHeaderCell *)cell;

@end


@interface DProjectDetailOptimizeTitleCell : UITableViewCell

@end

@interface DProjectDetailOptimizeListCell : UITableViewCell
//+ (CGFloat)heightWithLineCount:(NSUInteger)count;
@property(nonatomic,strong)UILabel *infoLabel,*zhushuLabel,*bonusLabel;
@end