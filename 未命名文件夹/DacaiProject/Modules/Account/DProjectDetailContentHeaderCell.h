//
//  DProjectDetailContentHeaderCell.h
//  DacaiProject
//
//  Created by sxf on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DProjectDetailContentHeaderCellDelegate;
@interface DProjectDetailContentHeaderCell : UITableViewCell

@property (nonatomic, assign) BOOL expand;
@property(nonatomic,assign)id<DProjectDetailContentHeaderCellDelegate>delegate;
- (void)setAccessText:(NSString *)accessText notesText:(NSString *)notesText;
@end

@interface DProjectDetailContentInvisibleCell : UITableViewCell

@end

@protocol DProjectDetailContentHeaderCellDelegate <NSObject>

- (void)tapContentHeaderCell:(DProjectDetailContentHeaderCell *)cell;

@end