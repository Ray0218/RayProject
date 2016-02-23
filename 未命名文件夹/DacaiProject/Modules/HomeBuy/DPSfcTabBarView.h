//
//  DPSfcTabBarView.h
//  DacaiProject
//
//  Created by sxf on 14-8-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPScvTabBarViewDelegate;
@interface DPSfcTabBarView : UIView

@property (nonatomic, assign) NSInteger                               selectedIndex;
@property (nonatomic, assign) id<DPScvTabBarViewDelegate>   delegate;
@property(nonatomic,strong)UIButton *leftZcBtn;
@property(nonatomic,strong)UIButton *rightZcBtn;

-(void)selectedItemChangeTo:(NSInteger)selectedIndex  ;
-(void)changeCurrentData:(NSString*)strCur ;
-(void)changePreData:(NSString*)strCur ;



@end


@protocol DPScvTabBarViewDelegate <NSObject>
@required
- (void)tabBarView:(DPSfcTabBarView *)tabBarView selectedAtIndex:(NSInteger)index;


@end