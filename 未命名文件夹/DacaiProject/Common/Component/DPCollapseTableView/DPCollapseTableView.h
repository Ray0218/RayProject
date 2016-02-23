//
//  DPCollapseTableView.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  可展开的 table view
//

#import <UIKit/UIKit.h>

@protocol DPCollapseTableViewDelegate;
@protocol DPCollapseTableViewDataSource;

typedef NS_ENUM(NSInteger, DPTableViewZOrder) {   // z轴序
    DPTableViewZOrderNone,
    DPTableViewZOrderAsec,
    DPTableViewZOrderDsec,
};

@interface DPCollapseTableView : UITableView

@property (nonatomic, assign) BOOL expandMutual;

@property (nonatomic, strong, readonly) NSArray *expandModelIndexs;
@property (nonatomic, strong, readonly) NSArray *expandTableIndexs;
@property (nonatomic, assign) DPTableViewZOrder zOrder;

- (NSIndexPath *)modelIndexForCell:(UITableViewCell *)cell;
- (NSIndexPath *)modelIndexForCell:(UITableViewCell *)cell expand:(out BOOL *)expand;
- (id)cellForRowAtModelIndex:(NSIndexPath *)modelIndex expand:(in BOOL)expand;

- (void)openCellAtModelIndex:(NSIndexPath *)indexPath;
- (void)closeCellAtModelIndex:(NSIndexPath *)indexPath;
- (void)reloadCellAtModelIndex:(NSIndexPath *)indexPath;
- (void)toggleCellAtModelIndex:(NSIndexPath *)indexPath;

- (void)openCellAtModelIndex:(NSIndexPath *)indexPath animation:(BOOL)animation;
- (void)closeCellAtModelIndex:(NSIndexPath *)indexPath animation:(BOOL)animation;
- (void)reloadCellAtModelIndex:(NSIndexPath *)indexPath animation:(BOOL)animation;
- (void)toggleCellAtModelIndex:(NSIndexPath *)indexPath animation:(BOOL)animation;

- (NSIndexPath *)tableIndexFromModelIndex:(NSIndexPath *)modelIndex expand:(in BOOL)expand;
- (NSIndexPath *)modelIndexFromTableIndex:(NSIndexPath *)tableIndex expand:(out BOOL *)expand;

- (BOOL)isExpandAtModelIndex:(NSIndexPath *)modelIndex;
- (BOOL)isExpandAtTableIndex:(NSIndexPath *)tableIndex;

- (void)closeAllCells;

@end

@protocol DPCollapseTableViewDelegate <NSObject, UITableViewDelegate>
@optional
- (CGFloat)tableView:(DPCollapseTableView *)tableView expandHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol DPCollapseTableViewDataSource <NSObject, UITableViewDataSource>
@required
- (UITableViewCell *)tableView:(DPCollapseTableView *)tableView expandCellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
