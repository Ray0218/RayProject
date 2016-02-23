//
//  DPPassModeView.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPPassModeViewDelegate;

@interface DPPassModeView : UICollectionView

@property (nonatomic, weak) id<DPPassModeViewDelegate> passModeDelegate;
@property (nonatomic, strong) NSArray *freedoms;
@property (nonatomic, strong) NSArray *combines;

@end

@protocol DPPassModeViewDelegate <NSObject>
@required
- (void)passModeView:(DPPassModeView *)passModeView expand:(BOOL)expand;
- (void)passModeView:(DPPassModeView *)passModeView toggle:(NSInteger)passModeTag;
- (BOOL)passModeView:(DPPassModeView *)passModeView isSelectedModel:(NSInteger)passModeTag;
@end