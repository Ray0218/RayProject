//
//  DPSevenLuckTransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-10.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPSevenLuckTransferVC.h"
#import "DPSevenHappyLotteryVC.h"
#import "DPDigitalCommon.h"
@interface DPSevenLuckTransferVC () {
  @private
    CSevenLuck *_CSLLInstance;
}
@end

@implementation DPSevenLuckTransferVC
-(id)init{
    self = [super init];
    if (self) {
        self.title = @"七乐彩投注";
        self.digitalType=GameTypeQlc;
        
        _CSLLInstance->SetDelegate(self);
    }
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:self.addButton.selected];
    //下拉选一注View隐藏
    self.addyizhuView.hidden=_CSLLInstance->GetTargetNum()>0?YES:NO;
    _CSLLInstance->SetDelegate(self);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CSLLInstance->GetTargetNum();
}

- (void)touzhuInfotableCell:(DPDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {

    NSString *ballInfo = @"";
    NSString *zhushuInfo = @"";
    int index = indexPath.row;
    int num[QLCNUM];
    int note;
    _CSLLInstance->GetTarget(index, num,note);
    NSString *ballNum = @"";
    for (int i = 0; i < QLCNUM; i++) {
        if (num[i] == 1) {
             ballNum = [NSString stringWithFormat:@"%@ %02d", ballNum, i + 1];
        }
    }
    int count = _CSLLInstance->NotesCalculate(num);
    NSString *singeString = @"单式";
    if (count > 1) {
        singeString = @"复式";
    }
    ballInfo = [NSString stringWithFormat:@"%@", ballNum];
    zhushuInfo = [NSString stringWithFormat:@"%@ %d注 %d元", singeString, count, 2 * count];

    cell.infoLabel.text = ballInfo;
    cell.infoLabel.textColor=UIColorFromRGB(0xe7161a);
    cell.zhushuLabel.text = zhushuInfo;
}
//得到当前单元格的高度
-(float )gainOneRowHight:(NSIndexPath *)indexPath{
    int height=0;
    int index = indexPath.row;
    int red[QLCNUM];
    int note;
    _CSLLInstance->GetTarget(index, red,note);
    NSString *infoString = @"";
    for (int i = 0; i < SSQREDNUM; i++) {
        if (red[i] == 1) {
            if (infoString.length<=0) {
                infoString=[NSString stringWithFormat:@"%02d", i + 1];
            }else{
                infoString = [NSString stringWithFormat:@"%@ %02d", infoString, i + 1];
            }
        }
    }
    CGSize fitLabelSize = CGSizeMake(260, 2000);
    CGSize labelSize = [infoString sizeWithFont:[UIFont dp_systemFontOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    height=labelSize.height;
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPSevenHappyLotteryVC *vc=[[DPSevenHappyLotteryVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc jumpToSelectPage:indexPath.row gameType:_SevenHappyLotteryBuyNormalType];

}

//删除一注
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {

    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CSLLInstance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.addyizhuView.hidden=_CSLLInstance->GetTargetNum()>0?YES:NO;
}
//自选一注
- (void)addOneZhu {
    DPSevenHappyLotteryVC *vc=[[DPSevenHappyLotteryVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{
    int zhushu = 0;
    for (int i = 0; i < _CSLLInstance->GetTargetNum(); i++) {
        int index = i;
        int num[QLCNUM];
        int note;
        _CSLLInstance->GetTarget(index, num,note);
        zhushu = zhushu + _CSLLInstance->NotesCalculate(num);
    }
    
    if (zhushu<=0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else{
        self.issureTableView.tableFooterView.hidden = NO ;
    }
        
    NSString* currentMoney=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]];
    NSString *money =[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString *hintString1 ;
    if ([self.addIssueTextField.text integerValue] >1) {
        hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@元(本期%@元)\n%d注 %@倍 %@期", money,currentMoney,zhushu,self.addTimesTextField.text,self.addIssueTextField.text]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatWhiteColor] CGColor] range:NSMakeRange(0,hintString1.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(1,money.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:1.0 green:0.96 blue:0.22 alpha:1.0] CGColor] range:NSMakeRange(5+money.length,currentMoney.length)];
    } else {
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
    _CSLLInstance->SetOrderInfo(multiple, followCount, winedStop);
    _CSLLInstance->SetTogetherType(0);
}
- (int)toGoPayMoney {
  
    int index = _CSLLInstance->GoPay();
    return index;
}
-(int )getPayTotalMoney{
    int index=_CSLLInstance->GetTotalNote();
    return index*2;
    
}
-(NSString *)orderInfoUrl{
    int buyType; string token;
    _CSLLInstance->GetWebPayment(buyType, token);
    return kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
}
-(void)togetherType{
    int multiple=[self.addTimesTextField.text integerValue]>0?[self.addTimesTextField.text integerValue]:1;
    int followCount=[self.addIssueTextField.text integerValue]>0?[self.addIssueTextField.text integerValue]:1;
    BOOL winedStop=self.afterWinStop;
    _CSLLInstance->SetOrderInfo(multiple, followCount, winedStop);
    _CSLLInstance->SetTogetherType(1);
}
-(void)digitalRandomData{
    int red[50] = {0};
    [self partRandom:7 total:QXCNum target2:red];
    _CSLLInstance->AddTarget(red);
    [self.issureTableView reloadData];
    self.addyizhuView.hidden=_CSLLInstance->GetTargetNum()>0?YES:NO;
}
- (void)pvt_onBack {
    
    if (_CSLLInstance->GetTargetNum() <= 0) {
        if(self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft)
        {
            [DPAppParser backToCenterRootViewController:YES];
            
        }else{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }

        return ;
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

- (void)dealloc {
    _CSLLInstance->ClearTarget();
    _CSLLInstance->ClearGameInfo();
}

#pragma mark - 定时器相关
- (void)loadInstance {
    _CSLLInstance = CFrameWork::GetInstance()->GetSevenLuck();
}

- (NSInteger)timeSpace {
    return g_qlcTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_qlcTimeSpace = timeSpace;
}

- (void)sendRefresh {
    _CSLLInstance->Refresh();
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName, globalSurplus; string endTime;
    if (_CSLLInstance->GetInfo(gameName, endTime, globalSurplus) >= 0) {
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        } else {
            self.timeSpace = -60;
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPSevenHappyLotteryVC class]];
}

@end
