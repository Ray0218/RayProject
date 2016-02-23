//
//  DPDigitalHistoryView.h
//  DacaiProject
//
//  Created by sxf on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPDigitalTicketsBaseVC;
@interface DPDigitalHistoryView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *historyTableView;
@end
