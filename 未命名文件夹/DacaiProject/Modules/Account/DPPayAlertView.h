//
//  DPPayAlertView.h
//  DacaiProject
//
//  Created by sxf on 14/11/21.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPPayAlertViewDelegate;
@interface DPPayAlertView : UIView
{
UILabel *_payMoneyLabel,*_backMoneyLabel;
}
@property(nonatomic,assign)id<DPPayAlertViewDelegate>delegate;
@property(nonatomic,strong,readonly)UILabel *payMoneyLabel,*backMoneyLabel;
-(void)buildLayoutForEgLabelText:(NSString *)eglabelText;

@end


@protocol DPPayAlertViewDelegate <NSObject>

-(void)payAlertViewCancle:(DPPayAlertView *)payAlertView;
-(void)payAlertViewSure:(DPPayAlertView *)payAlertView;
@end