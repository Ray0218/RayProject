//
//  DPNodataView.h
//  DacaiProject
//
//  Created by Ray on 14/12/26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPImageLabel.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>


typedef  void(^updateBlock)(BOOL setOrUpDate);

typedef NS_ENUM(NSInteger, DPNoDataState) {
    DPNoDataNoworkNet,//无网络
    DPNoDataWorkNetFail , //网络出错
    DPNoData, //没数据
};

@interface DPNodataView : UIView

@property(nonatomic,copy)updateBlock clickBlock ;
@property(nonatomic,assign)GameTypeId gameType ;

@property(assign,nonatomic)DPNoDataState noDataState ;

@end

#define kNoWorkNet @"当前网络不可用，马上设置"
#define kWorkNetFail @"网络加载失败，点击重试"
#define kNoData @"暂无数据，点击重试"

#define kNoWorkNet_ @"当前网络不可用"
#define kWorkNetFail_ @"网络加载失败"

#define kAttributStr(strName) ({NSMutableAttributedString *atrSr = [[NSMutableAttributedString alloc]initWithString:strName];[atrSr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xd8d7cb) range: NSMakeRange(0, strName.length)];[atrSr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0x336699) range:[strName rangeOfString:@"设置"]];[atrSr addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0x336699) range:[strName rangeOfString:@"点击"]]; atrSr ;})

