//
//  SettingView.h
//  HorizonLight
//
//  Created by lanou on 15/9/19.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView

//我的收藏
@property (nonatomic, strong) UIButton *myCollectBtn;
//我的缓存
@property (nonatomic, strong) UIButton *myCacheBtn;
//功能开关
@property (nonatomic, strong) UIButton *functionSwichBtn;
//我要投稿
@property (nonatomic, strong) UIButton *contributeBtn;
//意见反馈
@property (nonatomic, strong) UIButton *feedbackBtn;
//版本信息
@property (nonatomic, strong) UILabel *version;
//出品
@property (nonatomic, strong) UILabel *maker;

@end
