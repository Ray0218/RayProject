//
//  DPRank3TransferVC.m
//  DacaiProject
//
//  Created by sxf on 14-7-11.
//  Copyright (c) 2014年 dacai. All rights reserved.
// 排三中转

#import "DPRank3TransferVC.h"
#import "DPPsBuyViewController.h"
#import "DPDigitalCommon.h"

@interface DPRank3TransferVC () {
  @private
    CPick3 *_CRTInstance;
}
@end

@implementation DPRank3TransferVC
- (id)init {
    self = [super init];
    if (self) {
        self.title = @"排列三投注";
        self.digitalType=GameTypePs;
        _CRTInstance->SetDelegate(self);
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.issureTableView reloadData];
    [self calculateAllZhushuWithZj:self.addButton.selected];
    //下拉选一注View隐藏
    self.addyizhuView.hidden = _CRTInstance->GetTargetNum() > 0 ? YES : NO;
    _CRTInstance->SetDelegate(self);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _CRTInstance->GetTargetNum();
}

- (void)touzhuInfotableCell:(DP3DDigitalBuyCell *)cell indexPath:(NSIndexPath *)indexPath {
    UIFont *font = [UIFont dp_regularArialOfSize:14];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:@""];
    int index = indexPath.row;
    int subType;
    int num1[PSNum] = {0};
    int num2[PSNum] = {0};
    int num3[PSNum] = {0};
    int note;
    _CRTInstance->GetTarget(index, subType,note, num1, num2, num3);
    NSString *bai = @"";
    NSString *shi = @"";
    NSString *ge = @"";
    if (subType == PSTypeDirect) {
        for (int i = 0; i < PSNum; i++) {
            if (num1[i] == 1) {
                bai = bai.length>0?[NSString stringWithFormat:@"%@ %d", bai, i]:[NSString stringWithFormat:@"%d",i];
            }
            if (num2[i] == 1) {
                shi = shi.length>0?[NSString stringWithFormat:@"%@ %d", shi, i]:[NSString stringWithFormat:@"%d",i];
            }
            if (num3[i] == 1) {
                ge = ge.length>0?[NSString stringWithFormat:@"%@ %d", ge, i]:[NSString stringWithFormat:@"%d",i];
            }
        }
        if (note==1) {
            [hintString1 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@  %@", bai, shi, ge]]];
             [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
        }else{
        [hintString1 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | %@ | %@", bai, shi, ge]]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, bai.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(bai.length+1, 1)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(bai.length + 3, shi.length)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithRed:0.79 green:0.71 blue:0.64 alpha:1.0] CGColor] range:NSMakeRange(bai.length+shi.length+4,1)];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(bai.length+shi.length+6, ge.length)];
        }

    } else {
        for (int i = 0; i < PSNum; i++) {
            if (num1[i] == 1) {
                bai = [NSString stringWithFormat:@"%@ %d", bai, i];
            }
        }
        [hintString1 appendAttributedString:[[NSAttributedString alloc] initWithString:bai]];
        [hintString1 addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[[UIColor dp_flatRedColor] CGColor] range:NSMakeRange(0, hintString1.length)];
    }
   cell.buyTypelabel.text = [self lotteryStringIndex:subType];

    if (_CRTInstance->NotesCalculate(num1, num2, num3, subType) > 1) {
        cell.zhushuLabel.text = [NSString stringWithFormat:@"复式 %d注 %d元", _CRTInstance->NotesCalculate(num1, num2, num3, subType), _CRTInstance->NotesCalculate(num1, num2, num3, subType) * 2];
        
    } else {
        cell.zhushuLabel.text = [NSString stringWithFormat:@"单式 %d注 %d元", _CRTInstance->NotesCalculate(num1, num2, num3, subType), _CRTInstance->NotesCalculate(num1, num2, num3, subType) * 2];
    }
    if (fontRef) {
        [hintString1 addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,hintString1.length)];
        CFRelease(fontRef);
    }
    [cell.infoLabel setText:hintString1];
}

- (NSString *)lotteryStringIndex:(int)index {
    NSString *title = @"";
    switch (index) {
        case PSTypeDirect:
            title = @"直选";
            break;
        case PSTypeGroup3:
            title = @"组三";
            break;
        case PSTypeGroup6:
            title = @"组六";
            break;

        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", indexPath.row];
    DP3DDigitalBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[DP3DDigitalBuyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier
                                                   ];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell changeCurrentViewHeight:[self gainOneRowHight:indexPath]+39.0];
    [self touzhuInfotableCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPPsBuyViewController *vc = [[DPPsBuyViewController alloc] init];
    vc.targetIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

-(float )gainOneRowHight:(NSIndexPath *)indexPath{
    int height=0;
    NSString *hintString1=@"";
    int index = indexPath.row;
    int subType;
    int num1[SDNum] = {0};
    int num2[SDNum] = {0};
    int num3[SDNum] = {0};
    int note;
    _CRTInstance->GetTarget(index, subType, note,num1, num2, num3);
    if (subType == PSTypeDirect) {
        NSString *bai = @"";
        NSString *shi = @"";
        NSString *ge = @"";
        for (int i = 0; i < SDNum; i++) {
            if (num1[i] == 1) {
                if (bai.length<=0) {
                    bai=[NSString stringWithFormat:@"%d",i];
                }else{
                    bai = [NSString stringWithFormat:@"%@ %d", bai, i];
                }
            }
            if (num2[i] == 1) {
                if (shi.length<=0) {
                    shi=[NSString stringWithFormat:@"%d",i];
                }else{
                    shi = [NSString stringWithFormat:@"%@ %d", shi, i];
                }
            }
            if (num3[i] == 1) {
                if (ge.length<=0) {
                    ge=[NSString stringWithFormat:@"%d",i];
                }else{
                    ge = [NSString stringWithFormat:@"%@ %d", ge, i];
                }
            }
        }
        if (note==1) {
            hintString1=[NSString stringWithFormat:@"%@  %@  %@", bai, shi, ge];
        }else{
        hintString1=[NSString stringWithFormat:@"%@ | %@ | %@", bai, shi, ge];
    }
    
        CGSize fitLabelSize = CGSizeMake(260, 2000);
        CGSize labelSize = [hintString1 sizeWithFont:[UIFont dp_systemFontOfSize:14.0] constrainedToSize:fitLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        height=labelSize.height;
    }
    return height;
    
}

//删除一注
- (void)deleteBuyCell:(DPDigitalBuyCell *)cell {

    NSIndexPath *indexPath = [self.issureTableView indexPathForCell:cell];
    _CRTInstance->DelTarget(indexPath.row);
    [self.issureTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.addyizhuView.hidden = _CRTInstance->GetTargetNum() > 0 ? YES : NO;
}
//自选一注
- (void)addOneZhu {
    DPPsBuyViewController *vc = [[DPPsBuyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];}
//计算注数

-(void)calculateAllZhushuWithZj:(BOOL)addorNot
{
    int zhushu =_CRTInstance->GetTotalNote();
    if (zhushu<=0) {
        self.issureTableView.tableFooterView.hidden = YES ;
    }else{
        self.issureTableView.tableFooterView.hidden = NO ;
    }
        
    NSString* currentMoney=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]];
    NSString *money=[NSString stringWithFormat:@"%d",zhushu*2*[self.addTimesTextField.text integerValue]*[self.addIssueTextField.text integerValue]];
    NSMutableAttributedString *hintString1 ;
    if ([self.addIssueTextField.text integerValue]>1) {
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
    int multiple = [self.addTimesTextField.text integerValue] > 0 ? [self.addTimesTextField.text integerValue] : 1;
    int followCount = [self.addIssueTextField.text integerValue] > 0 ? [self.addIssueTextField.text integerValue] : 1;
    BOOL winedStop = self.afterWinStop;
    _CRTInstance->SetOrderInfo(multiple, followCount, winedStop);
    _CRTInstance->SetTogetherType(0);
}
- (int)toGoPayMoney {
  
    int index = _CRTInstance->GoPay();
    return index;
}
-(int )getPayTotalMoney{
    int index=_CRTInstance->GetTotalNote();
    return index*2;
    
}
-(NSString *)orderInfoUrl{
    int buyType; string token;
    _CRTInstance->GetWebPayment(buyType, token);
    return kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
}
-(void)togetherType{
    int multiple = [self.addTimesTextField.text integerValue] > 0 ? [self.addTimesTextField.text integerValue] : 1;
    int followCount = [self.addIssueTextField.text integerValue] > 0 ? [self.addIssueTextField.text integerValue] : 1;
    BOOL winedStop = self.afterWinStop;
    _CRTInstance->SetOrderInfo(multiple, followCount, winedStop);
    _CRTInstance->SetTogetherType(1);
}

- (void)digitalRandomData {
    int num1[PSNum] = {0};
    [self partRandom:1 total:PSNum target2:num1];
    
    int num2[PSNum] = {0};
    [self partRandom:1 total:PSNum target2:num2];
    int num3[PSNum] = {0};
    [self partRandom:1 total:PSNum target2:num3];
    
    _CRTInstance->AddTarget(num1, num2, num3, PSTypeDirect);
    [self.issureTableView reloadData];
    self.addyizhuView.hidden = _CRTInstance->GetTargetNum() > 0 ? YES : NO;
}

- (void)pvt_onBack {
    if (_CRTInstance->GetTargetNum()<=0) {
        
        if (self.xt_sideMenuViewController.visibleType == XTSideMenuVisibleTypeLeft) {
            [DPAppParser backToCenterRootViewController:YES] ;
        }else
            
            [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - 定时器相关
- (void)loadInstance {
    _CRTInstance = CFrameWork::GetInstance()->GetPick3();
}

- (void)dealloc {
    _CRTInstance->ClearTarget();
    _CRTInstance->ClearGameInfo();
}

- (NSInteger)timeSpace {
    return g_psTimeSpace;
}

- (void)setTimeSpace:(NSInteger)timeSpace {
    g_psTimeSpace = timeSpace;
}

- (void)sendRefresh {
    _CRTInstance->Refresh();
}

- (void)recvRefresh:(BOOL)fromAppdelegate {
    int gameName, globalSurplus; string endTime;
    if (_CRTInstance->GetInfo(gameName, endTime, globalSurplus) >= 0) {
        NSTimeInterval timeInterval = [[NSDate dp_dateFromString:[NSString stringWithUTF8String:endTime.c_str()] withFormat:dp_DateFormatter_YYYY_MM_dd_HH_mm_ss] timeIntervalSinceDate:[NSDate dp_date]];
        
        if (timeInterval > 0) {
            self.timeSpace = timeInterval;
        } else {
            self.timeSpace = -60;
        }
    }
}

- (BOOL)isBuyController:(UIViewController *)viewController {
    return [viewController isMemberOfClass:[DPPsBuyViewController class]];
}

@end
