//
//  DPPacketTableViewCell.h
//  红包页面
//
//  Created by jacknathan on 14-9-12.
//  Copyright (c) 2014年 jacknathan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kPacketUsefulType, // 可使用
    kPacketSendingType, // 派发中
    kPacketOverdue, // 已用完/过期
} kPacketType;

//typedef enum {
//    kPacketDeadline, // 过期
//    kPacketBeUsed,  // 用完
//} kPacketState;

@interface DPRedPacketData : NSObject

@property(nonatomic, assign)kPacketType     packetType;
//@property(nonatomic, copy)NSString          *packetImgName;
@property(nonatomic, copy)NSString          *packetTitle;
@property(nonatomic, copy)NSString          *packetSubTitle;
@property(nonatomic, assign)int             leftMoney;
@property(nonatomic, copy)NSString          *closingDate;
@property(nonatomic, copy)NSString        *packetState;
@property(nonatomic, copy)NSString          *sendingTime;
@property(nonatomic, assign)int             packetNumber;

@end


@interface DPPacketTableViewCell : UITableViewCell

@property(strong, nonatomic)DPRedPacketData     *packetData;
@end

