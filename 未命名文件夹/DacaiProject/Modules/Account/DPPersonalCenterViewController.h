//
//  DPPersonalCenterViewController.h
//  DacaiProject
//
//  Created by WUFAN on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPPersonalCenterViewController : UIViewController

@property (nonatomic, strong, readonly) UITableView *tableView;

- (void)panDidDisappear;
- (void)panDidAppear;
- (void)recordTabReset;
- (void)recordTabResetForTag:(int)tabtag;//外界进入时

- (void)reloadHeader;

@end
