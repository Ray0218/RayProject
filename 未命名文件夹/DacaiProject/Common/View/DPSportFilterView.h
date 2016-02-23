//
//  DPSportFilterView.h
//  DacaiProject
//
//  Created by sxf on 14-7-18.
//  Copyright (c) 2014年 dacai. All rights reserved.
//
//
//  删选界面
//

#import <UIKit/UIKit.h>

@protocol  DPSportFilterViewDelegate;
@interface DPSportFilterView : UIView

@property (nonatomic, assign) id<DPSportFilterViewDelegate> delegate;
@property (nonatomic, assign, readonly) CGSize contentSize;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (void)addGroupWithTitle:(NSString *)title allItems:(NSArray *)allItems selectedItems:(NSArray *)selectedItems;

@end

@protocol DPSportFilterViewDelegate <NSObject>
@optional
- (void)cancelFilterView:(DPSportFilterView *)filterView;
/**
 *  确定筛选条件
 *
 *  @param filterView     [in]触发事件的view
 *  @param allGroups      [in]所有条件的二维数据 e.g. @[@[@"主让2球", @"主让1球", @"不让球", @"客让2球"], @[@"德国杯", @"瑞士甲", @"英超", @"荷乙"]]
 *  @param selectedGroups [in]选中条件的二维数据 e.g. @[@[@"主让2球", @"不让球"], @[@"德国杯", @"瑞士甲"]]
 */
- (void)filterView:(DPSportFilterView *)filterView allGroups:(NSArray *)allGroups selectedGroups:(NSArray *)selectedGroups;
@end