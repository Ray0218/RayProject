//
//  DPResultListViews.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark
@interface DPNumberResultListCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *gameNameLabel;
@property (nonatomic, strong, readonly) UILabel *drawTimeLabel;
@property (nonatomic, strong, readonly) NSArray *drawItems;
@property (nonatomic, strong, readonly) UILabel *preResultLabel;    // 3D试机号
@property (nonatomic, strong, readonly) UIImageView *arrowView;

- (void)layoutWithType:(GameTypeId)gameType prettyStyle:(BOOL)prettyStyle;
//- (void)hideBottomLine:(BOOL)hide;
@end

#pragma mark
@class TTTAttributedLabel;
@interface DPSportsResultListCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *competitionLabel;
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;
@property (nonatomic, strong, readonly) UILabel *startTimeLabel;
@property (nonatomic, strong, readonly) UILabel *resultLabel;
@property (nonatomic, strong, readonly) UILabel *scoreLabel;
@property (nonatomic, strong, readonly) UIView *resultView;
@property (nonatomic, strong, readonly) TTTAttributedLabel *homeLabel;
@property (nonatomic, strong, readonly) UILabel *awayLabel;

- (void)buildLayout:(BOOL)exchangeTeam;

@end

#pragma mark
@protocol DPResultGameNameViewDelegate;
@interface DPResultGameNameView : UIView
@property (nonatomic, weak) id<DPResultGameNameViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@protocol DPResultGameNameViewDelegate <NSObject>
@required
- (NSString *)view:(DPResultGameNameView *)view titleAtIndex:(NSInteger)index;
- (NSInteger)gameCountForView:(DPResultGameNameView *)view;
@optional
- (void)view:(DPResultGameNameView *)view didSelectedAtIndex:(NSInteger)index;
@end

#pragma mark
@interface DPResultInfoGirdView : UIView

@property (nonatomic, assign, readonly) NSInteger row;
@property (nonatomic, assign, readonly) NSInteger column;

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column;
- (void)setColors:(NSArray *)colors;
- (void)setTitle:(NSString *)title forRow:(NSInteger)row column:(NSInteger)column;

@end

#pragma mark
@interface DPNumberResultInfoCell : UITableViewCell
@property (nonatomic, assign) GameTypeId gameType;
@property (nonatomic, strong, readonly) NSArray *titleList;
@property (nonatomic, strong, readonly) NSArray *detailList;
- (void)buildLayout:(void(^)(DPNumberResultInfoCell *cell))block;
@end
