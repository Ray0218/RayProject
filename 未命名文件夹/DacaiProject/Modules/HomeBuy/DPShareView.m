//
//  DPShareView.m
//  DacaiProject
//
//  Created by jacknathan on 14-12-9.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPShareView.h"
#import "DPImageLabel.h"
#define KShareBtnTagBase 10
#define kShareBtnCommonH 78
#define kShareBtnCommonW 75
@implementation DPShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dp_buildCommonUI];
    }
    return self;
}
- (void)dp_buildCommonUI
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont dp_systemFontOfSize:15];
        label.text = @"分享到";
        label.textColor = [UIColor dp_colorFromHexString:@"#363633"];
        label;
    });
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor dp_colorFromHexString:@"#C7C7C6"];
    
    //    DPImageLabel *fCircleView = [self imageLabelWithTitle:@"朋友圈" imgName:@"weixin_03.png"];
    //    DPImageLabel *friendsView = [self imageLabelWithTitle:@"微信好友" imgName:@"weixin_03.png"];
    //    DPImageLabel *weiboView = [self imageLabelWithTitle:@"微博" imgName:@"weibo_03.png"];
    //    DPImageLabel *qqZoneView = [self imageLabelWithTitle:@"QQ空间" imgName:@"kongjian_03.png"];
    
    NSString *circleImgName = @"朋友圈_03.png";
    NSString *friendsImgName = @"weixin_03.png";
    NSString *WBImgName = @"weibo_03.png";
//    NSString *qqImgName = @"kongjian_03.png";
    BOOL wxEnabled = YES;
    BOOL wbEnabled = YES;
    
    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeWXF]){
        circleImgName = @"Circle-of-Friends.png";
        friendsImgName = @"weichat.png";
        wxEnabled = NO;
    }
    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeSinaWB]) {
        WBImgName = @"weibo.png";
        wbEnabled = NO;
    }
//    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeSinaWB]) {
//        WBImgName = @"weibo.png";
//    }
//    if (![[DPThirdCallCenter sharedInstance] dp_isInstalledAPPType:kThirdShareTypeQQzone]) {
//        
//    }
   
    UIButton *fCirclebtn = [self commonBtnWithTag:KShareBtnTagBase + 0 title:@"朋友圈" imgName:circleImgName enabled:wxEnabled];
    UIButton *friendsBtn = [self commonBtnWithTag:KShareBtnTagBase + 1 title:@"微信好友" imgName:friendsImgName enabled:wxEnabled];
    UIButton *weiboBtn = [self commonBtnWithTag:KShareBtnTagBase + 2 title:@"微博" imgName:WBImgName enabled:wbEnabled];
    UIButton *qqZoneBtn = [self commonBtnWithTag:KShareBtnTagBase + 3 title:@"QQ空间" imgName:@"kongjian_03.png" enabled:YES];
    
    UIButton *cancelBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_colorFromHexString:@"#F5F5F5"]] forState:UIControlStateHighlighted];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_colorFromHexString:@"#6D6D67"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [[UIColor dp_colorFromHexString:@"#C7C7C6"]CGColor];
        button.layer.borderWidth = 0.5f;
        button.tag = KShareBtnTagBase + 10;
        button;
    });
    
    [self addSubview:contentView];
    [contentView addSubview:headerView];
    [headerView addSubview:titleLabel];
    [headerView addSubview:topLine];
    [contentView addSubview:fCirclebtn];
    [contentView addSubview:friendsBtn];
    [contentView addSubview:weiboBtn];
    [contentView addSubview:qqZoneBtn];
    [contentView addSubview:cancelBtn];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@197);
        make.center.equalTo(self);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(@40);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView);
        make.right.equalTo(headerView);
        make.bottom.equalTo(headerView);
        make.height.equalTo(@0.5);
    }];
    
    [fCirclebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(18);
        make.left.equalTo(contentView).offset(10);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fCirclebtn);
        make.left.equalTo(fCirclebtn.mas_right).offset(1);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fCirclebtn);
        make.left.equalTo(friendsBtn.mas_right).offset(1);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [qqZoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fCirclebtn);
        make.left.equalTo(weiboBtn.mas_right).offset(1);
        make.width.equalTo(@kShareBtnCommonW);
        make.height.equalTo(@kShareBtnCommonH);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(108);
        make.centerX.equalTo(contentView);
        make.height.equalTo(@36);
        make.width.equalTo(@280);
    }];
}
- (UIButton *)commonBtnWithTag:(int)tag title:(NSString *)title imgName:(NSString *)imgName enabled:(BOOL)enabled
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage dp_imageWithColor:[UIColor dp_colorFromHexString:@"F5F5F5"]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    button.userInteractionEnabled = enabled;
    
    DPImageLabel *imageLabel = [self imageLabelWithTitle:title imgName:imgName];
    [button addSubview:imageLabel];
    
    [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
        make.width.equalTo(button);
        make.height.equalTo(button);
    }];
    
    return button;
}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    DPLog(@"button click - ---  tag = %d", sender.tag);
    if (sender.tag == KShareBtnTagBase + 10) {
        if ([self.delegate respondsToSelector:@selector(shareViewCancel)]) {
            [self.delegate shareViewCancel];
        }
        [self removeFromSuperview];
        return;
    }
    kThirdShareType type = kThirdShareTypeUnknown;
    switch (sender.tag - KShareBtnTagBase) {
        case 0:
            type = kThirdShareTypeWXC;
            break;
        case 1:
            type = kThirdShareTypeWXF;
            break;
        case 2:
            type = kThirdShareTypeSinaWB;
            break;
        case 3:
            type = kThirdShareTypeQQzone;
        default:
            break;
    }
    if (type == kThirdShareTypeUnknown) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(shareWithThirdType:)]) {
        [self.delegate shareWithThirdType:type];
    }
//    [[DPThirdCallCenter sharedInstance] dp_shareWithType:type title:nil content:nil];
}
- (DPImageLabel *)imageLabelWithTitle:(NSString *)title imgName:(NSString *)imgName
{
    DPImageLabel *imgLabel = [[DPImageLabel alloc]init];
    imgLabel.imagePosition = DPImagePositionTop;
    imgLabel.image = dp_AccountImage(imgName);
    imgLabel.text = title;
    imgLabel.textColor = [UIColor dp_colorFromHexString:@"#6D6D67"];
    imgLabel.font = [UIFont dp_systemFontOfSize:14];
    imgLabel.userInteractionEnabled = NO;
    return imgLabel;
}

@end
