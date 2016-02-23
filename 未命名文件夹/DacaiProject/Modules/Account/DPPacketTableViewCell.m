//
//  DPPacketTableViewCell.m
//  红包页面
//
//  Created by jacknathan on 14-9-12.
//  Copyright (c) 2014年 jacknathan. All rights reserved.
//

#import "DPPacketTableViewCell.h"
#import <MDHTMLLabel/MDHTMLLabel.h>


@interface DPPacketBgView : UIView
{
    MDHTMLLabel         *_numberLabel;
    int                 _sumCount;
}

@property (assign, nonatomic)int sumCount; // 红包数量

@end
@implementation DPPacketBgView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];
        [self buildUI];
    }
    return self;
}
- (void)buildUI
{
    MDHTMLLabel* numberLabel = [[MDHTMLLabel alloc]init];
    //    numberLabel.backgroundColor = [UIColor greenColor];
    numberLabel.font = [UIFont fontWithName:@"Impact" size:15];
    numberLabel.textColor = [UIColor dp_colorFromHexString:@"#f8fdb2"];
    numberLabel.htmlText = [NSString stringWithFormat:@"<font size=10>%@</font>%d",@"￥", self.sumCount];
    numberLabel.adjustsFontSizeToFitWidth = YES;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel = numberLabel;
    
    [self addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-3);
        make.centerY.equalTo(self);
    }];
}
- (int)sumCount
{
    return _sumCount;
}
- (void)setSumCount:(int)sumCount
{
     _sumCount = sumCount;
   
    if (_sumCount <= 99 && _sumCount > 0) {
         _numberLabel.htmlText = [NSString stringWithFormat:@"<font size=10>%@</font>%d",@"￥", _sumCount];
        _numberLabel.font = [UIFont fontWithName:@"Impact" size:17];
        
        return;
    }
    if (_numberLabel.intrinsicContentSize.width >= self.dp_width) {
        [_numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.height.equalTo(self);
            
        }];
    }
     _numberLabel.htmlText = [NSString stringWithFormat:@"<font size=10>%@</font>%d",@"￥", _sumCount];
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DPRedPacketData

@end

@interface DPPacketTableViewCell ()
{
    @private
    DPPacketBgView         *_redPacketView;
    UILabel             *_pktTitleLabel;
    UILabel             *_pktSubTitleLabel;
    MDHTMLLabel         *_leftMoneyLabel;
    UILabel             *_closingDateLabel;
    UILabel             *_isOverDueLabel;
    UILabel             *_sendingTimeLabel;
//    MDHTMLLabel         *_numberLabel; // 红包数量
    DPRedPacketData     *_packetData;
}

@end

@implementation DPPacketTableViewCell
@dynamic packetData;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone; // 取消选中样式
        self.contentView.backgroundColor = [UIColor dp_colorFromHexString:@"#F4F3EF"];
        self.backgroundColor = [UIColor clearColor];

        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    UIView *contentView = self.contentView;
    
    UIImageView *redPackView = [[UIImageView alloc]init];
    redPackView.image = dp_RedPacketImage(@"bg.png");
    
    DPPacketBgView *numberView = [[DPPacketBgView alloc]init];
    
    UILabel *pktTitleLabel = [[UILabel alloc]init];
    pktTitleLabel.font = [UIFont systemFontOfSize:15];
    pktTitleLabel.textColor = [UIColor dp_colorFromHexString:@"#1a1a1a"];
    pktTitleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *pktSubTitleLabel = [[UILabel alloc]init];
    pktSubTitleLabel.textColor = [UIColor dp_colorFromHexString:@"#808080"];
    pktSubTitleLabel.font = [UIFont systemFontOfSize:10];
    pktSubTitleLabel.backgroundColor = [UIColor clearColor];

    [redPackView addSubview:numberView];
//    [numberView addSubview:numberLabel];
    [contentView addSubview:redPackView];
    [contentView addSubview:pktTitleLabel];
    [contentView addSubview:pktSubTitleLabel];
    
    [redPackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentView).offset(10);
        make.left.equalTo(contentView).offset(10);
        make.centerY.equalTo(contentView);
//        make.bottom.equalTo(contentView).offset(-10);
//        make.width.equalTo(contentView).multipliedBy(0.2f);
    }];
    
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(redPackView).offset(-1);
        make.centerY.equalTo(redPackView).offset(7);
        make.width.equalTo(@50);
        make.height.equalTo(@23);
        
    }];
    
//    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(numberView).offset(-3);
//        make.centerY.equalTo(numberView);
//        
//    }];
    
    [pktTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redPackView.mas_right).offset(5);
        make.bottom.equalTo(redPackView.mas_centerY);
        make.width.equalTo(contentView).multipliedBy(0.55f);
       
    }];
    
    [pktSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.left.equalTo(pktTitleLabel);
        make.width.equalTo(pktTitleLabel);
    }];
    
    //最右边的label
    MDHTMLLabel *leftMoneyLabel = [[MDHTMLLabel alloc]init];
    leftMoneyLabel.font = [UIFont systemFontOfSize:12];
    leftMoneyLabel.textAlignment = NSTextAlignmentRight;
    leftMoneyLabel.hidden = YES;
    leftMoneyLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *closingDateLabel = [[UILabel alloc]init];
    closingDateLabel.font = [UIFont systemFontOfSize:10];
    closingDateLabel.textAlignment = NSTextAlignmentRight;
    closingDateLabel.textColor = [UIColor dp_colorFromHexString:@"#808080"];
    closingDateLabel.hidden = YES;
    closingDateLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *isOverDueLabel = [[UILabel alloc]init];
    isOverDueLabel.textAlignment = NSTextAlignmentRight;
    isOverDueLabel.font = [UIFont systemFontOfSize:10];
    isOverDueLabel.textColor = [UIColor redColor];
    isOverDueLabel.hidden = YES;
    isOverDueLabel.textColor = [UIColor dp_colorFromHexString:@"#be0201"];
    isOverDueLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *sendingTimeLabel = [[UILabel alloc]init];
    sendingTimeLabel.font = [UIFont systemFontOfSize:10];
    sendingTimeLabel.textColor = [UIColor dp_colorFromHexString:@"#be0201"];
    sendingTimeLabel.textAlignment = NSTextAlignmentRight;
    sendingTimeLabel.hidden = YES;
    sendingTimeLabel.backgroundColor = [UIColor clearColor];
    
    [contentView addSubview:leftMoneyLabel];
    [contentView addSubview:closingDateLabel];
    [contentView addSubview:isOverDueLabel];
    [contentView addSubview:sendingTimeLabel];
    
    _redPacketView = redPackView;
    _pktTitleLabel = pktTitleLabel;
    _pktSubTitleLabel = pktSubTitleLabel;
    _leftMoneyLabel = leftMoneyLabel;
    _closingDateLabel = closingDateLabel;
    _isOverDueLabel = isOverDueLabel;
    _sendingTimeLabel = sendingTimeLabel;
//    _numberLabel = numberLabel;
    _redPacketView = numberView;
    
    [leftMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(- 10);
        make.centerY.equalTo(pktTitleLabel);
//        make.width.equalTo(contentView).multipliedBy(0.3f);
    }];
    
    [closingDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pktSubTitleLabel);
        make.right.equalTo(leftMoneyLabel);
//        make.width.equalTo(leftMoneyLabel);
    }];
    
    [isOverDueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.right.equalTo(contentView).offset(-10);
//        make.width.equalTo(contentView).multipliedBy(0.2f);
    }];
    
    [sendingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pktTitleLabel).offset(2);
        make.right.equalTo(contentView).offset(-10);
//        make.width.equalTo(contentView).multipliedBy(0.4f);
    }];
    
    
    
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter和setter
- (void)setPacketData:(DPRedPacketData *)packetData
{
    if (packetData == nil) {
        return;
    }
    
    _leftMoneyLabel.hidden = YES;
    _closingDateLabel.hidden = YES;
    _isOverDueLabel.hidden = YES;
    _sendingTimeLabel.hidden = YES;
    
    switch (packetData.packetType) {
        case kPacketUsefulType:
            _leftMoneyLabel.hidden = NO;
            _closingDateLabel.hidden = NO;
            break;
        case kPacketOverdue:
            _isOverDueLabel.hidden = NO;
            break;
        case kPacketSendingType:
            _sendingTimeLabel.hidden = NO;
        default:
            break;
    }
    
    _leftMoneyLabel.htmlText = [NSString stringWithFormat:@"剩余<font color=\"#be0201\">%d</font>元", packetData.leftMoney];
//    _isOverDueLabel.text = packetData.packetState == kPacketBeUsed ? @"已用完" : @"已过期" ;
    if (![self isStringEmty:packetData.packetState]) {
        _isOverDueLabel.text = packetData.packetState;
    }
    if (![self isStringEmty:packetData.closingDate]) {
         _closingDateLabel.text = [NSString stringWithFormat:@"%@", packetData.closingDate];
    }
    
    if (![self isStringEmty:packetData.sendingTime]) {
        _sendingTimeLabel.text = [NSString stringWithFormat:@"派发时间 ：%@", packetData.sendingTime];
    }
//    if (![self isStringEmty:packetData.packetImgName]) {
//        _redPacketView.image = dp_AppRootImage(packetData.packetImgName);//[UIImage imageNamed:packetData.packetImgName];
//    }
    if (packetData.packetNumber) {
        
        _redPacketView.sumCount = packetData.packetNumber;
    }
    
    if (![self isStringEmty:packetData.packetTitle]) {
        _pktTitleLabel.text = packetData.packetTitle;
    }
    
    if (![self isStringEmty:packetData.packetSubTitle]) {
        _pktSubTitleLabel.text = packetData.packetSubTitle;
    }
    _packetData = packetData;
}
- (DPRedPacketData *)packetData
{
    return _packetData;
}

- (BOOL)isStringEmty:(NSString *)string
{
   return  string.length > 0 && string != nil ? NO : YES;
    
}
@end
