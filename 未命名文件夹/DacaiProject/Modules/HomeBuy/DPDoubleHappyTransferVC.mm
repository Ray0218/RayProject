//
//  DPDoubleHappyTransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-8.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPDoubleHappyTransferVC.h"
#import "DPDoubleHappyLotteryVC.h"
#import "DPDigitalCommon.h"
#import "DPNotifyCapturer.h"

@interface DPDoubleHappyTransferVC () {
@private
    CDoubleChromosphere *_CDInstance;
}
@end

@implementation DPDoubleHappyTransferVC

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"双色球投注";
        self.digitalType = GameTypeSsq;
        
        _CDInstance->SetDelegate(self);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:self.addButton.selected];
    //下拉选一注View隐藏
    self.addyizhuView.hidden = _CDInstance->GetTargetNum() > 0 ? YES : NO;
    _CDInstance->SetDelegate(self);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CDInstance->GetTargetNum();
}

- (void)touzhuInfotableCell:(DPDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@""];
    NSString *zhushuInfo = @"";

    int index = indexPath.row;
    int blue[SSQBLUENUM];
    int red[SSQREDNUM];
    int note;
    int mark;
    _CDInstance->GetTarget(index, blue, red,note,mark);
    NSString *redDan = @"";
    NSString *redTuo = @"";
    NSString *blueBall = @"";

    for (int i = 0; i < SSQREDNUM; i++) {
        if (red[i] == 1) {
            if (redTuo.length<=0) {
                redTuo=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
             redTuo = [NSString stringWithFormat:@"%@ %02d", redTuo, i + 1];
            }
        } else if (red[i] == -1) {
            if (redDan.length<=0) {
                redDan=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
             redDan = [NSString stringWithFormat:@"%@ %02d", redDan, i + 1];
            }
        }
    }
    for (int i = 0; i < SSQBLUENUM; i++) {
        if (blue[i] == 1) {
            if (blueBall.length<=0) {
                blueBall=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
            blueBall = [NSString stringWithFormat:@"%@ %02d", blueBall, i + 1];
            }
        }
    }
    UIFont *font = [UIFont dp_regularArialOfSize:14];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (mark) {
       
        [hintString1 appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@) %@ %@",redDan,redTuo,blueBall]]];
        if (fontRef) {
            [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
            CFRelease(fontRef);
        }

        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0,redDan.length+redTuo.length+3)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x1e50a2) CGColor] range:NSMakeRange(redDan.length+redTuo.length+4,blueBall.length)];
        zhushuInfo = [NSString stringWithFormat:@"胆拖  %d注 %d元", note, 2 * note];
    } else {
        [hintString1 appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",redTuo,blueBall]]];
        if (fontRef) {
            [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
            CFRelease(fontRef);
        }
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0xe7161a) CGColor] range:NSMakeRange(0,redTuo.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColorFromRGB(0x1e50a2) CGColor] range:NSMakeRange(redTuo.length+1,blueBall.length)];
        if (note <= 1) {
            zhushuInfo = [NSString stringWithFormat:@"单式  %d注 %d元", note, 2 * note];
        } else {
            zhushuInfo = [NSString stringWithFormat:@"复式  %d注 %d元", note, 2 * note];
        }
    }
    [cell.infoLabel setText:hintString1];
    cell.zhushuLabel.text = zhushuInfo;
}
- (int)buyTypeForOneRow:(int)row {
    int buytype = _DoubleColorBallNormalType;
    int index = row;
    int blue[SSQBLUENUM];
    int red[SSQREDNUM];
    int note;
    int mark;
    _CDInstance->GetTarget(index, blue, red,note,mark);
    for (int i = 0; i < SSQREDNUM; i++) {
        if (red[i] == -1) {
            return _DoubleColorBallDanType;
        }
    }

    return buytype;
}

//得到当前单元格的高度
-(float )gainOneRowHight:(NSIndexPath *)indexPath{
    int height=0;
    int index = indexPath.row;
    int blue[SSQBLUENUM];
    int red[SSQREDNUM];
    int note;
    int mark;
    _CDInstance->GetTarget(index, blue, red,note,mark);
    NSString *redDan = @"";
    NSString *redTuo = @"";
    NSString *blueBall = @"";
    NSString *infoBall=@"";
    
    for (int i = 0; i < SSQREDNUM; i++) {
        if (red[i] == 1) {
            if (redTuo.length<=0) {
                redTuo=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                redTuo = [NSString stringWithFormat:@"%@ %02d", redTuo, i + 1];
            }
        } else if (red[i] == -1) {
            if (redDan.length<=0) {
                redDan=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                redDan = [NSString stringWithFormat:@"%@ %02d", redDan, i + 1];
            }
        }
    }
    for (int i = 0; i < SSQBLUENUM; i++) {
        if (blue[i] == 1) {
            if (blueBall.length<=0) {
                blueBall=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                blueBall = [NSString stringWithFormat:@"%@ %02d", blueBall, i + 1];
            }
        }
    }
    if (redDan.length>0) {
        infoBall=[NSString stringWithFormat:@"(%@) %@ %@",redDan,redTuo,blueBall];
    }else{
        infoBall=[NSString stringWithFormat:@"%@ %@",redTuo,blueBall];
    }
    
    CGSize fitLabelSize = CGSizeMake(260, 2000);
    CGSize labelSize = [infoBall sizeWithFont:[UIFont dp_systemFontOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    height=labelSize.height;
    return height;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.addIssueTextField resignFirstResponder];
    [self.addTimesTextField resignFirstResponder];
    DPDoubleHappyLotteryVC *vc=[[DPDoubleHappyLotteryVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc jumpToSelectPage:indexPath.row gameType:[self buyTypeForOneRow:indexPath.row]];
}

//删除一注
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {

    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CDInstance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.addyizhuView.hidden=_CDInstance->GetTargetNum()>0?YES:NO;
}
//自选一注
- (void)addOneZhu {
    DPDoubleHappyLotteryVC *vc=[[DPDoubleHappyLotteryVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([NSStringFromClass([vc class]) isEqualToString:@"DPDoubleHappyLotteryVC"]) {
//            DPDoubleHappyLotteryVC *viewControler = (DPDoubleHappyLotteryVC *)vc;
//            [viewControler jumpToSelectPage:_CDInstance->GetTargetNum() gameType:_DoubleColorBallNormalType];
//        }
//    }
}
//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{

    int zhushu = _CDInstance->GetTotalNote();
    if (zhushu == 0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else
    {
        self.issureTableView.tableFooterView.hidden = NO ;
    }
    NSString* currentMoney=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]];
    NSString *money=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString *hintString1 ;
    if ([self.addIssueTextField.text integerValue] >1) {
       hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元(本期%@元)\n%d注 %@倍 %@期", money,currentMoney,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(5+money.length,currentMoney.length)];
    }else{
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元\n%d注 %@倍 %@期", money,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];

        
    }

    
    [self.bottomLabel setText:hintString1];

}


-(void)OrderInfoMultiple{
    int multiple=[self.addTimesTextField.text integerValue]>0?[self.addTimesTextField.text integerValue]:1;
    int followCount=[self.addIssueTextField.text integerValue]>0?[self.addIssueTextField.text integerValue]:1;
    BOOL winedStop=self.afterWinStop;
    _CDInstance->SetOrderInfo(multiple, followCount, winedStop);
     _CDInstance->SetTogetherType(0);
}
- (int)toGoPayMoney {
   
    int index = _CDInstance->GoPay();
    return index;
}
-(int )getPayTotalMoney{
    int index=_CDInstance->GetTotalNote();
    return index*2;

}
-(NSString *)orderInfoUrl{
    int buyType; string token;
    _CDInstance->GetWebPayment(buyType, token);
    return kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
}
-(void)togetherType{
    int multiple=[self.addTimesTextField.text integerValue]>0?[self.addTimesTextField.text integerValue]:1;
    int followCount=[self.addIssueTextField.text integerValue]>0?[self.addIssueTextField.text integerValue]:1;
    BOOL winedStop=self.afterWinStop;
    _CDInstance->SetOrderInfo(multiple, followCount, winedStop);
    _CDInstance->SetTogetherType(1);
}
-(void)digitalRandomData{
    int red[SSQREDNUM] = {0};
    [self partRandom:6 total:SSQREDNUM target2:red];
    
    int blue[SSQBLUENUM] = {0};
    [self partRandom:1 total:SSQBLUENUM target2:blue];
    
    _CDInstance->AddTarget(blue, red);
    [self.issureTableView reloadData];
    self.addyizhuView.hidden=_CDInstance->GetTargetNum()>0?YES:NO;
}

- (void)pvt_onBack {
    if (_CDInstance->GetTargetNum() <= 0) {
        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [DPAppParser backToCenterRootViewController:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"返回购买大厅将清空所有投注内容" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
                [DPAppParser backToCenterRootViewController:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - 定时器相关
- (void)loadInstance {
    _CDInstance = CFrameWork::GetInstance()->GetDoubleChromosphere();
}

- (void)dealloc {
    _CDInstance->ClearTarget();
    _CDInstance->ClearGameInfo();
}

- (NSInteger)timeSpace {
    return g_ssqTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_ssqTimeSpace = timeSpace;
}

- (void)sendRefresh {
    _CDInstance->Refresh();
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName, globalSurplus; string endTime;
    if (_CDInstance->GetInfo(gameName, endTime, globalSurplus) >= 0) {
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        } else {
            self.timeSpace = -60;
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPDoubleHappyLotteryVC class]];
}

@end
